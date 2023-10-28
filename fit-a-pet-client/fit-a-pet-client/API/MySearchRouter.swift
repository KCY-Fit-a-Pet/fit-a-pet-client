
import Foundation
import Alamofire
import os.log

enum MySearchRouter: URLRequestConvertible {
    
    case sendSms(to: Int)
    case checkSms(to: Int, code: Int)
    case login(uid: String, password: String)
    case regist(uid: String, name: String, password: String, email: String, profileImg: String)

    var baseURL: URL {
        return URL(string: API.BASE_URL + "members/")! //여기서 나온 값이 baseURL이다.
    }

    var method: HTTPMethod {
        
        switch self{
        case .sendSms:
            return .post
        case .checkSms:
            return .post
        case .login:
            return .post
        case .regist:
            return .post
        }
    }

    var path: String {
        switch self {
        case .sendSms:
            return "sms"
        case .checkSms:
            return "sms"
        case .login:
            return "login"
        case .regist:
            return "register"
        }
    }
    
    var parameters : Parameters {
        switch self{
        case let .sendSms(phone)://enum으로 들어온 애를 사용하려면 let을 사용
            return ["to" : phone]
        case let .checkSms(phone,code):
            return ["to": phone, "code": code]
        case let .login(uid, password):
            return ["uid": uid, "password": password]
        case let .regist(uid, name, password , email, profileImg):
            return ["uid": uid, "name": name, "password": password, "email": email, "profileImg": profileImg]
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest

        if case .checkSms(let to, let code) = self {
            // checkSms 케이스에서 "to"는 바디로, "code"는 쿼리로 처리
            request = createURLRequestForBodyAndQuery(url: url, to: to, code: code)
        } else if case .regist = self {
            if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
                // accesstoken 헤더로 보내기
                request = createURLRequestForBody(url: url)
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            } else {
                request = createURLRequestForBody(url: url)
            }
        } else {
            // sendSms 및 login 케이스에서 body로 처리
            request = createURLRequestForBody(url: url)
        }

        return request
    }

    private func createURLRequestForQuery(url: URL) -> URLRequest {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
        if let urlWithQuery = components?.url {
            return URLRequest(url: urlWithQuery)
        }
        return URLRequest(url: url)
    }

    private func createURLRequestForBody(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let parameters = parameters as? [String: Any] {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "JSONEncoding")
                os_log("JSON 인코딩에 실패했습니다. 오류: %@", log: log, type: .error, "\(error)")//JSON 인코딩 실패시
            }
        }

        return request
    }

    private func createURLRequestForBodyAndQuery(url: URL, to: Int, code: Int) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // "to"는 바디로 설정
        var parametersWithTo = parameters
        parametersWithTo["to"] = to

        if let parameters = parametersWithTo as? [String: Any] {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "JSONEncoding")
                os_log("JSON 인코딩에 실패했습니다. 오류: %@", log: log, type: .error, "\(error)")//JSON 인코딩 실패시
            }
        }

        // "code"는 쿼리로 설정
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "code", value: "\(code)")]

        if let urlWithQuery = components?.url {
            request.url = urlWithQuery
        }

        return request
    }
}
