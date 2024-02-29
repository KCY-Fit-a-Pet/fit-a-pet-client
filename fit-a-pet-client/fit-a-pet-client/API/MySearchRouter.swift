
import Foundation
import Alamofire
import os.log

enum MySearchRouter: URLRequestConvertible {
    
    //Sms
//    case sendSms(to: String)
//    case checkSms(to: String, code: String)
//    case sendAuthSms(to: String, uid: String)
//    case checkAuthSms(to: String, code: String)
//    case oauthSendSms
//    case oauthCheckSms(code: String)
//    
    //Admin
//    case login(uid: String, password: String)
//    case regist(uid: String, name: String, password: String, email: String, profileImg: String)
//    case findId(phone: String, code: String)
//    case findPw(phone: String, newPassword: String, code: String)
//    case existId(uid: String)
//    case oauthLogin, refresh
//    case oauthRegistUser(name: String, uid: String)
    
    //image
    case presignedurl(dirname: String, extensionType: String, result: Bool, blocking: Bool)
    case uploadImage(image: UIImage)
    
    
    //userInfo
//    case editUserPw(type: String, prePassword: String, newPassword: String)
//    case editUserName(type: String, name: String)
//    case userProfileInfo
//    case userNotifyType(type: String)
//    case searchUserProfile(searchId: String)
    
    
    //pet
    case registPet(petName: String, species: String, gender: String, neutralization: Bool, birthdate: String)
    case userPetsList, userPetInfoList
    
    //pet care
    case createCare(combinedData: [String:Any], petId: Int)
    case checkCareCategory(petId: Int)
    case careCategoryCheck(categoryName: String, pets: [Int])
    case userPetCareInfoList(petId: Int)
    case petCareComplete(petId: Int, careId: Int, caredateId: Int)
    
    
    //schedule
    case createSchedule(combinedData: [String:Any])
    case petScheduleList(year: String, month: String, day: String)
    case petCountScheduleList
    
    //record
    case recordTotalFolderList
    case createRecord(petId: Int, combinedData: [String:Any], memoCategoryId: Int)
    case createFolder(petId: Int, rootMemoCategoryId: Int, categoryName: String)
    case recordDataListInquiry(petId: Int, memoCategoryId: Int, searchData: String)
    
    //manager
    case petManagersList(petId: Int)
    case inviteMember(petId: Int, inviteId: Int)
    case deleteInviteMember(petId: Int, deleteId: String)
    case inviteMemberList(petId: Int)
    
    
    //push test
    case registDeviceToken(deviceToken: String, os: String, deviceModel: String)
    case pushNotificationAPI
    case cancellationManager(petId: Int, userId: Int)
    case managerDelegation(petId: Int, userId: Int)
    
    var baseURL: URL {
        switch self {
        case .presignedurl:
            return URL(string: API.PRESIGNEDURL)!
        case .uploadImage:
            return URL(string: PAYLOADURL.PAYLOAD)!
        default:
            return URL(string: API.BASE_URL)!
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .presignedurl, .registPet, .createCare, .careCategoryCheck, .createSchedule, .createRecord, .createFolder, .inviteMember, .registDeviceToken:
            return .post
        case .checkCareCategory, .userPetsList, .userPetInfoList, .userPetCareInfoList, .petCareComplete, .petScheduleList, .petCountScheduleList, .recordTotalFolderList, .recordDataListInquiry, .petManagersList, .inviteMemberList, .pushNotificationAPI:
            return .get
        case .uploadImage:
            return .put
        case .deleteInviteMember, .cancellationManager:
            return .delete
        case .managerDelegation:
            return .patch
        }
    }
    
    var path: String {
        switch self {
  
        case .presignedurl:
            return "C7QXbC20ti"
        case .uploadImage:
            return ""
            
        case .registPet:
            return "v2/users/\(UserDefaults.standard.string(forKey: "id")!)/pets"
    
        case .recordTotalFolderList:
            return "v2/accounts/\(UserDefaults.standard.string(forKey: "id")!)"
        case .userPetsList:
            return "v2/users/\(UserDefaults.standard.string(forKey: "id")!)/pets/summary"
        case .careCategoryCheck:
            return "v2/users/\(UserDefaults.standard.string(forKey: "id")!)/pets/categories-check"
        case .userPetCareInfoList, .createCare, .checkCareCategory, .petCareComplete, .petCountScheduleList, .createFolder, .createRecord, .recordDataListInquiry, .petManagersList:
            return "v2/pets"
        case .userPetInfoList:
            return "v2/users/\(UserDefaults.standard.string(forKey: "id")!)/pets"
        case .createSchedule:
            return "v2/schedules"
        case .petScheduleList:
            return "v2/accounts/\(UserDefaults.standard.string(forKey: "id")!)/schedules"
        case .inviteMemberList(let petId), .deleteInviteMember(let petId, _), .inviteMember(let petId, _):
            return "v2/pets/\(petId)/managers/invite"
            
        case .cancellationManager(let petId, let userId), .managerDelegation(let petId, let userId):
            return "v2/pets/\(petId)/managers/\(userId)"
        
        case .registDeviceToken:
            return "v2/accounts/\(UserDefaults.standard.string(forKey: "id")!)/device-token"
        case .pushNotificationAPI:
            return "v2/test/members/push"
        }
    }
    
    var parameters : Parameters {
        switch self{
       
        case let .presignedurl(dirname, extensionType, _, _):
            return ["dirname": dirname, "extension": extensionType]
        case let .registPet(petName , species , gender , neutralization , birthdate):
            return ["petName": petName, "species": species, "gender": gender, "neutralization": neutralization, "birthdate": birthdate]
       
        case let .careCategoryCheck(categoryName, pets):
            return ["categoryName": categoryName, "pets": pets]
        case let .petScheduleList(year, month, day):
            return ["year": year, "month": month, "day": day]
        case let .createFolder(_, _ ,categoryName):
            return ["subMemoCategoryName": categoryName]
        case let .inviteMember(_, inviteId):
            return ["inviteId": inviteId]
            
        case let .registDeviceToken(deviceToken, os, deviceModel):
            return ["deviceToken": deviceToken, "os": os, "deviceModel": deviceModel]
        
        case .uploadImage(_), .checkCareCategory, .userPetsList, .createCare, .userPetInfoList, .userPetCareInfoList, .petCareComplete, .createSchedule, .petCountScheduleList, .recordTotalFolderList, .createRecord, .recordDataListInquiry, .petManagersList, .deleteInviteMember, .inviteMemberList, .pushNotificationAPI, .cancellationManager, .managerDelegation :
            return [:]
        
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
            
 
        case .createCare(let combinedData, let petId):
            url = url.appendingPathComponent("/\(petId)/cares")
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request = try JSONEncoding.default.encode(request, withJSONObject: combinedData)
                
        case .presignedurl(let dirname, let extensionType, _, _):
            
            let bodyParameters = ["dirname": dirname, "extension": extensionType] 
           
            let queryParameters = [
                URLQueryItem(name: "result", value: "true"),
                URLQueryItem(name: "blocking", value: "true")
            ]
            request = URLRequest.createURLRequestWithBodyAndQuery(url: url, method: method, bodyParameters: bodyParameters, queryParameters: queryParameters)
            
        case .uploadImage(let image):
            
            let queryParameters = [URLQueryItem(name: "X-Amz-Algorithm", value: PAYLOADURL.algorithm),
             URLQueryItem(name: "X-Amz-Credential", value: PAYLOADURL.credential),
             URLQueryItem(name: "X-Amz-Date", value: PAYLOADURL.date),
             URLQueryItem(name: "X-Amz-Expires", value: PAYLOADURL.expires),
             URLQueryItem(name: "X-Amz-Signature", value: PAYLOADURL.signature),
             URLQueryItem(name: "X-Amz-SignedHeaders", value: PAYLOADURL.signedHeaders),
             URLQueryItem(name: "x-amz-acl", value: PAYLOADURL.acl)
            ]
           
            request = URLRequest.createURLRequestForImage(url: baseURL, method: method, image: image, queryParameters: queryParameters)
        
        case .userPetsList, .userPetInfoList:
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
        
        case .checkCareCategory(let petId):
            url = url.appendingPathComponent("/\(petId)/cares/categories")
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
        case .userPetCareInfoList(let petId):
            url = url.appendingPathComponent("/\(petId)/cares")
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
        case .petCareComplete(let petId, let careId, let caredateId):
            url = url.appendingPathComponent("/\(petId)/cares/\(careId)/care-dates/\(caredateId)")
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
        case .createSchedule(let combinedData):
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request = try JSONEncoding.default.encode(request, withJSONObject: combinedData)
        case .petScheduleList(let year, let month, let day):
            let queryParameters = [URLQueryItem(name: "year", value: year), URLQueryItem(name: "month", value: month),  URLQueryItem(name: "day", value: day)]
            request = URLRequest.createURLRequestWithQuery(url: url,method: method, queryParameters: queryParameters)
        case .petCountScheduleList:
            url = url.appendingPathComponent("/\(SelectedPetId.petId)/schedules")
            let queryParameters = [URLQueryItem(name: "count", value: "3")]
            request = URLRequest.createURLRequestWithQuery(url: url, method: method, queryParameters: queryParameters)
        
        case .recordTotalFolderList:
            url = url.appendingPathComponent("/memo-categories")
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
        case .createRecord(let petId, let combinedData, let memoCategoryId):
            url = url.appendingPathComponent("/\(petId)/memo-categories/\(memoCategoryId)/memos")
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request = try JSONEncoding.default.encode(request, withJSONObject: combinedData)
            
        case .createFolder(let petId, let rootMemoCategoryId, _):
            url = url.appendingPathComponent("/\(petId)/root-memo-categories/\(rootMemoCategoryId)")
            request = URLRequest.createURLRequestWithBody(url: url, method: method, parameters: parameters)
            
        case .recordDataListInquiry(let petId, let memoCategoryId, let searchData):
            url = url.appendingPathComponent("/\(petId)/memo-categories/\(memoCategoryId)/memos")
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
        
        case .petManagersList(let petId):
            url = url.appendingPathComponent("/\(petId)/managers")
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
        
        case .deleteInviteMember(let petId, let deleteId):
            let queryParameters = [URLQueryItem(name: "id", value: deleteId)]
            request = URLRequest.createURLRequestWithQuery(url: url, method: method, queryParameters: queryParameters)
        
        case .cancellationManager( _, _):
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
        
        case .managerDelegation( _, _):
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
        case .inviteMemberList(let petId):    
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
        case .pushNotificationAPI:
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
        
        default:
            request = URLRequest.createURLRequestWithBody(url: url, method: method, parameters: parameters)
        }
        
        return request
    }

}
