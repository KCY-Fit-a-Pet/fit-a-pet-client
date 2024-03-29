
import UIKit

protocol MemberListTableViewMethodDelegate: AnyObject {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func presentViewContoller(_ viewController: UIViewController, animated: Bool)
}

class MemberListTableViewMethod: NSObject, UITableViewDataSource, UITableViewDelegate, MemberTableViewCellDelegate {
    
    weak var delegate: MemberListTableViewMethodDelegate?
    var managerList = PetManagersManager.subManagers
   
    func didTapChangeName(_ userId: Int) {

        AuthorizationAlamofire.shared.userNicknameCheck(userId){ result in
            switch result {
            case .success(let data):
                if let responseData = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                            if let jsonData = json["data"] as? [String: Any], let name = jsonData["name"] as? String {
                                let nextVC = EditUserNameVC(title: "이름 변경하기")
                                nextVC.beforeUserName = name
                                nextVC.division = "someone"
                                nextVC.selectedId = userId
                                self.delegate?.pushViewController(nextVC, animated: true)
                            }
                        }
                    } catch {
                        print("Error: \(error)")
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    func didTapCancellationBtn(_ userId: Int, _ userName: String) {
        let customPopupVC = CancellationPopupVC()
        customPopupVC.modalPresentationStyle = .overFullScreen
        customPopupVC.userId = userId
        customPopupVC.isCancellation = true
        customPopupVC.updateText("\(userName)을(를) 강제 퇴장할까요?", "\(SelectedPetId.petName)의 케어 멤버에서 해당 멤버를 퇴장시켜요.", "강제 퇴장시키기", "취소")
        delegate?.presentViewContoller(customPopupVC, animated: true)
    }
    func didTapDelegationBtn(_ userId: Int, _ userName: String) {
        let customPopupVC = CancellationPopupVC()
        customPopupVC.modalPresentationStyle = .overFullScreen
        customPopupVC.userId = userId
        customPopupVC.isCancellation = false
        customPopupVC.updateText("\(userName)님에게 관리자를 위임할까요?", "관리자 권한을 넘기면\n 본인은 \(SelectedPetId.petName)의 케어 멤버로 전환돼요.", "관리자 위임하기", "취소")
        delegate?.presentViewContoller(customPopupVC, animated: true)
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
        cell.userDataView.userid = managerList[indexPath.row].id
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
        cell.userDataView.profileUserName.text = inviteManagerList[indexPath.row].member.name
        cell.userDataView.profileUserId.text = "@" + inviteManagerList[indexPath.row].member.uid
        cell.selectionStyle = .none
        return cell
    }
    
    func updateInviteManagerData(with newData: [InviteManager]) {
        self.inviteManagerList = newData
    }
    
    func cancelButtonTapped(at indexPath: IndexPath) {
          
        AuthorizationAlamofire.shared.deleteInviteMember(SelectedPetId.petId, inviteManagerList[indexPath.row].invitation.invitationId) { result in
              switch result {
              case .success(let data):
                  if let responseData = data,
                     let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                      print("response jsonData: \(jsonObject)")
                      NotificationCenter.default.post(name: .inviteManagerDataUpdated, object: nil)
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
