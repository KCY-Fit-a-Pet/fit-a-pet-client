struct PetCareRegistrationManager {
    static var shared = PetCareRegistrationManager()

    var careName: String? {
        didSet {
            updateCareDictionary()
        }
    }

    var careDate: [[String: String]]? {
        didSet {
            updateCareDictionary()
        }
    }

    var limitTime: Int? {
        didSet {
            updateCareDictionary()
        }
    }

    var pets: [[String: Int]]? {
        didSet {
            updatePetsDictionary()
        }
    }
    private var petsDictionary: [[String: Any]]?

    var category: (categoryId: Int, categoryName: String)? {
        didSet {
            if let category = category {
                categoryDictionary = ["categoryId": category.categoryId, "categoryName": category.categoryName]
            } else {
                categoryDictionary = nil
            }
        }
    }

    private var categoryDictionary: [String: Any]?

    var categoryDictionaryRepresentation: [String: Any]? {
        return categoryDictionary
    }

    private var careDictionary: [String: Any]?

    var careDictionaryRepresentation: [String: Any]? {
        return careDictionary
    }

    var petsDictionaryRepresentation: [[String: Any]]? {
        return petsDictionary
    }

    private mutating func updateCareDictionary() {
        if let careName = careName, let careDate = careDate, let limitTime = limitTime {
            careDictionary = ["careName": careName, "careDate": careDate, "limitTime": limitTime]
        } else {
            careDictionary = nil
        }
    }

    private mutating func updatePetsDictionary() {
        if let pets = pets {
            petsDictionary = pets
        } else {
            petsDictionary = nil
        }
    }

    private init() {
        category = nil
        careName = nil
        careDate = nil
        limitTime = nil
        pets = nil
    }

    mutating func addInput(category: (categoryId: Int, categoryName: String)? = nil, careName: String? = nil, careDate: [[String: String]]? = nil, limitTime: Int? = nil, pets: [[String: Int]]? = nil) {
        if let category = category {
            self.category = category
        }

        if let providedCareName = careName {
            self.careName = providedCareName
        }

        if let providedCareDate = careDate {
            self.careDate = providedCareDate
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
        self.careDate = transformedCareDate
    }

    func performRegistration() {
        if let category = category, let careName = careName, let careDate = careDate, let limitTime = limitTime, let pets = pets {
            print("Registered Category: ID - \(category.categoryId), Name - \(category.categoryName)")
            print("Registered Care: Name - \(careName), LimitTime - \(limitTime)")
            for pet in pets {
                print("Registered Pet: ID - \(pet["petId"] ?? 0), CategoryID - \(pet["categoryId"] ?? 0)")
            }
        } else {
            print("Missing information for pet care registration")
        }
    }
}

