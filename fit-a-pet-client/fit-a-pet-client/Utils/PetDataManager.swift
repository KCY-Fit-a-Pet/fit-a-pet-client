import Foundation

struct PetInfoResponse: Codable {
    let status: String
    let data: PetData?
}

struct PetData: Codable {
    let pets: [Pet]?
}

struct Pet: Codable {
    let id: Int
    let petName: String
    let gender: String
    let petProfileImage: String
    let feed: String
    let age: Int
}

struct SummaryPet{
    let id: Int
    let petName: String
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
    static var summaryPets: [SummaryPet] = [SummaryPet(id: 3, petName: "예시1")]
    static var pets: [Pet] = []
    static var careCategories: [CareCategory] = []

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
                print("careCategories: \(careCategories)")
            }
        } catch {
            print("Error updating care info: \(error)")
        }
    }

}
