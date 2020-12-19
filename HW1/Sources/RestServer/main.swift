// main.swift
// created by Areg Tevanyan
// cwid: 890435167

import Kitura
import Cocoa

let router = Router()

router.all("/ClaimService/add", middleware: BodyParser())

router.get("/"){
    request, response, next in
    response.send("Hello! Welcome to visit the service. ")
    next()
}

router.post("/testPost"){
    request, response, next in
    print("Hitting the restPost service ...")
    let body = request.body
    if let jsonObj = body?.asJSON {
        if let jDict = jsonObj as? [String : String] {
            if let fn = jDict["FirstName"] {
                print("The input First Name : \(fn)")
                if let ln = jDict["LastName"] {
                    print("The input Last Name : \(ln)")
                }
            }
        }
        
    }
    response.send("Hello! Welcome to visit the /testPost service. ")
    next()
}


router.get("ClaimService/getAll"){
    request, response, next in
    let pList = ClaimDao().getAll()
    // JSON Serialization
    let jsonData : Data = try JSONEncoder().encode(pList)
    //JSONArray
    let jsonStr = String(data: jsonData, encoding: .utf8)
    // set Content-Type
    response.status(.OK)
    response.headers["Content-Type"] = "application/json"
    response.send(jsonStr)
    // response.send("getAll service response data : \(pList.description)")
    next()
}

router.post("ClaimService/add") {
    request, response, next in
    // JSON deserialization on Kitura server
    let body = request.body
    let jObj = body?.asJSON //JSON object
    if let jDict = jObj as? [String:String] {
        if let title = jDict["title"],let date = jDict["date"]{
            let pObj = Claim(id: UUID(), title: title, date: date, isSolved: false)
            ClaimDao().addClaim(pObj: pObj)
        }
    }
    response.send("The Claim record was successfully inserted (via POST Method).")
    next()
}
//router.get("/ClaimService/add") {
//    request, response, next in
//    let fn = request.queryParameters["id"]
//    let ln = request.queryParameters["title"]
//    let xn = request.queryParameters["date"]
//    //
//    // let n = ....
//    // if n != nil {
//    // ... }
//    if let n = request.queryParameters["SSN"] {
//        let pObj = Claim(fn:title, ln:ln, xn:xn, n:n)
//        ClaimDao().addClaim(pObj: <#T##Claim#>)
//        response.send("The Claim record was successfully inserted.")
//    } else {
//
//    }
//    next()
//}

Kitura.addHTTPServer(onPort: 8020, with: router)
Kitura.run()

