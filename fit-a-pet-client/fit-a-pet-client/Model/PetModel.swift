

struct PetModel{
    let id: Int
    let pet_name: String
    let gender: String
    //let birth: Date
    let age: Int
    let species: String
}

class PetDataStorage {
    static var petList: [PetModel] = []
    
    static func addPer(pet: PetModel) {
        petList.append(pet)
    }
}
