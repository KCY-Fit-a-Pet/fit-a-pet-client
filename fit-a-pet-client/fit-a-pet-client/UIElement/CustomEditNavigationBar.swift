import UIKit

class CustomEditNavigationBar: UIViewController {
    
    private var titleLabel: UILabel!
    private var cancleButton: UIBarButtonItem!
    var saveButton: UIBarButtonItem!
    
    //data
    private var currentTitle = ""
    var userPwData: [String: String] = [:]
    var userName = ""

    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        setupNavigationBar(title: title)
        currentTitle = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupNavigationBar(title: String) {
        cancleButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
        
        cancleButton.tintColor = UIColor(named: "PrimaryColor")
        saveButton.tintColor = UIColor(named: "Gray3")

        if let font = UIFont(name: "Helvetica-Bold", size: 16) {
            cancleButton.setTitleTextAttributes([.font: font], for: .normal)
            saveButton.setTitleTextAttributes([.font: font], for: .normal)
        }
    
        
        self.navigationItem.leftBarButtonItem = cancleButton
        self.navigationItem.rightBarButtonItem = saveButton

        
        // TitleView
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        titleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: titleLabel.frame.width, height: titleLabel.frame.height))
        titleView.addSubview(titleLabel)
        
        self.navigationItem.titleView = titleView
    }
    
    @objc func cancelButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }

    @objc func saveButtonTapped() {
        
        switch (currentTitle) {
        case "비밀번호 변경":
            return editUserPwAPI()
        case "이름 변경하기":
            return editUserNameAPI()
        default:
            return
        }
    }
}

extension CustomEditNavigationBar{
    func editUserPwAPI(){
        AlamofireManager.shared.editUserPw("password", userPwData["prePassword"]!, userPwData["newPassword"]!){
            result in
            switch result {
            case .success(let data):
                // Handle success
                if let responseData = data {
                    // Process the data
                    let object = try?JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary
                    guard let jsonObject = object else {return}
                    print("respose jsonData: \(jsonObject)")
                    self.navigationController?.popToRootViewController(animated: true)
                }
            case .failure(let error):
                // Handle failure
                print("Error: \(error)")
            }
        }
    }
    
    func editUserNameAPI(){
        AlamofireManager.shared.editUserName("name", userName){ [self]
            result in
            switch result {
            case .success(let data):
                // Handle success
                if let responseData = data {
                    // Process the data
                    let object = try?JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary
                    guard let jsonObject = object else {return}
                    print("respose jsonData: \(jsonObject)")
                    UserDefaults.standard.set(userName, forKey: "name")
                    self.navigationController?.popToRootViewController(animated: true)
                }
            case .failure(let error):
                // Handle failure
                print("Error: \(error)")
            }
        }
    }
}
