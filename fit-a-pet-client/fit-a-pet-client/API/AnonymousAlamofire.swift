import Foundation
import Alamofire
import os.log

class AnonymousAlamofire: TokenHandling {
    
    // 싱글턴 적용
    static let shared = AnonymousAlamofire() // 자기 자신의 인스턴스를 가져옴
    
    var session = Session.default
    
    // MARK: - AnonymousAlamofire methods
    
    func sendSms(_ phone: String, completion: @escaping(Result<Data?, Error>) -> Void) {
        
        os_log("AuthorizationAlamofire - sendSms() called userInput : %@", log: .default, type: .info, phone)
        
        self
            .session // 세션 설정
            .request(MySearchRouter.sendSms(to: phone))
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    
    func checkSms(_ phone: String, _ code: String, completion: @escaping(Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - checkSms() called userInput : %@ ,, %d", log: .default, type: .info, phone, code)
        
        self.session.request(MySearchRouter.checkSms(to: phone, code: code))
            .response { response in
                switch response.result {
                case .success(let data):
                    if let responseHeaders = response.response?.allHeaderFields as? [String: String],
                       let accessToken = responseHeaders["accessToken"]{
                        KeychainHelper.saveAccessToken(accessToken: accessToken)
                        os_log("sms token: %@", log: .default, type: .info, accessToken)
                    }
                    
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    func login(_ uid: String, _ password: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AuthorizationAlamofire - login() called userInput : %@ ,, %@", log: .default, type: .info, uid, password)
        
        self
            .session
            .request(MySearchRouter.login(uid: uid, password: password))
            .response { response in
                switch response.result{
                case .success(let data):
                    self.extractAndStoreToken(from: response)
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        
    }
    
    func sendAuthSms(_ phone: String, _ uid: String, completion: @escaping(Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - sendAuthSms() called userInput : %@ ,, %@  ", log: .default, type: .info, phone, uid)

        self.session.request(MySearchRouter.sendAuthSms(to: phone, uid: uid))
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    func checkAuthSms(_ phone: String, _ code: String, completion: @escaping(Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - checkAuthSms() called userInput : %@ ,, %@", log: .default, type: .info, phone, code)

        self.session.request(MySearchRouter.checkAuthSms(to: phone, code: code))
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    func findId(_ phone: String, _ code: String, completion: @escaping(Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - findId() called userInput : %@ ,, %@", log: .default, type: .info, phone, code)

        self.session.request(MySearchRouter.findId(phone: phone, code: code))
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    func existId(_ uid: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AuthorizationAlamofire - existId() called userInput : %@", log: .default, type: .info, uid)
        
        self.session.request(MySearchRouter.existId(uid: uid))
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    func findPw(_ phone: String, _ newPassword: String, _ code: String, completion: @escaping(Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - findPw() called userInput : %@ ,, %@ ,, %@", log: .default, type: .info, phone,newPassword, code)

        self.session.request(MySearchRouter.findPw(phone: phone, newPassword: newPassword, code: code))
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    func presignedURL(_ dirname: String, _ extensionType: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AuthorizationAlamofire - presignedURL() called : %@ ,, %@ ", log: .default, type: .info, dirname, extensionType)
        
        self
            .session
            .request(MySearchRouter.presignedurl(dirname: dirname, extensionType: extensionType, result: true, blocking: true))
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    func uploadImage(_ image: UIImage, completion: @escaping(Result<Data?, Error>) -> Void){
        
        os_log("AuthorizationAlamofire - uploadImage() called ", log: .default, type: .info)
        
        self
            .session
            .request(MySearchRouter.uploadImage(image: image))
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    func oauthLogin(completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AuthorizationAlamofire - oauthLogin() called", log: .default, type: .info)
        
        self.session.request(MySearchRouter.oauthLogin)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    func oauthSendSms(completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AuthorizationAlamofire - oauthSendSms() called", log: .default, type: .info)

        self.session.request(MySearchRouter.oauthSendSms)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func oauthCheckSms(_ code: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AuthorizationAlamofire - oauthCheckSms() called userInput: %@", log: .default, type: .info, code)

        self.session.request(MySearchRouter.oauthCheckSms(code: code))
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success(let data):
                    if let responseHeaders = response.response?.allHeaderFields as? [String: String],
                       let accessToken = responseHeaders["accessToken"] {
                        KeychainHelper.saveAccessToken(accessToken: accessToken)
                        os_log("sms token: %@", log: .default, type: .info, accessToken)
                    }
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
}
