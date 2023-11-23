struct PetRegistrationManager {
    static var shared = PetRegistrationManager()

    var petName: String?
    var species: String?
    var gender: String?
    var neutralization: Bool
    var birthDate: String?

    private init() {
          petName = nil
          species = nil
          gender = nil
          neutralization = false
          birthDate = nil
    }
    
    mutating func addInput(petName: String? = nil, species: String? = nil, gender: String? = nil, neutralization: Bool? = nil, birthDate: String? = nil) {
        if let petName = petName {
            self.petName = petName
        }
        if let species = species {
            self.species = species
        }
        if let gender = gender {
            self.gender = gender
        }
        if let neutralization = neutralization {
            self.neutralization = neutralization
        }
        if let birthDate = birthDate {
            self.birthDate = birthDate
        }
    }

    func performRegistration() {
        if let petName = petName, let species = species, let gender = gender, let birthDate = birthDate {
            print("Registered Pet: Name - \(petName), Species - \(species), Gender - \(gender), BirthDate - \(birthDate)")
        } else {
            print("Missing information for pet registration")
        }
    }
}

