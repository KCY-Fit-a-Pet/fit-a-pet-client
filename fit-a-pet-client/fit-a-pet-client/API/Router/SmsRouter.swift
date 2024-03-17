

import Foundation
import Alamofire

enum SmsRouter: URLRequestConvertible {

    case sendSms(to: String)
    case checkSms(to: String, code: String)
    case sendAuthSms(to: String, uid: String)
    case checkAuthSms(to: String, code: String)
    case oauthSendSms
    case oauthCheckSms(code: String)
    
    var method: HTTPMethod {
        switch self {
        case .sendSms, .checkSms, .sendAuthSms, .checkAuthSms, .oauthSendSms ,.oauthCheckSms:
            return .post
        }
    }
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .sendSms, .checkSms:
            return "v1/auth/register-sms"
        case .sendAuthSms, .checkAuthSms:
            return "v1/auth/search-sms"
        case .oauthSendSms, .oauthCheckSms:
            return "v1/auth/oauth/\(OauthInfo.oauthId)/sms"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .sendSms(to):
            return ["to": to]
        case let .checkSms(to, code):
            return ["to": to, "code": code]
        case let .sendAuthSms(to, uid):
            return ["to": to, "uid": uid]
        case let .checkAuthSms(to, code):
            return ["to": to, "code": code]
        case let .oauthCheckSms(code):
            return ["code": code]
        case .oauthSendSms:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest

        switch self {
        case .checkSms(let to, let code):
            let bodyParameters = ["to": to]
            let queryParameters = [URLQueryItem(name: "code", value: "\(code)")]
            request = URLRequest.createURLRequestWithBodyAndQuery(url: url, method: method, bodyParameters: bodyParameters, queryParameters: queryParameters)

        case .sendSms(to: _):

            request = URLRequest.createURLRequestWithBody(url: url, method: method, parameters: parameters)

        case .sendAuthSms(let to, let uid):
            var bodyParameters: [String: String] = ["to": to]
            if FindIdPwSwitch.findtype != uid {
                bodyParameters["uid"] = uid
            }
            let queryParameters = [URLQueryItem(name: "type", value: FindIdPwSwitch.findtype)]
            request = URLRequest.createURLRequestWithBodyAndQuery(url: url, method: method, bodyParameters: bodyParameters, queryParameters: queryParameters)

        case .checkAuthSms(let to, let code):
            let bodyParameters = ["to": to]
            let queryParameters = [URLQueryItem(name: "type", value: FindIdPwSwitch.findtype),
                                    URLQueryItem(name: "code", value: "\(code)")]
            request = URLRequest.createURLRequestWithBodyAndQuery(url: url, method: method, bodyParameters: bodyParameters, queryParameters: queryParameters)
                   
        case .oauthSendSms:
            let idToken = KeychainHelper.loadTempToken()!
            
            let bodyParameters = ["to": RegistrationManager.shared.phone!, "idToken": idToken, "nonce": OauthInfo.nonce] as [String : Any]
            let queryParameters = [URLQueryItem(name: "provider", value: OauthInfo.provider)]
            
            request = URLRequest.createURLRequestWithBodyAndQuery(url: url, method: method, bodyParameters: bodyParameters, queryParameters: queryParameters)
        case .oauthCheckSms(let code):
            let idToken = KeychainHelper.loadTempToken()!
            
            let bodyParameters = ["to": RegistrationManager.shared.phone!, "idToken": idToken, "nonce": OauthInfo.nonce] as [String : Any]
            let queryParameters = [URLQueryItem(name: "provider", value: OauthInfo.provider), URLQueryItem(name: "code", value: code)]
            
            request = URLRequest.createURLRequestWithBodyAndQuery(url: url, method: method ,bodyParameters: bodyParameters, queryParameters: queryParameters)
        }
    
        
        return request
    }
}
