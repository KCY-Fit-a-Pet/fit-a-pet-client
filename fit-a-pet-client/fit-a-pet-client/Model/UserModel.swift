
import UIKit

struct UserModel{
    let id: Int
    let name: String
    let uid: String
    let email: String
    let profileImage: UIImage
    let isNotice: Bool
    let isCare: Bool
    let isMemo: Bool
    let isSchedule: Bool
    let phone: String
    
    init(id: Int, name: String, uid: String, email: String, profileImage: UIImage, isNotice: Bool, isCare: Bool, isMemo: Bool, isSchedule: Bool, phone: String) {
        self.id = id
        self.name = name
        self.uid = uid
        self.email = email
        self.profileImage = profileImage
        self.isNotice = isNotice
        self.isCare = isCare
        self.isMemo = isMemo
        self.isSchedule = isSchedule
        self.phone = phone
    }
}

