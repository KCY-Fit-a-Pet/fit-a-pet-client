

import UIKit
import SnapKit
import SwiftUI

class MemberManagementVC: UIViewController, MemberListTableViewMethodDelegate{
    
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
        memberView.memberTableView.dataSource = memberMethod
        memberView.memberTableView.delegate = memberMethod
        
        inviteWaitingView.inviteMemberTableView.dataSource = inviteMemberMethod
        inviteWaitingView.inviteMemberTableView.delegate = inviteMemberMethod
        
        memberView.memberInviteBtn.addTarget(self, action: #selector(inviteButtonTapped), for: .touchUpInside)
        
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
}


// MARK: - Preview

struct MainViewController_Previews: PreviewProvider {
  static var previews: some View {
    Container().edgesIgnoringSafeArea(.all)
  }
  
  struct Container: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
      let rootViewController = MemberManagementVC()
      return UINavigationController(rootViewController: rootViewController)
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    typealias UIViewControllerType = UIViewController
  }
}
