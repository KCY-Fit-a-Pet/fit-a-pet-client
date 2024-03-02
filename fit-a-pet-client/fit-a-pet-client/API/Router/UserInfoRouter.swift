

import Foundation
import Alamofire

enum UserInfoRouter: URLRequestConvertible {

    case editUserPw(type: String, prePassword: String, newPassword: String)
    case editUserName(type: String, name: String)
    case userProfileInfo
    case userNotifyType(type: String)
    case searchUserProfile(searchId: String)
    
    var method: HTTPMethod {
        switch self {
        case .userProfileInfo, .searchUserProfile, .userNotifyType:
            return .get
        case .editUserPw, .editUserName:
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
        case .userProfileInfo, .searchUserProfile:
            return [:]
        }
    }

    func asURLRequest() throws -> URLRequest {
        var url = baseURL.appendingPathComponent(path)
        var request: URLRequest

        switch self {
        case .userProfileInfo:
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
   
        }
        
        return request
    }
}
