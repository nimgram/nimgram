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



type Game* = ref object of Media
    id*: int64                  ## ID of the game
    accessHash*: int64          ## Access hash of the game
    shortName*: string          ## Short name for the game
    title*: string              ## Title of the game
    description*: string        ## Game description
    photo*: Photo               ## Game preview
    document*: Option[Document] ## Optional attached document

proc parse(game: raw.Game): Game =
    result = new Game

    result.id = game.id
    result.accessHash = game.access_hash
    result.shortName = game.short_name
    result.title = game.title
    result.description = game.description
    if game.photo of raw.Photo:
        let photo = (raw.Photo)(game.photo)
        result.photo = parse(photo)
    if game.document.isSome():
        if game.document.get() of raw.Document:
            let document = (raw.Document)(game.document.get())
            result.document = some(parse(document))
