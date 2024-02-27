
import UIKit

protocol MemberListTableViewMethodDelegate: AnyObject {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
}

class MemberListTableViewMethod: NSObject, UITableViewDataSource, UITableViewDelegate, MemberTableViewCellDelegate {
    weak var delegate: MemberListTableViewMethodDelegate?
    var managerList = PetManagersManager.subManagers
   
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
        
        if UserDefaults.standard.string(forKey: "uid") == managerList[indexPath.row].uid{
            cell.menuButton.isHidden = true
        }
        cell.userDataView.profileUserName.text = managerList[indexPath.row].name
        cell.userDataView.profileUserId.text = "@" + managerList[indexPath.row].uid
        cell.delegate = self
        cell.selectionStyle = .none

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

class MemberInviteListTableViewMethod: NSObject, UITableViewDataSource, UITableViewDelegate, InviteMemberTableViewCellDelegate {
   
    var inviteManagerList = PetManagersManager.inviteManagers
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inviteManagerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteMemberTableViewCell", for: indexPath) as! InviteMemberTableViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.userDataView.profileUserName.text = inviteManagerList[indexPath.row].name
        cell.userDataView.profileUserId.text = "@" + inviteManagerList[indexPath.row].uid
        cell.selectionStyle = .none
        return cell
    }
    
    func updateInviteManagerData(with newData: [InviteManager]) {
        self.inviteManagerList = newData
    }
    
    func cancelButtonTapped(at indexPath: IndexPath) {
          
        print(inviteManagerList[indexPath.row].id)
          AuthorizationAlamofire.shared.deleteInviteMember(SelectedPetId.petId, String(inviteManagerList[indexPath.row].id)) { [self] result in
              switch result {
              case .success(let data):
                  if let responseData = data,
                     let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                      print("response jsonData: \(jsonObject)")
                      let removedManager = inviteManagerList.remove(at: indexPath.row)
                      if let index = PetManagersManager.inviteManagers.firstIndex(where: { $0.id == removedManager.id }) {
                          PetManagersManager.inviteManagers.remove(at: index)
                      }
                      NotificationCenter.default.post(name: .InviteManagerDataUpdated, object: nil)
                  }
                  
              case .failure(let error):
                  print("Error: \(error)")
              }
          }
      }
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
}
