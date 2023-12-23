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

    func checkSms(_ phone: String, _ code: String, completion: @escaping(Result<Data?, Error>) -> Void) {
        os_log("MyAlamofireManager - checkSms() called userInput : %@ ,, %d", log: .default, type: .info, phone, code)

        self.session.request(MySearchRouter.checkSms(to: phone, code: code))
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
    
    func login(_ uid: String, _ password: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("MyAlamofireManager - login() called userInput : %@ ,, %@", log: .default, type: .info, uid, password)
        
        self
            .session
            .request(MySearchRouter.login(uid: uid, password: password))
            .validate(statusCode: 200..<300)
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
    
    func presignedURL(_ dirname: String, _ extensionType: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("MyAlamofireManager - presignedURL() called : %@ ,, %@ ", log: .default, type: .info, dirname, extensionType)
        
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
        
        os_log("MyAlamofireManager - uploadImage() called ", log: .default, type: .info)
        
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
    
    func registPet(_ petName: String, _ species: String, _ gender: String, _ neutralization: Bool, _ birthDate: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("MyAlamofireManager - registPet() called userInput : %@ ,, %@ ,, %@ ,, %@ ,, %@", log: .default, type: .info, petName, species, gender, neutralization, birthDate)
        
        self
            .session
            .request(MySearchRouter.registPet(petName: petName, species: species, gender: gender, neutralization: neutralization, birthDate: birthDate))
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
    func sendAuthSms(_ phone: String, _ uid: String, completion: @escaping(Result<Data?, Error>) -> Void) {
        os_log("MyAlamofireManager - sendAuthSms() called userInput : %@ ,, %@  ", log: .default, type: .info, phone, uid)

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
        os_log("MyAlamofireManager - checkAuthSms() called userInput : %@ ,, %@", log: .default, type: .info, phone, code)

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
        os_log("MyAlamofireManager - findId() called userInput : %@ ,, %@", log: .default, type: .info, phone, code)

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
    
    func findPw(_ phone: String, _ newPassword: String, _ code: String, completion: @escaping(Result<Data?, Error>) -> Void) {
        os_log("MyAlamofireManager - findPw() called userInput : %@ ,, %@ ,, %@", log: .default, type: .info, phone,newPassword, code)

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
    func existId(_ uid: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("MyAlamofireManager - existId() called userInput : %@", log: .default, type: .info, uid)
        
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
    
    func userProfileInfo(completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("MyAlamofireManager - userProfileInfo() called ", log: .default, type: .info)
        
        self.session.request(MySearchRouter.userProfileInfo)
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
    func userNotifyType(_ type: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("MyAlamofireManager - userNotifyType() called userInput: %@", log: .default, type: .info, type)
        
        self.session.request(MySearchRouter.userNotifyType(type: type))
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
    
    func editUserPw(_ type: String, _ prePassword: String, _ newPassword: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("MyAlamofireManager - editUserPw() called userInput: %@", log: .default, type: .info, type)
        
        self.session.request(MySearchRouter.editUserPw(type: type, prePassword: prePassword, newPassword: newPassword))
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
    func editUserName(_ type: String, _ name: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("MyAlamofireManager - editUserName() called userInput: %@", log: .default, type: .info, type)
        
        self.session.request(MySearchRouter.editUserName(type: type, name: name))
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
    
    func kakaoCodeGet(completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("MyAlamofireManager - kakaoCodeGet() called ", log: .default, type: .info)

        self.session.request(MySearchRouter.kakaoCode)
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
}

