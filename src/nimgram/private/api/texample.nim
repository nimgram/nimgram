import macros
import client

type BaseTestType* {.NimgramType.} = object of RootObj
    vari*: string

type BaseTestTypeVariant* {.NimgramType.} = object of BaseTestType
    hi*: string
    hidden: string
    lovem*: int32

type BaseBaseTest1* {.NimgramType.} = object

type BaseBaseTest2* {.NimgramType.} = ref object

proc testFunction*(self: NimgramClient, a: BaseTestTypeVariant): BaseTestTypeVariant {.NimgramFunction.} =
    result = a