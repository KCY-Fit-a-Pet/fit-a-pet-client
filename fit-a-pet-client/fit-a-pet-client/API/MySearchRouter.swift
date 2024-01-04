
import Foundation
import Alamofire
import os.log

enum MySearchRouter: URLRequestConvertible {
    
    case sendSms(to: String)
    case checkSms(to: String, code: String)
    case login(uid: String, password: String)
    case regist(uid: String, name: String, password: String, email: String, profileImg: String)
    case presignedurl(dirname: String, extensionType: String, result: Bool, blocking: Bool)
    case uploadImage(image: UIImage)
    case registPet(petName: String, species: String, gender: String, neutralization: Bool, birthDate: String)
    case sendAuthSms(to: String, uid: String)
    case checkAuthSms(to: String, code: String)
    case findId(phone: String, code: String)
    case findPw(phone: String, newPassword: String, code: String)
    case existId(uid: String)
    case userProfileInfo, oauthLogin, oauthSendSms
    case userNotifyType(type: String)
    case editUserPw(type: String, prePassword: String, newPassword: String)
    case editUserName(type: String, name: String)
    case oauthCheckSms(code: String)
    case oauthRegistUser(name: String, uid: String)
    
    var baseURL: URL {
        switch self {
        case .presignedurl:
            return URL(string: API.PRESIGNEDURL)!
        case .uploadImage:
            return URL(string: PAYLOADURL.PAYLOAD)!
        default:
            return URL(string: API.BASE_URL)!
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .sendSms, .checkSms, .login, .regist, .presignedurl, .registPet,.sendAuthSms, .checkAuthSms, .findId, .findPw, .oauthLogin, .oauthSendSms, .oauthCheckSms, .oauthRegistUser:
            return .post
        case .existId, .userProfileInfo, .userNotifyType:
            return .get
        case .uploadImage, .editUserPw, .editUserName:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .sendSms, .checkSms:
            return "auth/register-sms"
        case .login:
            return "auth/login"
        case .regist:
            return "auth/register"
        case .presignedurl:
            return "C7QXbC20ti"
        case .uploadImage:
            return " "
        case .registPet:
            return "pets"
        case .sendAuthSms, .checkAuthSms:
            return "auth/search-sms"
        case .oauthLogin:
            return "auth/oauth"
        case .oauthSendSms, .oauthCheckSms:
            return "auth/oauth/\(OauthInfo.oauthId)/sms"
        case .oauthRegistUser:
            return "auth/oauth/\(OauthInfo.oauthId)"
        case .findId, .findPw:
            return "accounts/search"
        case .existId:
            return "accounts/exists"
        case .userProfileInfo, .editUserPw, .editUserName:
            return "accounts/\(UserDefaults.standard.string(forKey: "id")!)"
        case .userNotifyType:
            return "accounts/\(UserDefaults.standard.string(forKey: "id")!)/notify"
        }
    }
    
    var parameters : Parameters {
        switch self{
        case let .sendSms(phone):
            return ["to" : phone]
        case let .sendAuthSms(phone, uid):
            return ["to" : phone, "uid": uid]
        case let .checkSms(phone, code),
            let .checkAuthSms(phone, code):
            return ["to": phone, "code": code]
        case let .login(uid, password):
            return ["uid": uid, "password": password]
        case let .regist(uid, name, password , email, profileImg):
            return ["uid": uid, "name": name, "password": password, "email": email, "profileImg": profileImg]
        case let .presignedurl(dirname, extensionType, _, _):
            return ["dirname": dirname, "extension": extensionType]
        case let .registPet(petName , species , gender , neutralization , birthDate):
            return ["petName": petName, "species": species, "gender": gender, "neutralization": neutralization, "birthDate": birthDate]
        case let .findId(phone, code):
            return ["phone":phone, "code": code]
        case let .findPw(phone, newPassword, code):
            return ["phone": phone, "newPassword": newPassword, "code": code]
        case let .existId(uid):
            return ["uid": uid]
        case let .userNotifyType(type):
            return ["type": type]
        case let .editUserPw(type, prePassword, newPassword):
            return ["type": type, "prePassword": prePassword, "newPassword": newPassword]
        case let .editUserName(type, name):
            return ["type": type, "name": name]
        case .uploadImage(_), .userProfileInfo, .oauthLogin, .oauthSendSms:
            return [:]
        case let .oauthCheckSms(code):
            return ["code": code]
        case let .oauthRegistUser(name, uid):
            return ["name": name, "uid": uid]
//        case let .oauthLogin:
//            return ["id": id, "nonce": nonce, "provider": provider]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
            
        case .checkSms(let to, let code):
            let bodyParameters = ["to": to]
            let queryParameters = [URLQueryItem(name: "code", value: "\(code)")]
            
            request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
            
        case .regist:
            // regist 케이스에만 Keychain 사용
            if let accessToken = KeychainHelper.loadAccessToken() {
                // accessToken을 Keychain에서 불러와서 헤더로 보내기
                request = createURLRequestWithBody(url: url)
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            } else {
                request = createURLRequestWithBody(url: url)
            }
            
        case .presignedurl:
           
            let queryParameters = [
                URLQueryItem(name: "result", value: "true"),
                URLQueryItem(name: "blocking", value: "true")
            ]
            request = createURLRequestWithQuery(url: url, queryParameters: queryParameters)
            
        case .uploadImage(let image):
            request = createURLRequestForImage(url: baseURL, image: image)
            
            let queryParameters = [URLQueryItem(name: "X-Amz-Algorithm", value: PAYLOADURL.algorithm),
             URLQueryItem(name: "X-Amz-Credential", value: PAYLOADURL.credential),
             URLQueryItem(name: "X-Amz-Date", value: PAYLOADURL.date),
             URLQueryItem(name: "X-Amz-Expires", value: PAYLOADURL.expires),
             URLQueryItem(name: "X-Amz-Signature", value: PAYLOADURL.signature),
             URLQueryItem(name: "X-Amz-SignedHeaders", value: PAYLOADURL.signedHeaders),
             URLQueryItem(name: "x-amz-acl", value: PAYLOADURL.acl)
            ]
           
            request = createURLRequestWithQuery(url: url, queryParameters: queryParameters)
            
        case .registPet:
            if let accessToken = KeychainHelper.loadAccessToken() {
                request = createURLRequestWithBody(url: url)
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            } else {
                request = createURLRequestWithBody(url: url)
            }
            
        case .sendAuthSms(let to, let uid):
            var bodyParameters: [String: String] = [:]
            
            if  FindIdPwSwitch.findtype == uid{
                bodyParameters = ["to": to]
            }else{
                bodyParameters = ["to": to, "uid": uid]
            }
            let queryParameters = [URLQueryItem(name: "type", value: FindIdPwSwitch.findtype)]
            request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)

        
        case .checkAuthSms(let to, let code):
            let bodyParameters = ["to": to]
            let queryParameters = [URLQueryItem(name: "type", value: FindIdPwSwitch.findtype),URLQueryItem(name: "code", value: "\(code)")]
            
            request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
        case .findId(let phone, let code):
            let bodyParameters = ["phone": phone]
            let queryParameters = [URLQueryItem(name: "type", value: FindIdPwSwitch.findtype),URLQueryItem(name: "code", value: "\(code)")]
            
            request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
        
        case .findPw(let phone, let newPassword, let code):
            let bodyParameters = ["phone": phone, "newPassword": newPassword]
            let queryParameters = [URLQueryItem(name: "type", value: FindIdPwSwitch.findtype),URLQueryItem(name: "code", value: "\(code)")]
            
            request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
        
        case .existId(let uid):
            let queryParameters = [URLQueryItem(name: "uid", value: "\(uid)")]
            
            request = createURLRequestWithQuery(url: url, queryParameters: queryParameters)
        
        case .userProfileInfo:
            request = URLRequest(url: url)
            if let accessToken = KeychainHelper.loadAccessToken() {
                request.httpMethod = method.rawValue
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            }
        case .userNotifyType(let type):
            
            let queryParameters = [URLQueryItem(name: "type", value: type)]
            
            if let accessToken = KeychainHelper.loadAccessToken() {
                request = createURLRequestWithQuery(url: url, queryParameters: queryParameters)
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            } else {
                request = createURLRequestWithQuery(url: url, queryParameters: queryParameters)
            }
            
        case .editUserPw(let type, let prePassword, let newPassword):
            let bodyParameters = ["prePassword": prePassword, "newPassword": newPassword]
            let queryParameters = [URLQueryItem(name: "type", value: type)]
            
            if let accessToken = KeychainHelper.loadAccessToken() {
                request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            } else {
                request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
            }
        
        case .editUserName(let type, let name):
            let bodyParameters = ["name": name]
            let queryParameters = [URLQueryItem(name: "type", value: type)]
            print(url)
            
            if let accessToken = KeychainHelper.loadAccessToken() {
                request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            } else {
                request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
            }
            
        case .oauthLogin:
            let idToken = KeychainHelper.loadTempToken()!
            
            let bodyParameters = ["id": OauthInfo.oauthId, "idToken": idToken, "nonce": OauthInfo.nonce] as [String : Any]
            let queryParameters = [URLQueryItem(name: "provider", value: OauthInfo.provider)]
            
            request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
        
        case .oauthSendSms:
            let idToken = KeychainHelper.loadTempToken()!
            
            let bodyParameters = ["to": OauthInfo.phoneNum, "idToken": idToken, "nonce": OauthInfo.nonce] as [String : Any]
            let queryParameters = [URLQueryItem(name: "provider", value: OauthInfo.provider)]
            
            request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
        case .oauthCheckSms(let code):
            let idToken = KeychainHelper.loadTempToken()!
            
            let bodyParameters = ["to": OauthInfo.phoneNum, "idToken": idToken, "nonce": OauthInfo.nonce] as [String : Any]
            let queryParameters = [URLQueryItem(name: "provider", value: OauthInfo.provider), URLQueryItem(name: "code", value: code)]
            
            request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
        
        case .oauthRegistUser(let name, let uid):
            let idToken = KeychainHelper.loadTempToken()!
            
            let bodyParameters = ["name": name, "uid": uid, "idToken": idToken, "nonce": OauthInfo.nonce] as [String : Any]
            let queryParameters = [URLQueryItem(name: "provider", value: OauthInfo.provider)]
            
            if let accessToken = KeychainHelper.loadAccessToken() {
                request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            } else {
                request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
            }
            
            
        default:
            request = createURLRequestWithBody(url: url)
        }
        return request
    }
    
    private func createURLRequestWithBody(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        
        if let parameters = parameters as? [String: Any] {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "JSONEncoding")
                os_log("JSON 인코딩에 실패했습니다. 오류: %@", log: log, type: .error, "\(error)")
            }
        }
        
        return request
    }
    
    private func createURLRequestWithQuery(url: URL, queryParameters: [URLQueryItem]) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = queryParameters
        
        if let urlWithQuery = components?.url {
            print("requestURL: \(urlWithQuery)")
            request.url = urlWithQuery
        }
        
        return request
    }
    private func createURLRequestWithBodyAndQuery(url: URL, bodyParameters: [String: Any], queryParameters: [URLQueryItem]) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "JSONEncoding")
            os_log("JSON encoding failed. Error: %@", log: log, type: .error, "\(error)")
        }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = queryParameters

        if let urlWithQuery = components?.url {
            request.url = urlWithQuery
        }

        return request
    }
    
    private func createURLRequestForImage(url: URL, image: UIImage) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return request
        }
        
        request.httpBody = imageData
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        
        //os_log
        let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "AlamofireRequest")
        os_log("Request URL: %@", log: log, type: .debug, "\(String(describing: request.url))")
        os_log("Request Headers: %@", log: log, type: .debug, "\(request.allHTTPHeaderFields ?? [:])")
        os_log("Request Body: %@", log: log, type: .debug, "\(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "Body not available")")
        
        return request
    }
}
