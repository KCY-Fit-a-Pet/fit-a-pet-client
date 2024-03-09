
import UIKit
import SnapKit
import SwiftUI

class ManagerDelegationVC: CustomNavigationBar{

    private let titleLabel = UILabel()
    private let memberTableView = UITableView()
    private let cancellationBtn = CustomNextBtn(title: "탈퇴하기")
    private let managerList = PetManagersManager.subManagers
    private var selectedUserId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        initView()
        
        memberTableView.delegate = self
        memberTableView.dataSource = self
        memberTableView.register(ManagerDelegationTableViewCell.self, forCellReuseIdentifier: "ManagerDelegationTableViewCell")
        cancellationBtn.addTarget(self, action: #selector(cancellationBtnTapped), for: .touchUpInside)
    }
    func initView(){
        view.addSubview(titleLabel)
        view.addSubview(memberTableView)
        view.addSubview(cancellationBtn)
        
        titleLabel.text = "멤버"
        titleLabel.font = .boldSystemFont(ofSize: 16)
        cancellationBtn.backgroundColor = UIColor(named: "Danger")
        memberTableView.separatorStyle = .none
        
        titleLabel.snp.makeConstraints{make in
            make.height.equalTo(24)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        memberTableView.snp.makeConstraints{make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(cancellationBtn.snp.top).offset(-10)
        }
        
        cancellationBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    @objc func cancellationBtnTapped(){
        AuthorizationAlamofire.shared.managerDelegation(SelectedPetId.petId, selectedUserId){ result in
            switch result {
            case .success(let data):
                if let responseData = data,
                   let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                    print("response jsonData: \(jsonObject)")
                    AuthorizationAlamofire.shared.cancellationManager(SelectedPetId.petId, UserDefaults.standard.integer(forKey: "id")){ result in
                        switch result {
                        case .success(let data):
                            if let responseData = data,
                               let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                                print("response jsonData: \(jsonObject)")
                                NotificationCenter.default.post(name: .managerCancellationBtnTapped, object: nil)
                            }
                            
                        case .failure(let error):
                            print("Error: \(error)")
                        }
                    }
                }
                
            case .failure(let error):
                print("Error: \(error)")
            }
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
            selectedUserId = managerList[indexPath.row].id
            cell.radioButton.isSelected = true
            cell.radioButton.backgroundColor = UIColor(named: "Danger")
        }
    }
}
