
import UIKit

protocol MemberListTableViewMethodDelegate: AnyObject {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
}

class MemberListTableViewMethod: NSObject, UITableViewDataSource, UITableViewDelegate, MemberTableViewCellDelegate {
    weak var delegate: MemberListTableViewMethodDelegate?
    var managerList = petManagersManager.subManagers
   
    func didTapChangeName() {
        let nextVC = EditUserNameVC(title: "이름 변경하기")
        delegate?.pushViewController(nextVC, animated: true)
    }
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return managerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberTableViewCell", for: indexPath) as! MemberTableViewCell
        cell.userDataView.profileUserName.text = managerList[indexPath.row].name
        cell.userDataView.profileUserId.text = "@" + managerList[indexPath.row].uid
        cell.delegate = self
        return cell
    }
    
    func updatePetManagerData(with newData: [Manager]) {
        self.managerList = newData
    }
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
}

class MemberInviteListTableViewMethod: NSObject, UITableViewDataSource, UITableViewDelegate {
   
    private var userDataArray: [String] = ["User 1", "User 2", "User 3"]
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteMemberTableViewCell", for: indexPath) as! InviteMemberTableViewCell
        cell.userDataView.profileUserName.text = userDataArray[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
}
