## Nimgram
## Copyright (C) 2020-2021 Daniele Cortesi <https://github.com/dadadani>
## This file is part of Nimgram, under the MIT License
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY
## OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
## SOFTWARE.

import tl2json
import parser
echo "Generating code from the TL Scheme"
var mtprotojsonschema = TL2Json("tl/mtproto.tl", false, false)
echo "Converting files into json, this may take a while"
var apijsonschema = TL2Json("tl/api.tl", false, true, -1)

echo "Converting json to nim code..."
echo "Parsing mtproto.tl"
parser.parse(mtprotojsonschema, true)
echo "Parsing api.tl"
parser.parse(apijsonschema, false)
generateRawFile(mtprotojsonschema, apijsonschema)
