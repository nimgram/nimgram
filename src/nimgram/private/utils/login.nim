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


proc logout*(self: NimgramClient) {.async.} =
    ## Logout from the sessions on this instance
    let logout = await self.sessions[self.mainDc].send(AuthLogOut())
    if logout of TLTrue:
        var sessions = await self.storageManager.getSessionsInfo()
        for i, _ in sessions:
            sessions[i].isAuthorized = false
        await self.storageManager.writeSessionsInfo(sessions)
        self.logger.log(lvlDebug, &"Successfully logged out")



proc botLogin*(self: NimgramClient, token: string) {.async.} =
    ## Login as a bot.
    ## Token is only sent to Telegram once, and not stored internally

    try:
        # Check if we are already logged in

        discard await self.sessions[self.mainDc].send(UsersGetFullUser(
                id: InputUserSelf()))
    except:
        try:
            discard await self.sessions[self.mainDc].send(AuthImportBotAuthorization(
                api_id: self.config.apiID,
                api_hash: self.config.apiHash,
                bot_auth_token: token
            ))
            var sessions = await self.storageManager.getSessionsInfo()
            for i, _ in sessions:
                sessions[i].isAuthorized = true
            await self.storageManager.writeSessionsInfo(sessions)
        except RPCException:
            # If USER_MIGRATE_X is received, create a new connection to the new datacenter and set as main
            var msgerror = getCurrentExceptionMsg()
            if msgerror.startsWith("USER_MIGRATE_"):
                var migrateDC = parseInt(getCurrentException().RPCException.errorMessage.split(
                        "_")[2])
                self.logger.log(lvlNotice, &"Switching to DC{migrateDC}")
                var sessions = InternalTableOptions(
                        original: await self.storageManager.getSessionsInfo())

                # This will handle dh hankshake

                self.sessions[migrateDC] = await self.getSession(sessions,
                        migrateDC, self.config.transportMode,
                        self.config.useIpv6, self.config.testMode,
                        self.storageManager, self.config)
                self.sessions[migrateDC].isRequired = true
                self.sessions[self.mainDc].isRequired = false

                # Connection initialization

                asyncCheck self.sessions[migrateDC].startHandler(self,
                        self.updateHandler)
                try:
                    await self.sessions[migrateDC].sendMTProtoInit(true, true)
                    discard await self.sessions[migrateDC].send(AuthImportBotAuthorization(
                        api_id: self.config.apiID,
                        api_hash: self.config.apiHash,
                        bot_auth_token: token
                    ), true, true)
                    sessions.original[self.mainDc].isMain = false
                    self.mainDc = migrateDc
                    self.isMainAuthorized = true
                    sessions.original[migrateDc].isMain = true
                    sessions.original[migrateDc].isAuthorized = true
                    await self.storageManager.writeSessionsInfo(
                            sessions.original)
                except CatchableError:
                    discard
                except RPCException:
                    raise

            else:
                raise
