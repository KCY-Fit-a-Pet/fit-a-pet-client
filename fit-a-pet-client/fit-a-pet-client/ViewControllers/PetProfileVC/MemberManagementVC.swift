

import UIKit
import SnapKit
import SwiftUI

class MemberManagementVC: UIViewController{
    
    private let layoutView = UIView()
    private let managerView = ManagerView()
    private let memberView = MemberView()
    private var userDataArray: [String] = ["User 1", "User 2", "User 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        memberView.memberTableView.dataSource = self
        memberView.memberTableView.delegate = self
    }
    
    func initView(){
        view.backgroundColor = .white
        
        layoutView.backgroundColor = UIColor(named: "Gray0")

        view.addSubview(layoutView)
        layoutView.addSubview(managerView)
        layoutView.addSubview(memberView)
        
        memberView.backgroundColor = .white
     
        layoutView.snp.makeConstraints{make in
            make.top.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        managerView.snp.makeConstraints { make in
            make.height.equalTo(140)
            make.top.equalTo(layoutView.snp.top)
            make.leading.trailing.equalToSuperview()
        }

        memberView.snp.makeConstraints{make in
            make.bottom.equalToSuperview()
            make.top.equalTo(managerView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        
    }
    
}


extension MemberManagementVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberTableViewCell", for: indexPath) as! MemberTableViewCell
        cell.userDataView.profileUserName.text = userDataArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
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
