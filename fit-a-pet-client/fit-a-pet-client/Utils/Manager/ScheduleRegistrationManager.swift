struct ScheduleRegistrationManager {
    static var shared = ScheduleRegistrationManager()

    var scheduleName: String?
    var location: String?
    var reservationDate: String?
    var notifyTime: Int?
    var petIds: [Int]?

    private init() {
        scheduleName = nil
        location = nil
        reservationDate = nil
        notifyTime = nil
        petIds = nil
    }

    mutating func addInput(scheduleName: String? = nil, location: String? = nil, reservationDate: String? = nil, notifyTime: Int? = nil, petIds: [Int]? = nil) {
        if let scheduleName = scheduleName {
            self.scheduleName = scheduleName
        }
        if let location = location {
            self.location = location
        }
        if let reservationDate = reservationDate {
            self.reservationDate = reservationDate
        }
        if let notifyTime = notifyTime {
            self.notifyTime = notifyTime
        }
        if let petIds = petIds {
            self.petIds = petIds
        }
    }

    func performRegistration() {
        if let scheduleName = scheduleName,
           let location = location,
           let reservationDate = reservationDate,
           let notifyTime = notifyTime,
           let petIds = petIds {
            print("""
                Registered Schedule:
                Schedule Name - \(scheduleName)
                Location - \(location)
                Reservation Date - \(reservationDate)
                Notify Time - \(notifyTime)
                Pet Ids - \(petIds)
            """)
        } else {
            print("Missing information for schedule registration")
        }
    }
}

