

import Foundation

enum API{
    static let BASE_URL : String = "http://www.fitapet.co.kr:8080/api/v1/"
    static let PRESIGNEDURL : String = "https://h1d5jjb17z.apigw.ntruss.com/obj/photo/"
}

enum PAYLOADURL{
    static var PAYLOAD : String = ""
    static var algorithm = ""
    static var credential = ""
    static var date = ""
    static var expires = ""
    static var signature = ""
    static var signedHeaders = ""
    static var acl = ""
}

enum QueryParameter: String {
    case algorithm
    case credential
    case date
    case expires
    case signature
    case signedHeaders
    case acl
}

enum FindIdPwSwitch{
    static var findAuth = ""
    static var findtype = ""
    static var phoneNum = ""
    static var code = ""
    static var userUid = ""
}

