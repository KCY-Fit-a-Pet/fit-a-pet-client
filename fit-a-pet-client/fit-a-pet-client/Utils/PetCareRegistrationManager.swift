struct PetCareRegistrationManager {
    static var shared = PetCareRegistrationManager()

    var category: (categoryId: Int, categoryName: String)?
    var care: (careName: String, careDate: [(week: String, time: String)], limitTime: Int)?
    var pets: [(petId: Int, categoryId: Int)]?

    private init() {
        category = nil
        care = nil
        pets = nil
    }

    mutating func addInput(category: (categoryId: Int, categoryName: String)? = nil, care: (careName: String, careDate: [(week: String, time: String)], limitTime: Int)? = nil, pets: [(petId: Int, categoryId: Int)]? = nil) {
        if let category = category {
            self.category = category
        }
        if let care = care {
            self.care = care
        }
        if let pets = pets {
            self.pets = pets
        }
    }

    func performRegistration() {
        if let category = category, let care = care, let pets = pets {
            print("Registered Category: ID - \(category.categoryId), Name - \(category.categoryName)")
            print("Registered Care: Name - \(care.careName), LimitTime - \(care.limitTime)")
            for pet in pets {
                print("Registered Pet: ID - \(pet.petId), CategoryID - \(pet.categoryId)")
            }
        } else {
            print("Missing information for pet care registration")
        }
    }
}

