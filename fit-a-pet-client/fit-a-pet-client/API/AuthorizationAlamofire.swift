import Foundation
import Alamofire
import os.log

class AuthorizationAlamofire: TokenHandling {
    
    // 싱글턴 적용
    static let shared = AuthorizationAlamofire()
    
    // 로거 설정
    // 자료형이 EventMonitor
    let monitors = [MyLogger(), ApiStatusLogger()] as [EventMonitor]
    
    let interceptors = Interceptor(interceptors:[BaseInterceptor()])
    
    var session : Session
        
    private init(){
        session = Session(interceptor: interceptors, eventMonitors: monitors)
    }
    
    // MARK: - AuthorizationAlamofire methods
    
    func regist(_ uid: String, _ name: String, _ password: String, _ email: String, _ profileImg: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AuthorizationAlamofire - regist() called userInput : %@ ,, %@ ,, %@ ,, %@ ,, %@", log: .default, type: .info, uid, password, name, email, profileImg)
        
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
    
    func registPet(_ petName: String, _ species: String, _ gender: String, _ neutralization: Bool, _ birthdate: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AuthorizationAlamofire - registPet() called userInput : %@ ,, %@ ,, %@  ,, %@", log: .default, type: .info, petName, species, gender, birthdate)
        
        self
            .session
            .request(MySearchRouter.registPet(petName: petName, species: species, gender: gender, neutralization: neutralization, birthdate: birthdate))
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
    
    func userProfileInfo(completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AuthorizationAlamofire - userProfileInfo() called ", log: .default, type: .info)
        
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
        os_log("AuthorizationAlamofire - userNotifyType() called userInput: %@", log: .default, type: .info, type)
        
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
        os_log("AuthorizationAlamofire - editUserPw() called userInput: %@", log: .default, type: .info, type)
        
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
        os_log("AuthorizationAlamofire - editUserName() called userInput: %@", log: .default, type: .info, type)
        
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

    func oauthRegistUser(_ name: String, _ uid: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AuthorizationAlamofire - oauthCheckSms() called userInput: %@ ,, %@", log: .default, type: .info, name, uid)

        self.session.request(MySearchRouter.oauthRegistUser(name: name, uid: uid))
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
    
    func createCare(combinedData: [String: Any], petId: Int, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - createCare() called userInput: %@", log: .default, type: .info, combinedData)

        self.session.request(MySearchRouter.createCare(combinedData: combinedData, petId: petId))
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    
    func checkCareCategory(_ petId: Int, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - checkCareCategory() called", log: .default, type: .info)
        
        self.session.request(MySearchRouter.checkCareCategory(petId: petId))
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func userPetsList(completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - userPetsList() called", log: .default, type: .info)
        
        self.session.request(MySearchRouter.userPetsList)
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    func careCategoryCheck(_ categoryName: String, _ pets: [Int] ,completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - careCategoryCheck() called ,, %@ ,, %@ ", log: .default, type: .info, categoryName, pets)
        
        self.session.request(MySearchRouter.careCategoryCheck(categoryName: categoryName, pets: pets))
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func userPetInfoList(completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - userPetInfoList() called", log: .default, type: .info)
        
        self.session.request(MySearchRouter.userPetInfoList)
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func userPetCareInfoList(_ petId: Int ,completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - userPetCareInfoList() called", log: .default, type: .info)
        
        self.session.request(MySearchRouter.userPetCareInfoList(petId: petId))
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func petCareComplete(_ petId: Int, _ careId: Int, _ caredateId: Int,completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - userPetCareInfoList() called", log: .default, type: .info)
        
        self.session.request(MySearchRouter.petCareComplete(petId: petId, careId: careId, caredateId: caredateId))
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func createSchedule(_ combinedData: [String: Any], completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - createSchedule() called userInput: %@", log: .default, type: .info)

        self.session.request(MySearchRouter.createSchedule(combinedData: combinedData))
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func petScheduleList(_ year: String, _ month: String, _ day: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - petScheduleList() called userInput: %@ ,, %@ ,, %@", log: .default, type: .info, year, month, day)

        self.session.request(MySearchRouter.petScheduleList(year: year, month: month, day: day))
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func petCountScheduleList(completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - petCountScheduleList() called ", log: .default, type: .info)

        self.session.request(MySearchRouter.petCountScheduleList)
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func recordTotalFolderList(completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - recordTotalFolderList() called ", log: .default, type: .info)
        
        self.session.request(MySearchRouter.recordTotalFolderList)
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func createRecord(_ petId: Int ,_ combinedData: [String: Any], _ memoCategoryId: Int, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - createRecord() called ", log: .default, type: .info)

        self.session.request(MySearchRouter.createRecord(petId: petId, combinedData: combinedData, memoCategoryId: memoCategoryId))
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func createFolder(_ petId: Int ,_ rootMemoCategoryId: Int, _ categoryName: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - createFolder() called ", log: .default, type: .info)

        self.session.request(MySearchRouter.createFolder(petId: petId, rootMemoCategoryId: rootMemoCategoryId, categoryName: categoryName))
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    func recordDataListInquiry(_ petId: Int , _ memoCategoryId: Int, _ searchData: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - recordDataListInquiry() called ", log: .default, type: .info)

        self.session.request(MySearchRouter.recordDataListInquiry(petId: petId, memoCategoryId: memoCategoryId, searchData: searchData))
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func petManagersList(_ petId: Int, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - petManagersList() called ", log: .default, type: .info)

        self.session.request(MySearchRouter.petManagersList(petId: petId))
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func searchUserProfile(_ searchId: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - searchUserProfile() called ", log: .default, type: .info)

        self.session.request(MySearchRouter.searchUserProfile(searchId: searchId))
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

