

import Foundation
import Alamofire

class AlamofireManager{
    
    //싱글턴 적용
    static let shared = AlamofireManager()//자기 자신의 인스턴스를 가져옴
    
    //로거 설정
    //자료형이 EventMonitor
    let monitors = [MyLogger(), ApiStatusLogger()] as [EventMonitor]//여러개 추가 가능
    
    let session = Session.default
    
    //MARK: - Alamofire methods
    func sendSms(_ phone: Int, completion: @escaping(Result<Data?, Error>) -> Void) {
        
        print("MyAlamofireManager - sendSms() called userInput : \(phone) ")
            
        self
            .session //세션 설정
            .request(MySearchRouter.sendSms(phone: phone))
        //                .validate(statusCode: 200..<401)//200에서 401이전까지만
            .response { response in
               switch response.result {
               case .success(let data):
                   completion(.success(data))
               case .failure(let error):
                   completion(.failure(error))
               }
           }
        
    }
    
    func checkSms(_ phone: Int, _ code: Int, completion: @escaping(Result<Data?, Error>) -> Void) {
        
        print("MyAlamofireManager - checkSms() called userInput : \(phone) ,, \(code) ")
            
        self
            .session //세션 설정
            .request(MySearchRouter.checkSms(phone: phone, code: code))
        //                .validate(statusCode: 200..<401)//200에서 401이전까지만
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
        print("MyAlamofireManager - login() called userInput : \(uid) ,, \(password) ")
        
        
        self
            .session
            .request(MySearchRouter.login(uid: uid, password: password))
            .response{ response in
                switch response.result{
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
                
            }
    }
}
