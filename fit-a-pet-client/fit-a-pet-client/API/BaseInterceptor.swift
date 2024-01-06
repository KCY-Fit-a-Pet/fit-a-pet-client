
import Foundation
import Alamofire

//상속받는 클래스를 RequestInterceptor
class BaseInterceptor : RequestInterceptor{

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("BaseInterceptor - adapt() ")

        var adaptedRequest = urlRequest
        let accessToken = KeychainHelper.loadAccessToken()!
        adaptedRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")

        if let url = adaptedRequest.url, let cookies = HTTPCookieStorage.shared.cookies(for: url) {
            let cookieHeader = HTTPCookie.requestHeaderFields(with: cookies)
            adaptedRequest.allHTTPHeaderFields = cookieHeader
        }

        completion(.success(adaptedRequest))
    }
   
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("BaseInterceptor - retry()")
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            // Check headers in case of a 401 error
            if let allHeaderFields = response.allHeaderFields as? [String: String] {
                print("Response Headers: \(allHeaderFields)")
                
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: allHeaderFields, for: response.url!)
                print(cookies)
                for cookie in cookies {
                    print("Cookie name: \(cookie.name), value: \(cookie.value)")
                }
            }
            // 만료된 토큰 또는 권한이 없는 경우 토큰을 갱신
            print("Token 만료----------------------------")
        } else {
            // 다른 오류의 경우 재시도하지 않음
            completion(.doNotRetry)
        }
    }


    
}
