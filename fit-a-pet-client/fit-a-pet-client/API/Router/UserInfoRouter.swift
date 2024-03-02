

import Foundation
import Alamofire

enum UserInfoRouter: URLRequestConvertible {

    case editUserPw(type: String, prePassword: String, newPassword: String)
    case editUserName(type: String, name: String)
    case userProfileInfo
    case userNotifyType(type: String)
    case searchUserProfile(searchId: String)
    case userNicknameCheck(userId: Int)
    case editSomeoneNickname(userId: Int, nickname: String)
    
    var method: HTTPMethod {
        switch self {
        case .userProfileInfo, .searchUserProfile, .userNotifyType, .userNicknameCheck:
            return .get
        case .editUserPw, .editUserName, .editSomeoneNickname:
            return .put
        }
    }
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .userProfileInfo, .editUserPw, .editUserName:
            return "v2/accounts/\(UserDefaults.standard.string(forKey: "id")!)"
        case .userNotifyType:
            return "v2/accounts/\(UserDefaults.standard.string(forKey: "id")!)/notify"
        case .searchUserProfile:
            return "v2/accounts"
        case .userNicknameCheck(let userId):
            return "v2/accounts/\(userId)/name"
        case .editSomeoneNickname(let userId, _):
            return "v2/accounts/\(userId)/nickname"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .userNotifyType(type):
            return ["type": type]
        case let .editUserPw(type, prePassword, newPassword):
            return ["type": type, "prePassword": prePassword, "newPassword": newPassword]
        case let .editUserName(type, name):
            return ["type": type, "name": name]
        case let .editSomeoneNickname(_, nickname):
            return ["ninkname": nickname]
        case .userProfileInfo, .searchUserProfile, .userNicknameCheck, .editSomeoneNickname:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        var url = baseURL.appendingPathComponent(path)
        var request: URLRequest

        switch self {
        case .userProfileInfo, .userNicknameCheck(_):
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
       
        case .userNotifyType(let type):
            
            let queryParameters = [URLQueryItem(name: "type", value: type)]
            request = URLRequest.createURLRequestWithQuery(url: url, method: method,queryParameters: queryParameters)
            
        case .editUserPw(let type, let prePassword, let newPassword):
            let bodyParameters = ["prePassword": prePassword, "newPassword": newPassword]
            let queryParameters = [URLQueryItem(name: "type", value: type)]
            
            request = URLRequest.createURLRequestWithBodyAndQuery(url: url, method: method,bodyParameters: bodyParameters, queryParameters: queryParameters)
        
        case .editUserName(let type, let name):
            let bodyParameters = ["name": name]
            let queryParameters = [URLQueryItem(name: "type", value: type)]
            
            request = URLRequest.createURLRequestWithBodyAndQuery(url: url, method: method,bodyParameters: bodyParameters, queryParameters: queryParameters)
            
        case .searchUserProfile(let searchId):
            let queryParameters = [URLQueryItem(name: "search", value: searchId)]
            request = URLRequest.createURLRequestWithQuery(url: url, method: method ,queryParameters: queryParameters)
        
        case .editSomeoneNickname(_, _):
            request = URLRequest.createURLRequestWithBody(url: url, method: method, parameters: parameters)
        
        }
    
        return request
    }
}
