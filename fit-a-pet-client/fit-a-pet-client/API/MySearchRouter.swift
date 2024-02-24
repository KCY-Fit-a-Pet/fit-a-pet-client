
import Foundation
import Alamofire
import os.log

enum MySearchRouter: URLRequestConvertible {
    
    case sendSms(to: String)
    case checkSms(to: String, code: String)
    case login(uid: String, password: String)
    case regist(uid: String, name: String, password: String, email: String, profileImg: String)
    case presignedurl(dirname: String, extensionType: String, result: Bool, blocking: Bool)
    case uploadImage(image: UIImage)
    case registPet(petName: String, species: String, gender: String, neutralization: Bool, birthdate: String)
    case sendAuthSms(to: String, uid: String)
    case checkAuthSms(to: String, code: String)
    case findId(phone: String, code: String)
    case findPw(phone: String, newPassword: String, code: String)
    case existId(uid: String)
    case userProfileInfo, oauthLogin, oauthSendSms, refresh ,userPetsList, userPetInfoList, petCountScheduleList, recordTotalFolderList
    case userNotifyType(type: String)
    case editUserPw(type: String, prePassword: String, newPassword: String)
    case editUserName(type: String, name: String)
    case oauthCheckSms(code: String)
    case oauthRegistUser(name: String, uid: String)
    case createCare(combinedData: [String:Any], petId: Int)
    case checkCareCategory(petId: Int)
    case careCategoryCheck(categoryName: String, pets: [Int])
    case userPetCareInfoList(petId: Int)
    case petCareComplete(petId: Int, careId: Int, caredateId: Int)
    case createSchedule(combinedData: [String:Any])
    case petScheduleList(year: String, month: String, day: String)
    case createRecord(petId: Int, combinedData: [String:Any], memoCategoryId: Int)
    case createFolder(petId: Int, rootMemoCategoryId: Int, categoryName: String)
    case recordDataListInquiry(petId: Int, memoCategoryId: Int, searchData: String)
    case petManagersList(petId: Int)
    
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
        case .sendSms, .checkSms, .login, .regist, .presignedurl, .registPet,.sendAuthSms, .checkAuthSms, .findId, .findPw, .oauthLogin, .oauthSendSms, .oauthCheckSms, .oauthRegistUser, .createCare, .careCategoryCheck, .createSchedule, .createRecord, .createFolder:
            return .post
        case .existId, .userProfileInfo, .userNotifyType, .refresh ,.checkCareCategory, .userPetsList, .userPetInfoList, .userPetCareInfoList, .petCareComplete, .petScheduleList, .petCountScheduleList, .recordTotalFolderList, .recordDataListInquiry, .petManagersList:
            return .get
        case .uploadImage, .editUserPw, .editUserName:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .sendSms, .checkSms:
            return "v1/auth/register-sms"
        case .login:
            return "v1/auth/login"
        case .refresh:
            return "v1/auth/refresh"
        case .regist:
            return "v1/auth/register"
        case .presignedurl:
            return "C7QXbC20ti"
        case .uploadImage:
            return ""
        case .registPet:
            return "v2/users/\(UserDefaults.standard.string(forKey: "id")!)/pets"
        case .sendAuthSms, .checkAuthSms:
            return "v1/auth/search-sms"
        case .oauthLogin:
            return "v1/auth/oauth"
        case .oauthSendSms, .oauthCheckSms:
            return "v1/auth/oauth/\(OauthInfo.oauthId)/sms"
        case .oauthRegistUser:
            return "v1/auth/oauth/\(OauthInfo.oauthId)"
        case .findId, .findPw:
            return "v2/accounts/search"
        case .existId:
            return "v2/accounts/exists"
        case .userProfileInfo, .editUserPw, .editUserName, .recordTotalFolderList:
            return "v2/accounts/\(UserDefaults.standard.string(forKey: "id")!)"
        case .userNotifyType:
            return "v2/accounts/\(UserDefaults.standard.string(forKey: "id")!)/notify"
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
        }
    }
    
    var parameters : Parameters {
        switch self{
        case let .sendSms(phone):
            return ["to" : phone]
        case let .sendAuthSms(phone, uid):
            return ["to" : phone, "uid": uid]
        case let .checkSms(phone, code),
            let .checkAuthSms(phone, code):
            return ["to": phone, "code": code]
        case let .login(uid, password):
            return ["uid": uid, "password": password]
        case let .regist(uid, name, password , email, profileImg):
            return ["uid": uid, "name": name, "password": password, "email": email, "profileImg": profileImg]
        case let .presignedurl(dirname, extensionType, _, _):
            return ["dirname": dirname, "extension": extensionType]
        case let .registPet(petName , species , gender , neutralization , birthdate):
            return ["petName": petName, "species": species, "gender": gender, "neutralization": neutralization, "birthdate": birthdate]
        case let .findId(phone, code):
            return ["phone":phone, "code": code]
        case let .findPw(phone, newPassword, code):
            return ["phone": phone, "newPassword": newPassword, "code": code]
        case let .existId(uid):
            return ["uid": uid]
        case let .userNotifyType(type):
            return ["type": type]
        case let .editUserPw(type, prePassword, newPassword):
            return ["type": type, "prePassword": prePassword, "newPassword": newPassword]
        case let .editUserName(type, name):
            return ["type": type, "name": name]
        case let .oauthCheckSms(code):
            return ["code": code]
        case let .oauthRegistUser(name, uid):
            return ["name": name, "uid": uid]
        case let .careCategoryCheck(categoryName, pets):
            return ["categoryName": categoryName, "pets": pets]
        case let .petScheduleList(year, month, day):
            return ["year": year, "month": month, "day": day]
        case let .createFolder(_, _ ,categoryName):
            return ["subMemoCategoryName": categoryName]
        case .uploadImage(_), .userProfileInfo, .oauthLogin, .oauthSendSms, .refresh, .checkCareCategory, .userPetsList, .createCare, .userPetInfoList, .userPetCareInfoList, .petCareComplete, .createSchedule, .petCountScheduleList, .recordTotalFolderList, .createRecord, .recordDataListInquiry, .petManagersList:
            return [:]
        
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var url = baseURL.appendingPathComponent(path)
        var request: URLRequest
        
        switch self {
            
        case .checkSms(let to, let code):
            let bodyParameters = ["to": to]
            let queryParameters = [URLQueryItem(name: "code", value: "\(code)")]
            
            request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
            
//        case .regist:
//            request = createURLRequestWithBody(url: url)
       
        case .createCare(let combinedData, let petId):
            url = url.appendingPathComponent("/\(petId)/cares")
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request = try JSONEncoding.default.encode(request, withJSONObject: combinedData)
                
        case .refresh:
            request = URLRequest(url: url)
            
            if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
                let cookieHeader = HTTPCookie.requestHeaderFields(with: cookies)
                request.allHTTPHeaderFields = cookieHeader
            }         
            
        case .presignedurl(let dirname, let extensionType, _, _):
            
            let bodyParameters = ["dirname": dirname, "extension": extensionType] 
           
            let queryParameters = [
                URLQueryItem(name: "result", value: "true"),
                URLQueryItem(name: "blocking", value: "true")
            ]
            request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
            
        case .uploadImage(let image):
            
            let queryParameters = [URLQueryItem(name: "X-Amz-Algorithm", value: PAYLOADURL.algorithm),
             URLQueryItem(name: "X-Amz-Credential", value: PAYLOADURL.credential),
             URLQueryItem(name: "X-Amz-Date", value: PAYLOADURL.date),
             URLQueryItem(name: "X-Amz-Expires", value: PAYLOADURL.expires),
             URLQueryItem(name: "X-Amz-Signature", value: PAYLOADURL.signature),
             URLQueryItem(name: "X-Amz-SignedHeaders", value: PAYLOADURL.signedHeaders),
             URLQueryItem(name: "x-amz-acl", value: PAYLOADURL.acl)
            ]
           
            request = createURLRequestForImage(url: baseURL, image: image, queryParameters: queryParameters)
          
//        case .registPet:
//            request = createURLRequestWithBody(url: url)
            
        case .sendAuthSms(let to, let uid):
            var bodyParameters: [String: String] = [:]
            
            if  FindIdPwSwitch.findtype == uid{
                bodyParameters = ["to": to]
            }else{
                bodyParameters = ["to": to, "uid": uid]
            }
            let queryParameters = [URLQueryItem(name: "type", value: FindIdPwSwitch.findtype)]
            request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)

        
        case .checkAuthSms(let to, let code):
            let bodyParameters = ["to": to]
            let queryParameters = [URLQueryItem(name: "type", value: FindIdPwSwitch.findtype),URLQueryItem(name: "code", value: "\(code)")]
            
            request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
        case .findId(let phone, let code):
            let bodyParameters = ["phone": phone]
            let queryParameters = [URLQueryItem(name: "type", value: FindIdPwSwitch.findtype),URLQueryItem(name: "code", value: "\(code)")]
            
            request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
        
        case .findPw(let phone, let newPassword, let code):
            let bodyParameters = ["phone": phone, "newPassword": newPassword]
            let queryParameters = [URLQueryItem(name: "type", value: FindIdPwSwitch.findtype),URLQueryItem(name: "code", value: "\(code)")]
            
            request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
        
        case .existId(let uid):
            let queryParameters = [URLQueryItem(name: "uid", value: "\(uid)")]
            
            request = createURLRequestWithQuery(url: url, queryParameters: queryParameters)
        
        case .userProfileInfo:
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
       
        case .userNotifyType(let type):
            
            let queryParameters = [URLQueryItem(name: "type", value: type)]

            request = createURLRequestWithQuery(url: url, queryParameters: queryParameters)
            
        case .editUserPw(let type, let prePassword, let newPassword):
            let bodyParameters = ["prePassword": prePassword, "newPassword": newPassword]
            let queryParameters = [URLQueryItem(name: "type", value: type)]
            
            request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
        
        case .editUserName(let type, let name):
            let bodyParameters = ["name": name]
            let queryParameters = [URLQueryItem(name: "type", value: type)]
            
            request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
            
        case .oauthLogin:
            let idToken = KeychainHelper.loadTempToken()!
            
            let bodyParameters = ["id": OauthInfo.oauthId, "idToken": idToken, "nonce": OauthInfo.nonce] as [String : Any]
            let queryParameters = [URLQueryItem(name: "provider", value: OauthInfo.provider)]
            
            request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
        
        case .oauthSendSms:
            let idToken = KeychainHelper.loadTempToken()!
            
            let bodyParameters = ["to": RegistrationManager.shared.phone!, "idToken": idToken, "nonce": OauthInfo.nonce] as [String : Any]
            let queryParameters = [URLQueryItem(name: "provider", value: OauthInfo.provider)]
            
            request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
        case .oauthCheckSms(let code):
            let idToken = KeychainHelper.loadTempToken()!
            
            let bodyParameters = ["to": RegistrationManager.shared.phone!, "idToken": idToken, "nonce": OauthInfo.nonce] as [String : Any]
            let queryParameters = [URLQueryItem(name: "provider", value: OauthInfo.provider), URLQueryItem(name: "code", value: code)]
            
            request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
        
        case .oauthRegistUser(let name, let uid):
            let idToken = KeychainHelper.loadTempToken()!
            
            let bodyParameters = ["name": name, "uid": uid, "idToken": idToken, "nonce": OauthInfo.nonce] as [String : Any]
            let queryParameters = [URLQueryItem(name: "provider", value: OauthInfo.provider)]
            
            request = createURLRequestWithBodyAndQuery(url: url, bodyParameters: bodyParameters, queryParameters: queryParameters)
        
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
            request = createURLRequestWithQuery(url: url, queryParameters: queryParameters)
        case .petCountScheduleList:
            url = url.appendingPathComponent("/\(SelectedPetId.petId)/schedules")
            let queryParameters = [URLQueryItem(name: "count", value: "3")]
            request = createURLRequestWithQuery(url: url, queryParameters: queryParameters)
        
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
            request = createURLRequestWithBody(url: url)
            
        case .recordDataListInquiry(let petId, let memoCategoryId, let searchData):
            url = url.appendingPathComponent("/\(petId)/memo-categories/\(memoCategoryId)/memos")
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
        
        case .petManagersList(let petId):
            url = url.appendingPathComponent("/\(petId)/managers")
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
        default:
            request = createURLRequestWithBody(url: url)
        }
        
        return request
    }
    
    private func createURLRequestWithBody(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        
        if let parameters = parameters as? [String: Any] {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "JSONEncoding")
                os_log("JSON 인코딩에 실패했습니다. 오류: %@", log: log, type: .error, "\(error)")
            }
        }
        
        return request
    }
    
    private func createURLRequestWithQuery(url: URL, queryParameters: [URLQueryItem]) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = queryParameters
        
        if let urlWithQuery = components?.url {
            print("requestURL: \(urlWithQuery)")
            request.url = urlWithQuery
        }
        
        return request
    }
    private func createURLRequestWithBodyAndQuery(url: URL, bodyParameters: [String: Any], queryParameters: [URLQueryItem]) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "JSONEncoding")
            os_log("JSON encoding failed. Error: %@", log: log, type: .error, "\(error)")
        }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = queryParameters

        if let urlWithQuery = components?.url {
            request.url = urlWithQuery
        }

        return request
    }
    
    private func createURLRequestForImage(url: URL, image: UIImage, queryParameters: [URLQueryItem]) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return request
        }
           
        request.httpBody = imageData
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = queryParameters
        
        if let urlWithQuery = components?.url {
            request.url = urlWithQuery
        }
        
        //os_log
        let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "AlamofireRequest")
        os_log("Request URL: %@", log: log, type: .debug, "\(String(describing: request.url))")
        return request
    }
}
