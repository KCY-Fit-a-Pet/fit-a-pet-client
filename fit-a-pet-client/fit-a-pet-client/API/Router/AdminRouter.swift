//
//  AdminRouter.swift
//  fit-a-pet-client
//
//  Created by 최희진 on 2/27/24.
//

import Foundation
import Alamofire

enum AdminRouter: URLRequestConvertible {

    case login(uid: String, password: String)
    case regist(uid: String, name: String, password: String, email: String, profileImg: String)//
    case findId(phone: String, code: String)
    case findPw(phone: String, newPassword: String, code: String)
    case existId(uid: String)
    case oauthLogin, refresh
    case oauthRegistUser(name: String, uid: String)
    
    var method: HTTPMethod {
        switch self {
        case .login, .regist, .findId, .findPw, .oauthLogin, .oauthRegistUser:
            return .post
        case .existId, .refresh:
            return .get
        }
    }
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "v1/auth/login"
        case .regist:
            return "v1/auth/register"
        case .findId, .findPw:
            return "v2/accounts/search"
        case .existId:
            return "v2/accounts/exists"
        case .oauthLogin:
            return "v1/auth/oauth"
        case .refresh:
            return "v1/auth/refresh"
        case .oauthRegistUser:
            return "v1/auth/oauth/\(OauthInfo.oauthId)"
        
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .login(uid, password):
            return ["uid": uid, "password": password]
        case let .regist(uid, name, password , email, profileImg):
            return ["uid": uid, "name": name, "password": password, "email": email, "profileImg": profileImg]
        case let .findId(phone, code):
            return ["phone":phone, "code": code]
        case let .findPw(phone, newPassword, code):
            return ["phone": phone, "newPassword": newPassword, "code": code]
        case let .existId(uid):
            return ["uid": uid]
        case let .oauthRegistUser(name, uid):
            return ["name": name, "uid": uid]
        case .oauthLogin, .refresh:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest

        switch self {
        case .refresh:
            request = URLRequest(url: url)
            
            if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
                let cookieHeader = HTTPCookie.requestHeaderFields(with: cookies)
                request.allHTTPHeaderFields = cookieHeader
            }

        case .findId(let phone, let code):
            let bodyParameters = ["phone": phone]
            let queryParameters = [URLQueryItem(name: "type", value: FindIdPwSwitch.findtype),URLQueryItem(name: "code", value: "\(code)")]
            
            request = URLRequest.createURLRequestWithBodyAndQuery(url: url, method: method,bodyParameters: bodyParameters, queryParameters: queryParameters)
        
        case .findPw(let phone, let newPassword, let code):
            let bodyParameters = ["phone": phone, "newPassword": newPassword]
            let queryParameters = [URLQueryItem(name: "type", value: FindIdPwSwitch.findtype),URLQueryItem(name: "code", value: "\(code)")]
            
            request = URLRequest.createURLRequestWithBodyAndQuery(url: url, method: method,bodyParameters: bodyParameters, queryParameters: queryParameters)
        
        case .existId(let uid):
            let queryParameters = [URLQueryItem(name: "uid", value: "\(uid)")]
            
            request = URLRequest.createURLRequestWithQuery(url: url, method: method,queryParameters: queryParameters)
        
        case .oauthLogin:
            let idToken = KeychainHelper.loadTempToken()!
            
            let bodyParameters = ["id": OauthInfo.oauthId, "idToken": idToken, "nonce": OauthInfo.nonce] as [String : Any]
            let queryParameters = [URLQueryItem(name: "provider", value: OauthInfo.provider)]
            
            request = URLRequest.createURLRequestWithBodyAndQuery(url: url, method: method,bodyParameters: bodyParameters, queryParameters: queryParameters)
        
        case .oauthRegistUser(let name, let uid):
            let idToken = KeychainHelper.loadTempToken()!
            
            let bodyParameters = ["name": name, "uid": uid, "idToken": idToken, "nonce": OauthInfo.nonce] as [String : Any]
            let queryParameters = [URLQueryItem(name: "provider", value: OauthInfo.provider)]
            
            request = URLRequest.createURLRequestWithBodyAndQuery(url: url, method: method,bodyParameters: bodyParameters, queryParameters: queryParameters)
            
        default:
            request = URLRequest.createURLRequestWithBody(url: url, method: method, parameters: parameters)
        }
        
        return request
    }
}
