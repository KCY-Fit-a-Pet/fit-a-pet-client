struct RegistrationManager {
    static var shared = RegistrationManager() // Singleton 인스턴스

    var id: String?
    var pw: String?
    var nickname: String?
    var phone: String?

    // Singleton 패턴을 위한 private 생성자
    private init() {}

    // 입력 값을 저장하는 메서드
    mutating func addInput(id: String? = nil, pw: String? = nil, nickname: String? = nil, phone: String? = nil) {
        if let id = id {
            self.id = id
        }
        if let pw = pw {
            self.pw = pw
        }
        if let nickname = nickname {
            self.nickname = nickname
        }
        if let phone = phone {
            self.phone = phone
        }
    }

    func performRegistration() {
        if let id = id, let pw = pw, let nickname = nickname, let phone = phone {
            print("Registered User: ID - \(id), PW - \(pw), Nickname - \(nickname), Phone - \(phone)")
        } else {
            print("Missing information for registration")
        }
    }

//    // 입력 값을 초기화하는 메서드
//    mutating func resetRegistrationInfo() {
//        id = nil
//        pw = nil
//        nickname = nil
//        phone = nil
//    }
}



