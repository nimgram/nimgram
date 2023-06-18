import std/macros, std/strformat


macro NimgramApi*(prc: untyped) =
    if prc.kind != nnkProcDef:
        error("Expected a proc definition")
    let procname = if prc[0].kind == nnkIdent: $prc[0]
                   elif prc[0].kind == nnkPostFix: $prc[0][1]
                   else: ""
    var nimgramClientParamName = ""
    var oldBody: NimNode
    var newBody = newStmtList()
    var foundBody = false
    for node in prc:
        if node.kind == nnkFormalParams:
            for param in node:
                if param.kind == nnkIdentDefs:
                    echo param[1].treeRepr
                    if param[1].eqIdent("NimgramClient"):
                        if nimgramClientParamName != "":
                            error("A function can only have one NimgramClient parameter")
                        nimgramClientParamName = param[0].toStrLit.strVal()
            if nimgramClientParamName == "":
                error("Expected a NimgramClient parameter")
        if node.kind == nnkStmtList:
            foundBody = true
            oldBody = node
    if not foundBody:
        error("Missing implementation")
    echo &"this is proc with name '{procname}'"
    newBody.add(newIfStmt(
        (newDotExpr(newDotExpr(newIdentNode(
            nimgramClientParamName), newIdentNode("private")), newIdentNode(
            "authenticated")),
            newStmtList(newNimNode(nnkReturnStmt).add(newEmptyNode())))
            
            ))

    for node in oldBody:
        newBody.add(node)
    var i = 0
    while prc[i].kind != nnkStmtList:
        i += 1
    prc[i] = newBody
    echo prc.treeRepr
    result = prc
    #newBody.add(new)
    #echo prc.add()

#NimgramApi("test")
