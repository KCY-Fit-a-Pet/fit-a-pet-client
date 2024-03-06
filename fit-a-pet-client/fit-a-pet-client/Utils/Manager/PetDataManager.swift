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

struct PetEditResponse: Decodable {
    let data: PetData
    let status: String
}

struct PetEdit: Decodable {
    let pet: PetEditData
}

struct PetEditData: Codable{
    let id: Int
    let petName: String
    let petProfileImage: String
    let gender: String
    let neutered: Bool
    let birthdate: String
    let species: String
    let feed: String
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
    var petId: Int?

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
    static var summaryPets: [SummaryPet] = []
    static var pets: [Pet] = []
    static var careCategoriesByPetId: [Int: [CareCategory]] = [:]
    static var petEditData: PetEditData = PetEditData(id: 0, petName: "", petProfileImage: "", gender: "", neutered: false, birthdate: "", species: "", feed: "")
    
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
    
    static func updateCareInfo(with data: Data, petId: Int) {
        do {
            careCategoriesByPetId[petId] = []
            
            let decoder = JSONDecoder()
            let careInfoResponse = try decoder.decode(CareInfoResponse.self, from: data)
            
            if let newCareCategories = careInfoResponse.data?.careCategories {
                
                if var existingCareCategories = careCategoriesByPetId[petId] {
                    existingCareCategories.append(contentsOf: newCareCategories)
                    careCategoriesByPetId[petId] = existingCareCategories
                } else {
                    careCategoriesByPetId[petId] = newCareCategories
                }
                
                print("careCategories for petId: \(careCategoriesByPetId)")
            }
        } catch {
            print("Error updating care info: \(error)")
        }
    }
}
