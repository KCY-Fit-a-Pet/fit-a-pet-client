
import UIKit

struct UserModel{
    let id: Int
    let uid: String
    let pw: String
    let phone: Int
    let email: String
    let profile_img: UIImage
}

class CentralDataStorage {
    static var userList: [UserModel] = []
    
    static func addUser(user: UserModel) {
        userList.append(user)
    }
}
