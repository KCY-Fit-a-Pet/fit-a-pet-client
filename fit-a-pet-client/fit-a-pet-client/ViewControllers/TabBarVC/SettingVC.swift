import UIKit
import SnapKit
import SwiftUI

class SettingVC: UIViewController {
    
    let profileView = UIView()
    let profileImageView = UIImageView()
    let profileUserName = UILabel()
    let profilUserNameEditBtn = UIButton()
    let profileUserId = UILabel()
    
    let setScrollView = UIScrollView()
    
    let myInfoTableView = UITableView()
    let alarmSegmentTableView = UITableView()
    
    // Data
    let myInfoCellData: [MyInfo] = MyInfo.cellList
    let alarmCellData: [AlarmSegment] = AlarmSegment.cellList
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "Gray0")
        
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        profileUserName.text = UserDefaults.standard.string(forKey: "name")!
        
        if let allValues = UserDefaults.standard.dictionaryRepresentation() as? [String: Any] {
            print("All Values in UserDefaults:")
            for (key, value) in allValues {
                print("\(key): \(value)")
            }
        } else {
            print("Unable to retrieve all values from UserDefaults")
        }
    }
    
    private func initView() {

        configureProfileView()
        configureTableViewScrollView()
        configureNavigationBar()
        
    }
    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        let leftBarButtonItem = UIBarButtonItem(title: "설정", style: .plain, target: nil, action: nil)
        leftBarButtonItem.tintColor = .black

        if let font = UIFont(name: "Helvetica-Bold", size: 18) {
            leftBarButtonItem.setTitleTextAttributes([.font: font], for: .normal)
        }
    
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    private func configureProfileView() {
        profilUserNameEditBtn.setImage(UIImage(named: "userNameEdit"), for: .normal)
        profilUserNameEditBtn.addTarget(self, action: #selector(changeEditUserNameVC(_:)), for: .touchUpInside)
        
        profileUserId.text = "@\(UserDefaults.standard.string(forKey: "uid")!)"
        profileUserId.font = .systemFont(ofSize: 14)
        profileUserName.text = UserDefaults.standard.string(forKey: "name")!
        profileUserName.font = .boldSystemFont(ofSize: 16)
        
        profileView.backgroundColor = .white
        
        let userNameStackView = UIStackView(arrangedSubviews: [profileUserName, profilUserNameEditBtn])
        userNameStackView.axis = .horizontal
        userNameStackView.spacing = 4
        
        
        profileView.addSubview(profileImageView)
        profileView.addSubview(userNameStackView)
        profileView.addSubview(profileUserId)
        setScrollView.addSubview(profileView)
        view.addSubview(setScrollView)
        
        profileImageView.image = UIImage(named: "profileImage")
        
        setScrollView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        profileView.snp.makeConstraints { make in
            make.height.equalTo(124)
            make.top.equalTo(setScrollView.snp.top).offset(10)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        profileUserId.snp.makeConstraints { make in
            make.top.equalTo(userNameStackView.snp.bottom).offset(4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
        
        userNameStackView.snp.makeConstraints{make in
            make.top.equalTo(profileView.snp.top).offset(40)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.top).offset(12)
            make.leading.equalTo(profileView).offset(18)
            make.width.height.equalTo(100)
        }
    }
    
    private func configureTableViewScrollView() {
        myInfoTableView.dataSource = self
        myInfoTableView.delegate = self
        myInfoTableView.isScrollEnabled = false
        myInfoTableView.register(MyInfoTableViewCell.self, forCellReuseIdentifier: "MyInfoTableViewCell")

        alarmSegmentTableView.dataSource = self
        alarmSegmentTableView.delegate = self
        alarmSegmentTableView.isScrollEnabled = false
        alarmSegmentTableView.register(AlarmTableViewCell.self, forCellReuseIdentifier: "AlarmTableViewCell")

        setScrollView.addSubview(myInfoTableView)
        setScrollView.addSubview(alarmSegmentTableView)

        myInfoTableView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(8)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(270)
        }
        alarmSegmentTableView.snp.makeConstraints { make in
            make.top.equalTo(myInfoTableView.snp.bottom).offset(8)
            make.bottom.equalTo(setScrollView.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(230)
        }
    }
    @objc func changeEditUserNameVC(_ sender: UIButton){
        let nextVC = EditUserNameVC(title: "이름 변경하기")
        nextVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
}

extension SettingVC: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableView == myInfoTableView ? "내정보" : "알림"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == myInfoTableView ? myInfoCellData.count : alarmCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == myInfoTableView {
            let myInfoCell = myInfoTableView.dequeueReusableCell(withIdentifier: "MyInfoTableViewCell", for: indexPath) as! MyInfoTableViewCell
            let myInfocellData = myInfoCellData[indexPath.row]
            myInfoCell.configure(myInfocellData.cellTitle, myInfocellData.userData)
            return myInfoCell
            
        } else {
            let alarmCell = alarmSegmentTableView.dequeueReusableCell(withIdentifier: "AlarmTableViewCell", for: indexPath) as! AlarmTableViewCell
            let alarmCellData = alarmCellData[indexPath.row]
            alarmCell.configure(alarmCellData.cellTitle, alarmCellData.cellSubTitie, indexPath.row)
            alarmCell.configureSegmentControl(alarmCellData.alarmToggle)
            return alarmCell
        }
    }
}

extension SettingVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView == myInfoTableView ? 52 : 56
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == myInfoTableView {
            if indexPath.row == 2 {
                let nextVC = EditUserPwVC(title: "비밀번호 변경")
                nextVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(nextVC, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


struct MainViewController_Previews: PreviewProvider {
  static var previews: some View {
    Container().edgesIgnoringSafeArea(.all)
  }
  
  struct Container: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
      let rootViewController = SettingVC()
      return UINavigationController(rootViewController: rootViewController)
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    typealias UIViewControllerType = UIViewController
  }
}
