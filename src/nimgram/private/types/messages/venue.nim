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


type Venue* = ref object of Media
    long*: Option[float64]     ## Longitude geoPoint
    lat*: Option[float64]      ## Latitude geoPoint
    accessHash*: Option[int64] ## Access hash geoPoint
    accuracy*: Option[int32] ## The estimated horizontal accuracy of the location, in meters; as defined by the sender.
    title*: string             ## Venue name
    address*: string           ## Address
    provider*: string ## Venue provider: currently only "foursquare" needs to be supported
    venueID*: string           ## Venue ID in the provider's database
    venueType*: string         ## Venue type in the provider's database

proc parse*(venue: MessageMediaVenue): Venue =
    result = new Venue

    if venue.geo of GeoPoint:
        var geoPoint = venue.geo.GeoPoint
        result.long = some(geoPoint.long)
        result.lat = some(geoPoint.lat)
        result.accessHash = some(geoPoint.access_hash)
        result.accuracy = geoPoint.accuracy_radius

    result.title = venue.title
    result.address = venue.address
    result.provider = venue.provider
    result.venueID = venue.venue_id
    result.venueType = venue.venue_type
