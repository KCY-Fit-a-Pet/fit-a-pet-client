

import Alamofire

enum PetRouter: URLRequestConvertible {

    //pet
    case registPet(petName: String, species: String, gender: String, neutralization: Bool, birthdate: String)
    case userPetsList, userPetInfoList
    case petTotalInfoCheck(petId: Int)
    case petInfoEdit(petId: Int, combinedData: [String:Any])
    
    //pet care
    case createCare(combinedData: [String:Any], petId: Int)
    case checkCareCategory(petId: Int)
    case careCategoryCheck(categoryName: String, pets: [Int])
    case userPetCareInfoList(petId: Int)
    case petCareComplete(petId: Int, careId: Int, caredateId: Int)
    
    var method: HTTPMethod {
        switch self {
        case .registPet, .createCare, .careCategoryCheck:
            return .post
        case .checkCareCategory, .userPetsList, .userPetInfoList, .userPetCareInfoList, .petCareComplete, .petTotalInfoCheck:
            return .get
        case .petInfoEdit:
            return .put
        }
    }
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .userPetsList:
            return "v2/pets/summary"
        case .careCategoryCheck:
            return "v2/users/\(UserDefaults.standard.string(forKey: "id")!)/pets/categories-check"
        case .registPet, .userPetCareInfoList, .createCare, .checkCareCategory, .petCareComplete, .userPetInfoList:
            return "v2/pets"
        case .petTotalInfoCheck(let petId), .petInfoEdit(let petId, _):
            return "v2/pets/\(petId)"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .registPet(petName , species , gender , neutralization , birthdate):
            return ["petName": petName, "species": species, "gender": gender, "neutralization": neutralization, "birthdate": birthdate]
        case let .careCategoryCheck(categoryName, pets):
            return ["categoryName": categoryName, "pets": pets]
        case .checkCareCategory, .userPetsList, .createCare, .userPetInfoList, .userPetCareInfoList, .petCareComplete, .petTotalInfoCheck, .petInfoEdit:
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
            
        case .userPetsList, .userPetInfoList, .petTotalInfoCheck(_):
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
            
        case .petInfoEdit(_ , let combinedData):
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request = try JSONEncoding.default.encode(request, withJSONObject: combinedData)
            
        default:
            request = URLRequest.createURLRequestWithBody(url: url, method: method, parameters: parameters)
        }
        
        return request
    }
}
