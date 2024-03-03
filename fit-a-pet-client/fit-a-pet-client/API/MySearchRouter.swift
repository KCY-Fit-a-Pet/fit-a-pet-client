
import Foundation
import Alamofire
import os.log

enum MySearchRouter: URLRequestConvertible {
    
    //image
    case presignedurl(dirname: String, extensionType: String, result: Bool, blocking: Bool)
    case uploadImage(image: UIImage)
    
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
    case deleteInviteMember(petId: Int, invitationId: Int)
    case inviteMemberList(petId: Int)
    case cancellationManager(petId: Int, userId: Int)
    case managerDelegation(petId: Int, userId: Int)
    
    //push test
    case registDeviceToken(deviceToken: String, os: String, deviceModel: String)
    case pushNotificationAPI
  
    
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
        case .presignedurl, .createSchedule, .createRecord, .createFolder, .inviteMember, .registDeviceToken:
            return .post
        case  .petScheduleList, .petCountScheduleList, .recordTotalFolderList, .recordDataListInquiry, .petManagersList, .inviteMemberList, .pushNotificationAPI:
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
    
        case .recordTotalFolderList:
            return "v2/accounts/\(UserDefaults.standard.string(forKey: "id")!)"
        case  .petCountScheduleList, .createFolder, .createRecord, .recordDataListInquiry, .petManagersList:
            return "v2/pets"
        case .createSchedule:
            return "v2/schedules"
        case .petScheduleList:
            return "v2/accounts/\(UserDefaults.standard.string(forKey: "id")!)/schedules"
            
        case .inviteMember(let petId, _),.inviteMemberList(let petId):
            return "v2/pets/\(petId)/invitations"
        
        case .deleteInviteMember(let petId, let invitationId):
            return "v2/pets/\(petId)/invitations/\(invitationId)"
            
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
        case let .petScheduleList(year, month, day):
            return ["year": year, "month": month, "day": day]
        case let .createFolder(_, _ ,categoryName):
            return ["subMemoCategoryName": categoryName]
        case let .inviteMember(_, inviteId):
            return ["inviteId": inviteId]
            
        case let .registDeviceToken(deviceToken, os, deviceModel):
            return ["deviceToken": deviceToken, "os": os, "deviceModel": deviceModel]
        
        case .uploadImage(_), .createSchedule, .petCountScheduleList, .recordTotalFolderList, .createRecord, .recordDataListInquiry, .petManagersList, .deleteInviteMember, .inviteMemberList, .pushNotificationAPI, .cancellationManager, .managerDelegation :
            return [:]
        
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
        
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
            
        case .recordDataListInquiry(let petId, let memoCategoryId, _):
            url = url.appendingPathComponent("/\(petId)/memo-categories/\(memoCategoryId)/memos")
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
        
        case .petManagersList(let petId):
            url = url.appendingPathComponent("/\(petId)/managers")
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
        
        case .deleteInviteMember(_, _), .cancellationManager( _, _), .managerDelegation( _, _), .inviteMemberList( _):
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
