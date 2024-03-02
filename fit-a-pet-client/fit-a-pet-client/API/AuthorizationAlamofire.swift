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
    
    //MARK: AdminRouter
    
    func regist(_ uid: String, _ name: String, _ password: String, _ email: String, _ profileImg: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AuthorizationAlamofire - regist() called userInput : %@ ,, %@ ,, %@ ,, %@ ,, %@", log: .default, type: .info, uid, password, name, email, profileImg)
        
        self
            .session
            .request(AdminRouter.regist(uid: uid, name: name, password: password, email: email, profileImg: profileImg))
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
    func oauthRegistUser(_ name: String, _ uid: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AuthorizationAlamofire - oauthRegistUser() called userInput: %@ ,, %@", log: .default, type: .info, name, uid)

        self.session.request(AdminRouter.oauthRegistUser(name: name, uid: uid))
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
    
    //MARK: PetRouter
    
    func registPet(_ petName: String, _ species: String, _ gender: String, _ neutralization: Bool, _ birthdate: String, completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AuthorizationAlamofire - registPet() called userInput : %@ ,, %@ ,, %@  ,, %@", log: .default, type: .info, petName, species, gender, birthdate)
        
        self
            .session
            .request(PetRouter.registPet(petName: petName, species: species, gender: gender, neutralization: neutralization, birthdate: birthdate))
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
    func createCare(combinedData: [String: Any], petId: Int, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - createCare() called userInput: %@", log: .default, type: .info, combinedData)

        self.session.request(PetRouter.createCare(combinedData: combinedData, petId: petId))
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
        
        self.session.request(PetRouter.checkCareCategory(petId: petId))
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
        
        self.session.request(PetRouter.userPetsList)
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
        
        self.session.request(PetRouter.careCategoryCheck(categoryName: categoryName, pets: pets))
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
        
        self.session.request(PetRouter.userPetInfoList)
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
        
        self.session.request(PetRouter.userPetCareInfoList(petId: petId))
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
        
        self.session.request(PetRouter.petCareComplete(petId: petId, careId: careId, caredateId: caredateId))
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    //MARK: UserInfoRouter
    
    func userProfileInfo(completion: @escaping(Result<Data?, Error>) -> Void){
        os_log("AuthorizationAlamofire - userProfileInfo() called ", log: .default, type: .info)
        
        self.session.request(UserInfoRouter.userProfileInfo)
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
        
        self.session.request(UserInfoRouter.userNotifyType(type: type))
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
        
        self.session.request(UserInfoRouter.editUserPw(type: type, prePassword: prePassword, newPassword: newPassword))
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
        
        self.session.request(UserInfoRouter.editUserName(type: type, name: name))
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
    
    func searchUserProfile(_ searchId: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - searchUserProfile() called ", log: .default, type: .info)

        self.session.request(UserInfoRouter.searchUserProfile(searchId: searchId))
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func userNicknameCheck(_ userId: Int, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - userNicknameCheck() called ", log: .default, type: .info)

        self.session.request(UserInfoRouter.userNicknameCheck(userId: userId))
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    
    //MARK: MySearchRouter
    
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
    
    func inviteMember(_ petId: Int, _ inviteId: Int, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - inviteMember() called ", log: .default, type: .info)

        self.session.request(MySearchRouter.inviteMember(petId: petId, inviteId: inviteId))
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func deleteInviteMember(_ petId: Int, _ deleteId: String, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - deleteInviteMember() called ", log: .default, type: .info)

        self.session.request(MySearchRouter.deleteInviteMember(petId: petId, deleteId: deleteId))
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    func inviteMemberList(_ petId: Int, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - inviteMember() called ", log: .default, type: .info)

        self.session.request(MySearchRouter.inviteMemberList(petId: petId))
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func cancellationManager(_ petId: Int, _ userId: Int, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - cancellationManager() called ", log: .default, type: .info)

        self.session.request(MySearchRouter.cancellationManager(petId: petId, userId: userId))
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    func managerDelegation(_ petId: Int, _ userId: Int, completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - managerDelegation() called ", log: .default, type: .info)

        self.session.request(MySearchRouter.managerDelegation(petId: petId, userId: userId))
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    
    
    func registDeviceToken(_ deviceToken: String, _ os: String, _ deviceModel: String,completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - RegistdeviceToken() called ", log: .default, type: .info)
        
        self.session.request(MySearchRouter.registDeviceToken(deviceToken: deviceToken, os: os, deviceModel: deviceModel))
            .response { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func pushNotificationAPI(completion: @escaping (Result<Data?, Error>) -> Void) {
        os_log("AuthorizationAlamofire - pushNotificationAPI() called ", log: .default, type: .info)
        
        self.session.request(MySearchRouter.pushNotificationAPI)
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

