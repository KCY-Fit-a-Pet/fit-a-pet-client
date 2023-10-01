
import UIKit

struct UserModel{
    let id: Int
    let uid: String
    let pw: String
    let phone: Int
    let email: String
    let profile_img: UIImage
}

//extension UserModel{
//    static let list: [UserModel] = [
//        UserModel(id: 1, uid: "heejin", pw: "heejin123", phone: 01012341234, email: "fit@example.com", profile_img: UIImage(systemName: "person")!)
//    ]
//}

class CentralDataStorage {
    static var userList: [UserModel] = []
    
    static func addUser(user: UserModel) {
        userList.append(user)
    }
}
