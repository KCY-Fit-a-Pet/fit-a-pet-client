import Foundation
import Alamofire
import OSLog

protocol TokenHandling {
    func extractAndStoreToken(from response: AFDataResponse<Data?>)
}
//eyJyZWdEYXRlIjoxNzA0NDM3ODE1NTU2LCJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiUk9MRV9BRE1JTiIsInVzZXJJZCI6MywiZXhwIjoxNzA0NDM3ODI1fQ.jusvZ5nouNjrcFZw7SNPw4y7AbdfzSG07NMnVMOBzOo
extension TokenHandling {
    func extractAndStoreToken(from response: AFDataResponse<Data?>) {
        if let responseHeaders = response.response?.allHeaderFields as? [String: String],
           let accessToken = responseHeaders["accessToken"] {
            
            if let data = response.value {
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: responseHeaders, for: response.response!.url!)
                for cookie in cookies {
                    print("Cookie name: \(cookie.name), value: \(cookie.value)")
                    
                    let nsCookie = HTTPCookie(properties: [
                        HTTPCookiePropertyKey.name: cookie.name,
                        HTTPCookiePropertyKey.value: "eyJyZWdEYXRlIjoxNzA0NDM3ODE1NTU2LCJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiUk9MRV9BRE1JTiIsInVzZXJJZCI6MywiZXhwIjoxNzA0NDM3ODI1fQ.jusvZ5nouNjrcFZw7SNPw4y7AbdfzSG07NMnVMOBzOo",
                        HTTPCookiePropertyKey.domain: cookie.domain,
                        HTTPCookiePropertyKey.path: cookie.path,
                        HTTPCookiePropertyKey.version: NSNumber(value: cookie.version),
                        HTTPCookiePropertyKey.expires: cookie.expiresDate ?? Date.distantFuture
                    ])
                    
                    HTTPCookieStorage.shared.setCookie(nsCookie!)
                }
            }
            
            KeychainHelper.saveAccessToken(accessToken: "eyJyZWdEYXRlIjoxNzA0NDM3ODE1NTA3LCJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiUk9MRV9BRE1JTiIsInVzZXJJZCI6MywiZXhwIjoxNzA0NDM3ODI1fQ.WUboJyeTL7XYLC7Vi21sqc7kxDDAzLHC22fLxm6iDJQ")
            os_log("accesstoken: %@", log: .default, type: .info, accessToken)
        }
    }
}

