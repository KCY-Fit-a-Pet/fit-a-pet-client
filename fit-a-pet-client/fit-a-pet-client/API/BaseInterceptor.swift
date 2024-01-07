
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
            
            AnonymousAlamofire.shared.refresh() { result in
                switch result {
                case .success(let data):
                    if let responseData = data{
                        let object = try?JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary
                        guard let jsonObject = object else {return}
                        print("respose jsonData: \(jsonObject)")
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
            completion(.retry)
            
        }else {
        
            completion(.doNotRetry)
        }
    }
}
