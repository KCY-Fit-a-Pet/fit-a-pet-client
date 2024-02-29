

import UIKit
import SnapKit

class MemberManagementVC: UIViewController, MemberListTableViewMethodDelegate, ManagerViewDelegate{
    
    private var titleLabel = UILabel()
    private let layoutView = UIScrollView()
    private let managerView = ManagerView()
    private let containerView = UIView()
    private let memberView = MemberView()
    private let inviteWaitingView = InviteWaitingView()
    private let cancellationBtn = UIButton()
    
    private let memberMethod = MemberListTableViewMethod()
    private let inviteMemberMethod = MemberInviteListTableViewMethod()
    
    private let heightForRow: CGFloat = 76
    private var isManager = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setupNavigationBar()
        
        memberMethod.delegate = self
        managerView.delegate = self
        memberView.memberTableView.dataSource = memberMethod
        memberView.memberTableView.delegate = memberMethod
        
        inviteWaitingView.inviteMemberTableView.dataSource = inviteMemberMethod
        inviteWaitingView.inviteMemberTableView.delegate = inviteMemberMethod
        
        memberView.memberInviteBtn.addTarget(self, action: #selector(inviteButtonTapped), for: .touchUpInside)
        cancellationBtn.addTarget(self, action: #selector(cancellationBtnTapped), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(handleInviteManagerDataUpdated), name: .InviteManagerDataUpdated, object: nil)

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
        
        cancellationBtn.setTitle("탈퇴하기", for: .normal)
        cancellationBtn.setTitleColor(UIColor(named: "Danger"), for: .normal)
        cancellationBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        view.addSubview(layoutView)
        layoutView.addSubview(managerView)
        layoutView.addSubview(containerView)
        layoutView.addSubview(cancellationBtn)
        containerView.addSubview(memberView)
        containerView.addSubview(inviteWaitingView)
        
        memberView.backgroundColor = .white
        
        layoutView.snp.makeConstraints{make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.leading.trailing.equalTo(view)
        }
        managerView.snp.makeConstraints { make in
            make.height.equalTo(140)
            make.top.equalTo(layoutView.snp.top)
            make.leading.trailing.equalTo(view)
        }
        
        containerView.snp.makeConstraints{make in
            make.top.equalTo(managerView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        memberView.snp.makeConstraints{make in
            make.height.equalTo(0)
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalTo(view)
        }
        
        inviteWaitingView.snp.makeConstraints{make in
            make.bottom.equalToSuperview()
            make.top.equalTo(memberView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view)
        }
        
        cancellationBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalTo(view).inset(16)
        }
    }
    
    func setupNavigationBar(){
        titleLabel = UILabel()
        titleLabel.text = "\(SelectedPetId.petName) 멤버"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        titleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: titleLabel.frame.width, height: titleLabel.frame.height))
        titleView.addSubview(titleLabel)
        
        self.navigationItem.titleView = titleView
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func presentViewContoller(_ viewController: UIViewController, animated: Bool) {
        self.present(viewController, animated: true, completion: nil)
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
    
    @objc func handleInviteManagerDataUpdated() {
        inviteMemberListAPI()
    }
    
    @objc func cancellationBtnTapped(){
        
        if isManager{
            let nextVC = ManagerDelegationVC(title: "관리자 위임")
            self.pushViewController(nextVC, animated: true)
        }else{
            let customPopupVC = CancellationPopupVC()
            customPopupVC.modalPresentationStyle = .overFullScreen
            customPopupVC.updateText("\(SelectedPetId.petName)의 관리 멤버에서 탈퇴할까요?", "더 이상 \(SelectedPetId.petName)를 케어 및 관리하지 안하요. ", "탈퇴하기", "취소")
            self.present(customPopupVC, animated: true, completion: nil)
        }
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
                    
                    let managerList = PetManagersManager()
                    PetManagersManager.subManagers.removeAll()
                    
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
                    self.managerView.userDataView.profileUserName.text =  PetManagersManager.masterManager?.name
                    self.managerView.userDataView.profileUserId.text = "@" + PetManagersManager.masterManager!.uid
                   
                }
                
                self.memberMethod.updatePetManagerData(with: PetManagersManager.subManagers)
                self.memberView.memberTableView.reloadData()
                if UserDefaults.standard.string(forKey: "uid") == PetManagersManager.masterManager?.uid{
                    self.isManager = true
                    self.managerView.menuButton.isHidden = true
                    self.cancellationBtn.setTitle("관리자 위임 후 탈퇴하기", for: .normal)
                }
   
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
        inviteMemberListAPI()
       
    }
    func inviteMemberListAPI(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        AuthorizationAlamofire.shared.inviteMemberList(SelectedPetId.petId) { result in
            switch result {
            case .success(let data):
                if let responseData = data,
                   let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                   let status = jsonObject["status"] as? String, status == "success",
                   let data = jsonObject["data"] as? [String: Any],
                   let membersData = data["members"] as? [[String: Any]] {
                    let managerList = PetManagersManager()
                    PetManagersManager.inviteManagers.removeAll()
                    for memberData in membersData {
                        if let id = memberData["id"] as? Int,
                           let uid = memberData["uid"] as? String,
                           let name = memberData["name"] as? String,
                           let expired = memberData["expired"] as? Bool,
                           let invitedAtString = memberData["invitedAt"] as? String,
                           let invitedAt = dateFormatter.date(from: invitedAtString) {
                            
                            let inviteManager = InviteManager(id: id, uid: uid, name: name, profileImageUrl: "", isMaster: false, expired: expired, invitedAt: invitedAt)
                            managerList.addInviteManager(inviteManager: inviteManager)
                        }
                    }
                }
                
                self.inviteMemberMethod.updateInviteManagerData(with: PetManagersManager.inviteManagers)
                self.inviteWaitingView.inviteMemberTableView.reloadData()
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
