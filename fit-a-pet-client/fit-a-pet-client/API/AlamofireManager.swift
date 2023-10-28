import Foundation
import Alamofire
import os.log

class AlamofireManager {
    
    // 싱글턴 적용
    static let shared = AlamofireManager() // 자기 자신의 인스턴스를 가져옴
    
    // 로거 설정
    // 자료형이 EventMonitor
    let monitors = [MyLogger(), ApiStatusLogger()] as [EventMonitor] // 여러 개 추가 가능
    
    let session = Session.default
    
    // MARK: - Alamofire methods
    func sendSms(_ phone: String, completion: @escaping(Result<Data?, Error>) -> Void) {
        
        os_log("MyAlamofireManager - sendSms() called userInput : %@", log: .default, type: .info, phone)
            
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

    func checkSms(_ phone: String, _ code: Int, completion: @escaping(Result<Data?, Error>) -> Void) {
        os_log("MyAlamofireManager - checkSms() called userInput : %@ ,, %d", log: .default, type: .info, phone, code)

        self.session.request(MySearchRouter.checkSms(to: phone, code: code))
            .response { response in
                switch response.result {
                case .success(let data):
                    if let responseHeaders = response.response?.allHeaderFields as? [String: String],
                       let accessToken = responseHeaders["accessToken"] {
                        KeychainHelper.saveAccessToken(accessToken: accessToken)
                    }
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    func login(_ uid: String, _ password: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("MyAlamofireManager - login() called userInput : %@ ,, %@", log: .default, type: .info, uid, password)
        
        self
            .session
            .request(MySearchRouter.login(uid: uid, password: password))
            .response { response in
                switch response.result{
                case .success(let data):
                    if let responseHeaders = response.response?.allHeaderFields as? [String: String],
                       let accessToken = responseHeaders["accessToken"] {
                        KeychainHelper.saveAccessToken(accessToken: accessToken)
                        os_log("login token: %@", log: .default, type: .info, accessToken)
                    }
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    func regist(_ uid: String, _ name: String, _ password: String, _ email: String, _ profileImg: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("MyAlamofireManager - regist() called userInput : %@ ,, %@ ,, %@ ,, %@ ,, %@", log: .default, type: .info, uid, password, name, email, profileImg)
        
        self
            .session
            .request(MySearchRouter.regist(uid: uid, name: name, password: password, email: email, profileImg: profileImg))
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

