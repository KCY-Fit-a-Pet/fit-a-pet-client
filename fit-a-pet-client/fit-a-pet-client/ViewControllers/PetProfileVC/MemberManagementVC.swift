

import UIKit
import SnapKit

class MemberManagementVC: UIViewController, MemberListTableViewMethodDelegate, ManagerViewDelegate{
    
    private let layoutView = UIView()
    private let managerView = ManagerView()
    private let containerView = UIView()
    private let memberView = MemberView()
    private let inviteWaitingView = InviteWaitingView()
    
    private let memberMethod = MemberListTableViewMethod()
    private let inviteMemberMethod = MemberInviteListTableViewMethod()
    
    private let heightForRow: CGFloat = 76
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        memberMethod.delegate = self
        managerView.delegate = self
        memberView.memberTableView.dataSource = memberMethod
        memberView.memberTableView.delegate = memberMethod
        
        inviteWaitingView.inviteMemberTableView.dataSource = inviteMemberMethod
        inviteWaitingView.inviteMemberTableView.delegate = inviteMemberMethod
        
        memberView.memberInviteBtn.addTarget(self, action: #selector(inviteButtonTapped), for: .touchUpInside)
        
        petManagersListAPI()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateMemberViewHeight()
    }
    
    func initView(){
        view.backgroundColor = .white
        
        layoutView.backgroundColor = UIColor(named: "Gray0")
        containerView.backgroundColor = .white

        view.addSubview(layoutView)
        layoutView.addSubview(managerView)
        layoutView.addSubview(containerView)
        containerView.addSubview(memberView)
        containerView.addSubview(inviteWaitingView)
        
        memberView.backgroundColor = .white
     
        layoutView.snp.makeConstraints{make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        managerView.snp.makeConstraints { make in
            make.height.equalTo(140)
            make.top.equalTo(layoutView.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        containerView.snp.makeConstraints{make in
            make.top.equalTo(managerView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        memberView.snp.makeConstraints{make in
            make.height.equalTo(0)
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview()
        }
        
        inviteWaitingView.snp.makeConstraints{make in
            make.bottom.equalToSuperview()
            make.top.equalTo(memberView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func updateMemberViewHeight() {
        let totalCellHeight = CGFloat(memberView.memberTableView.numberOfRows(inSection: 0)) * heightForRow
        
        memberView.snp.updateConstraints { make in
            make.height.equalTo(totalCellHeight + 62)
        }
    }
    
    @objc func inviteButtonTapped(){
        
        let nextVC = InviteMemberVC()
        
         let navigationController = UINavigationController(rootViewController: nextVC)
        self.present(navigationController, animated: true)
    }
    
    func didTapChangeName() {
        let nextVC = EditUserNameVC(title: "이름 변경하기")
        self.pushViewController(nextVC, animated: true)
    }
    
    func petManagersListAPI(){
        AuthorizationAlamofire.shared.petManagersList(SelectedPetId.petId) { result in
            switch result {
            case .success(let data):
                if let responseData = data,
                   let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                   let status = jsonObject["status"] as? String,
                   status == "success",
                   let data = jsonObject["data"] as? [String: Any],
                   let managersArray = data["managers"] as? [[String: Any]] {
                    
                    let managerList = petManagersManager()
                    petManagersManager.subManagers.removeAll()
                    
                    for managerData in managersArray {
                        if let id = managerData["id"] as? Int,
                           let uid = managerData["uid"] as? String,
                           let name = managerData["name"] as? String,
                           let profileImageUrl = managerData["profileImageUrl"] as? String,
                           let isMaster = managerData["isMaster"] as? Bool {
                            let manager = Manager(id: id, uid: uid, name: name, profileImageUrl: profileImageUrl, isMaster: isMaster)
                            managerList.addManager(manager: manager)
                        }
                    }
                    self.managerView.userDataView.profileUserName.text =  petManagersManager.masterManager?.name
                    self.managerView.userDataView.profileUserId.text = "@" + petManagersManager.masterManager!.uid
                   
                }
                
                self.memberMethod.updatePetManagerData(with: petManagersManager.subManagers)
                self.memberView.memberTableView.reloadData()
                if UserDefaults.standard.string(forKey: "uid") != petManagersManager.masterManager?.uid{
                    self.managerView.menuButton.isHidden = false
                }
   
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
