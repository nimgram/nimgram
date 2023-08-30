# Nimgram
# Copyright (C) 2020-2023 Daniele Cortesi <https://github.com/dadadani>
# This file is part of Nimgram, under the MIT License
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import updates
import macros

type 
    AuthorizationState* {.NimgramType.} = object of RootObj

    AuthorizationStateUninitialized* {.NimgramType.} = object of AuthorizationState
    ## The client has not been initialized yet with the function initializeNimgram
    
    AuthorizationStateWaitAuthentication* {.NimgramType.} = object of AuthorizationState
    ## The client has been initialized, but not authenticated
    
    AuthorizationStateReady* {.NimgramType.} = object of AuthorizationState
    ## he client has been authenticated and can now send requests
    
    AuthorizationStateLoggingOut* {.NimgramType.} = object of AuthorizationState
    ## The user is currently logging out
    
    AuthorizationStateClosing* {.NimgramType.} = object of AuthorizationState
    ## The client is now closing and won't accept any function call after that
    
    AuthorizationStateClosed* {.NimgramType.} = object of AuthorizationState
    ## The client is closed and will refuse any function call
    
type UpdateAuthorizationState* {.NimgramType.} = object of Update
    ## Update containing the new authorization state
    authorizationState*: AuthorizationState