
import Foundation
import Alamofire
import os.log

enum MySearchRouter: URLRequestConvertible {
    
    case sendSms(to: String)
    case checkSms(to: String, code: Int)
    case login(uid: String, password: String)
    case regist(uid: String, name: String, password: String, email: String, profileImg: String)
    case presignedurl(dirname: String, extensionType: String, result: Bool, blocking: Bool)
    case uploadImage(image: UIImage)

    var baseURL: URL {
        switch self {
        case .presignedurl:
            return URL(string: API.PRESIGNEDURL)!
        case .uploadImage:
            return URL(string: PAYLOADURL.PAYLOAD)!
        default:
            return URL(string: API.BASE_URL + "members/")!
        }
    }

    var method: HTTPMethod {
        switch self {
        case .sendSms, .checkSms, .login, .regist, .presignedurl:
            return .post
        case .uploadImage:
            return .put
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
        case .presignedurl:
            return "C7QXbC20ti"
        case .uploadImage:
            return ""
        }
    }
    
    var parameters : Parameters {
        switch self{
        case let .sendSms(phone)://enum으로 들어온 애를 사용하려면 let을 사용
            return ["to" : phone]
        case let .checkSms(phone, code):
            return ["to": phone, "code": code]
        case let .login(uid, password):
            return ["uid": uid, "password": password]
        case let .regist(uid, name, password , email, profileImg):
            return ["uid": uid, "name": name, "password": password, "email": email, "profileImg": profileImg]
        case let .presignedurl(dirname, extensionType, _, _):
            return ["dirname": dirname, "extension": extensionType]
        case let .uploadImage(_):
            return [:]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request: URLRequest

        switch self {
        case .checkSms(let to, let code):
            // checkSms 케이스에서 "to"는 바디로, "code"는 쿼리로 처리
            request = createURLRequestForBodyAndQuery(url: url, body: to, query: code)

        case .regist:
            // regist 케이스에만 Keychain 사용
            if let accessToken = KeychainHelper.loadAccessToken() {
                // accessToken을 Keychain에서 불러와서 헤더로 보내기
                request = createURLRequestForBody(url: url)
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            } else {
                request = createURLRequestForBody(url: url)
            }
            
        case .presignedurl:
            request = createURLRequestForBodyAndQuery(url: url, body: "", query: 0, isPresignedURL: true)
            
        case .uploadImage(let image):
            request = createURLRequestForBody(url: baseURL, image: image)
            // Add X-Amz-Algorithm query parameter
            var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
            components?.queryItems =
                [URLQueryItem(name: "X-Amz-Algorithm", value: PAYLOADURL.algorithm),
                 URLQueryItem(name: "X-Amz-Credential", value: PAYLOADURL.credential),
                 URLQueryItem(name: "X-Amz-Date", value: PAYLOADURL.date),
                 URLQueryItem(name: "X-Amz-Expires", value: PAYLOADURL.expires),
                 URLQueryItem(name: "X-Amz-Signature", value: PAYLOADURL.signature),
                 URLQueryItem(name: "X-Amz-SignedHeaders", value: PAYLOADURL.signedHeaders),
                 URLQueryItem(name: "x-amz-acl", value: PAYLOADURL.acl)
                ]

            if let urlWithQuery = components?.url {
                request.url = urlWithQuery
                
                print("requestURL: \(request.url)")
            }

        default:
            // sendSms 케이스에서 body로 처리
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

    private func createURLRequestForBody(url: URL, image: UIImage? = nil) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let image = image {
            if let imageData = image.jpegData(compressionQuality: 0.8) {
                request.httpBody = imageData
                request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
            }
        } else {
           
            if let parameters = parameters as? [String: Any] {
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                } catch {
                    let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "JSONEncoding")
                    os_log("JSON 인코딩에 실패했습니다. 오류: %@", log: log, type: .error, "\(error)")
                }
            }
        }


        return request
    }

    private func createURLRequestForBodyAndQuery(url: URL, body: String, query: Int, isPresignedURL: Bool = false) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        // body parameter
        var parametersWithBody = parameters
        parametersWithBody["to"] = body

        if let bodyParameters = parametersWithBody as? [String: Any] {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters, options: [])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "JSONEncoding")
                os_log("JSON 인코딩에 실패했습니다. 오류: %@", log: log, type: .error, "\(error)")
            }
        }

        // query parameters
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "code", value: "\(query)")]

        if isPresignedURL {
            components?.queryItems?.append(contentsOf: [
                URLQueryItem(name: "result", value: "true"),
                URLQueryItem(name: "blocking", value: "true")
            ])
        }

        if let urlWithQuery = components?.url {
            request.url = urlWithQuery
        }

        return request
    }
}
