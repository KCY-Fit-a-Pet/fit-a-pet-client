import Foundation

struct PetInfoResponse: Codable {
    let status: String
    let data: PetData?
}

struct PetData: Codable {
    let pets: [Pet]?
}

//TODO: age 추가
struct Pet: Codable {
    let id: Int
    let petName: String
    let gender: String
    let petProfileImage: String
    let feed: String
    let age: Int
}

struct CareInfoResponse: Codable {
    let status: String
    let data: CareInfo?
}

struct CareInfo: Codable {
    var careCategories: [CareCategory]?

}

struct CareCategory: Codable {
    let careCategoryId: Int
    let categoryName: String
    var cares: [Care]
}

struct Care: Codable {
    let careId: Int
    let careDateId: Int
    let careName: String
    let careDate: String
    let isClear: Bool
}


struct PetDataManager {
    static var pets: [Pet] = []
    static var careCategories: [CareCategory] = []
    static var cares: [Care] = []

    static func updatePets(with data: Data) {
        do {
            let decoder = JSONDecoder()
            let petInfoResponse = try decoder.decode(PetInfoResponse.self, from: data)

            if let newPets = petInfoResponse.data?.pets {
                pets = newPets
                
                print("petsList: \(pets)")
            }
        } catch {
            print("Error updating pet data: \(error)")
        }
    }
    
    
    static func updateCareInfo(with data: Data) {
        do {
            let decoder = JSONDecoder()
            let careInfoResponse = try decoder.decode(CareInfoResponse.self, from: data)
            
            if let newCareCategories = careInfoResponse.data?.careCategories {
                careCategories = newCareCategories
                cares = newCareCategories.flatMap { $0.cares }
                print("careCategories: \(careCategories)")
                print("caresList: \(cares)")
            }
        } catch {
            print("Error updating care info: \(error)")
        }
    }

}
