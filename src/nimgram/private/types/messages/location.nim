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


type Location* = ref object of Media
    longitude*: float64
    latitude*: float64
    accessHash: int64

proc parse*(geopoint: raw.MessageMediaGeo): Location =

    doAssert geopoint.geo of raw.GeoPoint, "This should not happen, why Telegram is doing this?"

    var loc = geopoint.geo.GeoPoint

    return Location(
        longitude: loc.long,
        latitude: loc.lat,
        accessHash: loc.access_hash
    )

