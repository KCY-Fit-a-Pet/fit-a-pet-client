struct RegistrationManager {
    static var shared = RegistrationManager() // Singleton 인스턴스

    var id: String?
    var pw: String?
    var nickname: String?
    var phone: Int?

    // Singleton 패턴을 위한 private 생성자
    private init() {}

    // 입력 값을 저장하는 메서드
    mutating func addInput(id: String? = nil, pw: String? = nil, nickname: String? = nil, phone: Int? = nil) {
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

    // 회원가입 처리 또는 다른 작업을 수행하는 메서드
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



