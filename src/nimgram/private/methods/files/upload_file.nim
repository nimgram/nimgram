# Nimgram
# Copyright (C) 2020-2021 Daniele Cortesi <https://github.com/dadadani>
# This file is part of Nimgram, under the MIT License
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY
# OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import asyncfile
import md5
import os
import asyncfutures
import asyncstreams
import sugar
import mimetypes

# Note: Super experimental/broken/slow/unstable things here

proc urandom64(): int64 =
    var bytes = urandom(8)
    copyMem(addr result, addr bytes[0], 8)

const BLOCK_SIZE = 512 * 1024

const MAX_FILE_SIZE = 2000 * 1024 * 1024

const MAX_SMALL_FILE_SIZE = 10 * 1024 * 1024

proc uploadInternalFile(self: NimgramClient, fileLocation: string): Future[
        InputFile] {.async.} =

    
    proc sessionWorker(queue: FutureStream, session: Session) {.async.} =
        ## Worker
        ## Takes data from the queue and sends to Telegram
        
        while true:
            let data = await queue.read()
            if not data[0]:
                asyncCheck session.stop()
                return
            discard await session.send(data[1])

    let file = openAsync(fileLocation)
    let size = file.getFileSize()

    if size == 0:
        raise newException(CatchableError, "File size equals to 0 Bytes")

    if size > MAX_FILE_SIZE:
        raise newException(CatchableError, "Telegram doesn't support uploading files bigger than 2000 MiB")

    let blocksCount = int32(ceil(int(size) / BLOCK_SIZE))

    # Check if file is bigger than 10MiB
    let isBig = size > MAX_SMALL_FILE_SIZE
    let workersCount = if isBig: 4 else: 1
    let poolCount = if isBig: 3 else: 1
    
    let sessions = InternalTableOptions(
            original: await self.storageManager.getSessionsInfo())
    # Sessions initialization
    let pool = collect newSeq:
        for i in 1..poolCount:
            collect newSeq:
                for i in 1..workersCount:
                    await self.getSession(sessions, self.mainDc,
                            self.config.transportMode, self.config.useIpv6,
                            self.config.testMode, self.storageManager, self.config, true)


    for workers in pool:
        for worker in workers:
            asyncCheck worker.startHandler(self, newUpdateHandler())
            await worker.sendMTProtoInit(false, false, true)
            worker.initDone = true
            worker.isRequired = true


    let queue = newFutureStream[TL]()
    let sessionWorkers = collect newSeq:
        for workers in pool:
            for worker in workers:
                sessionWorker(queue, worker)
    for worker in sessionWorkers: asyncCheck worker

    let fileID = urandom64()

    var filePart: int32 = 0
    var md5ctx: MD5Context
    md5Init(md5ctx)

    ## Add files to the queue
    while true:
        let fileBlock = await file.read(BLOCK_SIZE)

        if fileBlock == "":
            break

        let fileBlockBytes = cast[seq[uint8]](fileBlock)

        if isBig:
            await queue.write(UploadSaveBigFilePart(
                file_id: fileID,
                file_part: filePart,
                file_total_parts: blocksCount,
                bytes: fileBlockBytes
            ))

        else:

            ## Updates the md5 sum (required for small files)
            md5ctx.md5Update(cstring(fileBlock), fileBlock.len)

            await queue.write(UploadSaveFilePart(
                file_id: fileID,
                file_part: filePart,
                bytes: fileBlockBytes
            ))
        filePart += 1

    queue.complete()
    await all(sessionWorkers)

    ## The final InputFile object, data is stored temporarily here and should be converted instead to for example MediaDocument
    if isBig:
        return InputFile(
            id: fileID,
            parts: blocksCount,
            name: extractFilename(fileLocation)
        )
    else:
        var digest: MD5Digest
        md5Final(md5ctx, digest)
        return InputFileSmall(
            id: fileID,
            parts: blocksCount,
            name: extractFilename(fileLocation),
            md5: $digest
        )

proc uploadFile*(self: NimgramClient, fileLocation: string, chatID: int64 = 0,
        ttl: int32 = 0): Future[Document] {.async.} =
    ## Upload a file to Telegram without actually sending it.

    let inputFile = await self.uploadInternalFile(fileLocation)
    let rawInput = if inputFile of InputFileSmall: parse(
            inputFile.InputFileSmall) else: parse(inputFile)
    let file = await self.send(MessagesUploadMedia(
          peer: if chatID == 0: InputPeerEmpty() else: (
                  await self.resolveInputPeer(chatID)),
          media: InputMediaUploadedDocument(
          file: rawInput,
          mime_type: newMimetypes().getMimetype(splitFile(inputFile.name).ext),
          force_file: true,
          attributes: @[DocumentAttributeFilename(
              file_name: inputFile.name
        ).DocumentAttributeI],
        ttl_seconds: if ttl != 0: some(ttl) else: none(int32)
      )))

    return parse((MessageMediaDocument)file).get()