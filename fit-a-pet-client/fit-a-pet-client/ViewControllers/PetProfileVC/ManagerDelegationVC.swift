
import UIKit
import SnapKit
import SwiftUI

class ManagerDelegationVC: CustomNavigationBar{

    private let titleLabel = UILabel()
    private let memberTableView = UITableView()
    private let withdrawalBtn = CustomNextBtn(title: "탈퇴하기")
    private let managerList = PetManagersManager.subManagers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        initView()
        
        memberTableView.delegate = self
        memberTableView.dataSource = self
        memberTableView.register(ManagerDelegationTableViewCell.self, forCellReuseIdentifier: "ManagerDelegationTableViewCell")
    }
    func initView(){
        view.addSubview(titleLabel)
        view.addSubview(memberTableView)
        view.addSubview(withdrawalBtn)
        
        titleLabel.text = "멤버"
        titleLabel.font = .boldSystemFont(ofSize: 16)
        withdrawalBtn.backgroundColor = UIColor(named: "Danger")
        memberTableView.separatorStyle = .none
        
        titleLabel.snp.makeConstraints{make in
            make.height.equalTo(24)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        memberTableView.snp.makeConstraints{make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(withdrawalBtn.snp.top).offset(-10)
        }
        
        withdrawalBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
}
extension ManagerDelegationVC: UITableViewDelegate, UITableViewDataSource{
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return managerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManagerDelegationTableViewCell", for: indexPath) as! ManagerDelegationTableViewCell
        
        cell.userDataView.profileUserName.text = managerList[indexPath.row].name
        cell.userDataView.profileUserId.text = "@" + managerList[indexPath.row].uid
        cell.radioButton.isSelected = false
        cell.selectionStyle = .none
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 76
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for visibleCell in tableView.visibleCells {
            if let cell = visibleCell as? ManagerDelegationTableViewCell {
                cell.radioButton.isSelected = false
                cell.radioButton.backgroundColor = .white
            }
        }
        if let cell = tableView.cellForRow(at: indexPath) as? ManagerDelegationTableViewCell {
            cell.radioButton.isSelected = true
            cell.radioButton.backgroundColor = UIColor(named: "Danger")
        }
    }
}

// MARK: - Preview

struct MainViewController_Previews: PreviewProvider {
  static var previews: some View {
    Container().edgesIgnoringSafeArea(.all)
  }
  
  struct Container: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let rootViewController = ManagerDelegationVC(title: "관리자 위임")
      return UINavigationController(rootViewController: rootViewController)
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    typealias UIViewControllerType = UIViewController
  }
}
