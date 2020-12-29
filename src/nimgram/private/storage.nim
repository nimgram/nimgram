import asyncdispatch
import tables
import strutils
when compileOption("threads"):
    import strformat
    import utils/sqlite
    import db_sqlite
    import base64
import utils/binmanager

type NimgramStorageConfig* = ref object of RootObj

type NimgramStorageConfigRam* = ref object of NimgramStorageConfig
    binfilename*: string

when compileOption("threads"):
    type NimgramStorageConfigSqlite* = ref object of NimgramStorageConfig
        filename*: string
        disableCache*: bool #By enabling this, cache in ram will be not used, increasing disk usage

type NimgramStorage* = ref object of RootObj

## Storage using ram: Saves information on ram
## This might be helpful when creating scalable instances saving disk usage
## with the disavantage of consuming more ram over time. 
## If you want to clean saved information, use the clearCache (TODO) method
type NimgramStorageRam* = ref object of NimgramStorage
    binFileName: string
    
when compileOption("threads"):
    ## Storage using sqlite: Saves information on file database (sqlite)
    ## Saved information are permanent, since are written on disk.
    ## By default, cache in ram (temp) is used to use less storage usage, can be disabled on config
    ## To use this type of storage, threads need to be enabled (use --threads:on on the Nim compiler)
    type NimgramStorageSqlite* = ref object of NimgramStorage
        disableCache: bool
        sqliteInstance: SqlManager

method Init*(self: NimgramStorage, config: NimgramStorageConfig) {.base.} = discard

method WriteSessionsInfo*(self: NimgramStorage, dcOptions: Table[int, DcOption]) {.base, async.} = discard

method GetSessionsInfo*(self: NimgramStorage): Future[Table[int, DcOption]] {.base, async.} = discard

method Init*(self: NimgramStorageRam, config: NimgramStorageConfig) = 
    if not(config of NimgramStorageConfigRam):
        raise newException(Exception, "Expecting config of type NimgramStorageRam")

    var ramConfig = config.NimgramStorageConfigRam
    self.binFileName = ramConfig.binfilename

method WriteSessionsInfo*(self: NimgramStorageRam, dcOptions: Table[int, DcOption]) {.async.} = 
    await writeBin(self.binFileName, dcOptions)


method GetSessionsInfo*(self: NimgramStorageRam): Future[Table[int, DcOption]] {.async.} = 
    return await loadBin(self.binFileName)

when compileOption("threads"):
    method Init*(self: NimgramStorageSqlite, config: NimgramStorageConfig) = 
        if not(config of NimgramStorageConfigSqlite):
            raise newException(Exception, "Expecting config of type NimgramStorageSqlite")

        var sqliteConfig = config.NimgramStorageConfigSqlite
        self.disableCache = sqliteConfig.disableCache
        self.sqliteInstance = initSqlite(sqliteConfig.filename)

    method WriteSessionsInfo*(self: NimgramStorageSqlite, dcOptions: Table[int, DcOption]) {.async.} =
        await self.sqliteInstance.exec(sql("DELETE from dcoptions;"))
        var query = ""
        for _, key in dcOptions:
            var isAuthorized = "0"
            if key.isAuthorized:
                isAuthorized = "1"
            var isMain = "0"
            if key.isMain:
                isMain = "1"
            var authKey = encode(key.authKey)
            var salt = encode(key.salt)
            await self.sqliteInstance.exec(sql(&"INSERT INTO dcoptions (number, isAuthorized, isMain, authKey, salt) VALUES ({key.number}, {isAuthorized}, {isMain}, '{authKey}', '{salt}');"))

    method GetSessionsInfo*(self: NimgramStorageSqlite): Future[Table[int, DcOption]] {.async.} =
        var rows = await self.sqliteInstance.getAllRows(sql("SELECT number, isAuthorized, isMain, authKey, salt FROM dcoptions"))
        for row in rows:
            var number = parseInt(row[0]).uint16
            var isAuthorized = if row[1] == "1": true else: false
            var isMain = if row[2] == "1": true else: false
            var authKey = cast[seq[uint8]](decode(row[3]))
            var salt = cast[seq[uint8]](decode(row[4]))
            result[int(number)] = DcOption(number: number, isAuthorized: isAuthorized, isMain: isMain, authKey: authKey, salt: salt)
            
