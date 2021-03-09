
when compileOption("threads"):
    import db_sqlite
    import threadpool
    import asyncdispatch
    import json
    type SqlResponse = object
        success: bool
        exception: ref Exception
        response: string
        rowResponse: Row
        seqResponse: seq[Row]

    type SqlRequest = ref object 
        queryType: string
        query: SqlQuery
        args: seq[string]
        chnanswer: ptr Channel[SqlResponse]
        event: AsyncEvent

    type SqlManager* = ref object
        worker: Thread[SqlManager]
        sql: DbConn
        chn: ptr Channel[SqlRequest]
        execute: bool

    proc worker(self: SqlManager) {.thread.} = 
        while self.execute:
            var request = self.chn[].recv()
            var response = SqlResponse(success: true)
            if request.queryType == "exec":
                try:
                    self.sql.exec(request.query, request.args)
                except DbError:
                    response.success = false
                    response.exception = getCurrentException()
                    continue
                response.response = ""
                request.chnanswer[].send(response)
                request.event.trigger()
            if request.queryType == "getValue":
                try:
                    response.response = self.sql.getValue(request.query, request.args)
                except DbError:
                    response.success = false
                    response.exception = getCurrentException()
                    continue
                request.chnanswer[].send(response)
                request.event.trigger()
            if request.queryType == "getAllRows":
                try:
                    response.seqResponse = self.sql.getAllRows(request.query, request.args)
                except DbError:
                    response.success = false
                    response.exception = getCurrentException()
                request.chnanswer[].send(response)
                request.event.trigger()
            if request.queryType == "getRow":
                try:
                    response.rowResponse = self.sql.getRow(request.query, request.args)
                except DbError:
                    response.success = false
                    response.exception = getCurrentException()
                request.chnanswer[].send(response)
                request.event.trigger()




    proc initSqlite*(filename: string): SqlManager =
        result = new SqlManager
        result.execute = true
        result.chn = cast[ptr Channel[SqlRequest]](
            allocShared0(sizeof(Channel[SqlRequest]))
        )
        result.chn[].open()

        result.sql = open(filename, "", "", "")
        result.sql.exec(sql"create table if not exists dcoptions( number int constraint table_name_pk primary key, isAuthorized int, isMain int, authKey TEXT, salt TEXT);")
        result.sql.exec(sql"create table if not exists peerdata ( id int constraint peerdata_pk primary key, access_hash int );")
        createThread(result.worker, worker, result)
 
    proc waitEvent(ev: AsyncEvent): Future[void] =
        var fut = newFuture[void]("waitEvent")
        proc cb(fd: AsyncFD): bool = fut.complete(); return true
        addEvent(ev, cb)
        return fut

    proc exec*(self: SqlManager, query: SqlQuery, argss: seq[string] = @[]) {.async.} =
        var event = newAsyncEvent()
        var answerchn =  cast[ptr Channel[SqlResponse]](
            allocShared0(sizeof(Channel[SqlResponse]))
        )
        answerchn[].open()
        var request = SqlRequest(queryType: "exec", query: query, args: argss, event: event, chnanswer: answerchn)
        self.chn[].send(request)
        await waitEvent(event)
        var response = answerchn[].recv()
        answerchn[].close()
        deallocShared(answerchn) 
        if not response.success:
            raise response.exception
    
    proc getValue*(self: SqlManager, query: SqlQuery, argss: seq[string] = @[]): Future[string] {.async.} =
        var event = newAsyncEvent()
        var answerchn =  cast[ptr Channel[SqlResponse]](
            allocShared0(sizeof(Channel[SqlResponse]))
        )
        answerchn[].open()
        var request = SqlRequest(queryType: "getValue", query: query, args: argss, event: event, chnanswer: answerchn)
        self.chn[].send(request)
        await waitEvent(event)
        var response = answerchn[].recv()
        answerchn[].close()
        deallocShared(answerchn) 
        if not response.success:
            raise response.exception
        return response.response

    proc getAllRows*(self: SqlManager, query: SqlQuery, argss: seq[string] = @[]): Future[seq[Row]] {.async.} =
        var event = newAsyncEvent()
        var answerchn =  cast[ptr Channel[SqlResponse]](
            allocShared0(sizeof(Channel[SqlResponse]))
        )
        answerchn[].open()
        var request = SqlRequest(queryType: "getAllRows", query: query, args: argss, event: event, chnanswer: answerchn)
        self.chn[].send(request)
        await waitEvent(event)
        var response = answerchn[].recv()
        answerchn[].close()
        deallocShared(answerchn) 
        if not response.success:
            raise response.exception
        return response.seqResponse

    proc getRow*(self: SqlManager, query: SqlQuery, argss: seq[string] = @[]): Future[Row] {.async.} =
        var event = newAsyncEvent()
        var answerchn =  cast[ptr Channel[SqlResponse]](
            allocShared0(sizeof(Channel[SqlResponse]))
        )
        answerchn[].open()
        var request = SqlRequest(queryType: "getRow", query: query, args: argss, event: event, chnanswer: answerchn)
        self.chn[].send(request)
        await waitEvent(event)
        var response = answerchn[].recv()
        answerchn[].close()
        deallocShared(answerchn) 
        if not response.success:
            raise response.exception
        return response.rowResponse

    proc close*(self: SqlManager) = 
        self.execute = false
        self.chn[].close()
        deallocShared(self.chn)
        self.sql.close()