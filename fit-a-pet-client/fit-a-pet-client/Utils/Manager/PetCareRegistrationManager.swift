struct PetCareRegistrationManager {
    static var shared = PetCareRegistrationManager()
    
    var category: (categoryId: Int, categoryName: String)? {
        didSet {
            if let category = category {
                categoryDictionary = ["categoryId": category.categoryId, "categoryName": category.categoryName]
            } else {
                categoryDictionary = nil
            }
        }
    }

    var careName: String? {
        didSet { updateCareDictionary() }
    }

    var careDates: [[String: String]]? {
        didSet { updateCareDictionary() }
    }

    var limitTime: Int? {
        didSet { updateCareDictionary() }
    }

    var pets: [[String: Int]]? {
        didSet { updatePetsDictionary() }
    }

    private var petsDictionary: [[String: Any]]?
    private var categoryDictionary: [String: Any]?
    private var careDictionary: [String: Any]?

    var categoryDictionaryRepresentation: [String: Any]? {
        return categoryDictionary
    }

    var careDictionaryRepresentation: [String: Any]? {
        return careDictionary
    }

    var petsDictionaryRepresentation: [[String: Any]]? {
        return petsDictionary
    }

    private mutating func updateCareDictionary() {
        if let careName = careName, let careDates = careDates, let limitTime = limitTime {
            careDictionary = ["careName": careName, "careDates": careDates, "limitTime": limitTime]
        } else {
            careDictionary = nil
        }
    }

    private mutating func updatePetsDictionary() {
        petsDictionary = pets
    }

    private init() {
        category = nil
        careName = nil
        careDates = nil
        limitTime = nil
        pets = nil
    }

    mutating func addInput(category: (categoryId: Int, categoryName: String)? = nil, careName: String? = nil, careDates: [[String: String]]? = nil, limitTime: Int? = nil, pets: [[String: Int]]? = nil) {
        if let category = category {
            self.category = category
        }

        if let providedCareName = careName {
            self.careName = providedCareName
        }

        if let providedCareDate = careDates {
            self.careDates = providedCareDate
        }

        if let providedLimitTime = limitTime {
            self.limitTime = providedLimitTime
        }

        if let providedPets = pets {
            self.pets = providedPets
        }
    }

    mutating func setCareDate(from careDates: [fit_a_pet_client.CareDate]) {
        let transformedCareDate = careDates.map { ["week": $0.week, "time": $0.time] }
        self.careDates = transformedCareDate
    }

    func performRegistration() {
        guard let category = category,
              let careName = careName,
              let careDates = careDates,
              let limitTime = limitTime,
              let pets = pets else {
            print("Missing information for pet care registration")
            return
        }

        print("Registered Category: ID - \(category.categoryId), Name - \(category.categoryName)")
        print("Registered Care: Name - \(careName) careDates - \(careDates), LimitTime - \(limitTime)")

        for pet in pets {
            print("Registered Pet: ID - \(pet["petId"] ?? 0), CategoryID - \(pet["categoryId"] ?? 0)")
        }
    }
}

