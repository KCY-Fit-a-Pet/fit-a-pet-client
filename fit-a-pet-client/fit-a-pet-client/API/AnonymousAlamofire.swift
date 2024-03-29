import Foundation
import Alamofire
import os.log

class AnonymousAlamofire: TokenHandling {
    
    // 싱글턴 적용
    static let shared = AnonymousAlamofire() // 자기 자신의 인스턴스를 가져옴
    
    var session = Session.default
    
    // MARK: - AnonymousAlamofire methods
    
    //MARK: SmsRouter
    func sendSms(_ phone: String, completion: @escaping(Result<Data?, Error>) -> Void) {
        
        os_log("AnonymousAlamofire - sendSms() called userInput : %@", log: .default, type: .info, phone)
        
        self
            .session // 세션 설정
            .request(SmsRouter.sendSms(to: phone))
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
        os_log("AnonymousAlamofire - checkSms() called userInput : %@ ,, %d", log: .default, type: .info, phone, code)
        
        self.session.request(SmsRouter.checkSms(to: phone, code: code))
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
    
    func sendAuthSms(_ phone: String, _ uid: String, completion: @escaping(Result<Data?, Error>) -> Void) {
        os_log("AnonymousAlamofire - sendAuthSms() called userInput : %@ ,, %@  ", log: .default, type: .info, phone, uid)

        self.session.request(SmsRouter.sendAuthSms(to: phone, uid: uid))
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
        os_log("AnonymousAlamofire - checkAuthSms() called userInput : %@ ,, %@", log: .default, type: .info, phone, code)

        self.session.request(SmsRouter.checkAuthSms(to: phone, code: code))
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
        os_log("AnonymousAlamofire - oauthSendSms() called", log: .default, type: .info)

        self.session.request(SmsRouter.oauthSendSms)
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
        os_log("AnonymousAlamofire - oauthCheckSms() called userInput: %@", log: .default, type: .info, code)

        self.session.request(SmsRouter.oauthCheckSms(code: code))
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
    
    //MARK: AdminRouter
    
    func login(_ uid: String, _ password: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AnonymousAlamofire - login() called userInput : %@ ,, %@", log: .default, type: .info, uid, password)
        
        self
            .session
            .request(AdminRouter.login(uid: uid, password: password))
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
    
    
    func findId(_ phone: String, _ code: String, completion: @escaping(Result<Data?, Error>) -> Void) {
        os_log("AnonymousAlamofire - findId() called userInput : %@ ,, %@", log: .default, type: .info, phone, code)

        self.session.request(AdminRouter.findId(phone: phone, code: code))
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
        os_log("AnonymousAlamofire - existId() called userInput : %@", log: .default, type: .info, uid)
        
        self.session.request(AdminRouter.existId(uid: uid))
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
        os_log("AnonymousAlamofire - findPw() called userInput : %@ ,, %@ ,, %@", log: .default, type: .info, phone,newPassword, code)

        self.session.request(AdminRouter.findPw(phone: phone, newPassword: newPassword, code: code))
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
    
    func oauthLogin(completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AnonymousAlamofire - oauthLogin() called", log: .default, type: .info)
        
        self.session.request(AdminRouter.oauthLogin)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success(let data):
                    self.extractAndStoreToken(from: response)
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    func refresh(completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AnonymousAlamofire - refreshToken() called ", log: .default, type: .info)

        self.session.request(AdminRouter.refresh)
            .response { response in
                switch response.result {
                case .success(let data):
                    self.extractAndStoreToken(from: response)
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    
    func presignedURL(_ dirname: String, _ extensionType: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AnonymousAlamofire - presignedURL() called : %@ ,, %@ ", log: .default, type: .info, dirname, extensionType)
        
        self
            .session
            .request(MySearchRouter.presignedurl(dirname: dirname, extensionType: extensionType, result: true, blocking: true))
//            .validate(statusCode: 200..<300)
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
        
        os_log("AnonymousAlamofire - uploadImage() called ", log: .default, type: .info)
        
        self
            .session
            .request(MySearchRouter.uploadImage(image: image))
//            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
}
