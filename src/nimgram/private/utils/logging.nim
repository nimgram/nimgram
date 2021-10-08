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

import std / [
  terminal, strformat
]


type Logger* = object
  enableColors: bool
  level: int

type
  LogLevel* = enum
    lvlDebug = "DEBUG"
    lvlInfo = "INFO"
    lvlNotice = "NOTICE"
    lvlWarn = "WARN"
    lvlError = "ERROR"
    lvlFatal = "FATAL"

type LevelInfo = object
  color: ForegroundColor
  level: int

const infoLevels: array[LogLevel, LevelInfo] = [
  LevelInfo(color: fgWhite, level: 6), LevelInfo(color: fgGreen, level: 5),
      LevelInfo(color: fgCyan, level: 4), LevelInfo(color: fgYellow, level: 3),
      LevelInfo(color: fgRed, level: 2), LevelInfo(color: fgRed, level: 1)
]


proc initLogger*(loggingLevel: int = 0, enableColors: bool): Logger =
  result.enableColors = enableColors
  result.level = loggingLevel

proc log*(self: Logger, level: LogLevel, msg: string) =
  var info = infoLevels[level]
  if info.level < self.level:
    if self.enableColors:
      setForegroundColor(stdout, info.color)
    echo &"[{$level}] {msg}"
    if self.enableColors:
      resetAttributes()
