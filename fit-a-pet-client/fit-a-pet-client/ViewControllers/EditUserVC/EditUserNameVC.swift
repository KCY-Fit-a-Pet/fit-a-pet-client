import UIKit
import SnapKit

class EditUserNameVC: CustomNavigationBar {

    private var currentUserNameTextField = UITextField()
    private let editButton = CustomNextBtn(title: "이름 변경하기")
    private let beforeNameLabel = UILabel()
    var division = ""
    var beforeUserName = ""
    var selectedId = 0
    private var userName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
        initView()
        divisionName()

        self.view.backgroundColor = .white

        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        currentUserNameTextField.delegate = self
    }
    
    func initView(){
        currentUserNameTextField.placeholder = beforeUserName
        currentUserNameTextField.layer.borderWidth = 1
        currentUserNameTextField.layer.cornerRadius = 5
        currentUserNameTextField.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        currentUserNameTextField.font = .systemFont(ofSize:14)
        
        currentUserNameTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        currentUserNameTextField.leftViewMode = .always
        
        view.addSubview(currentUserNameTextField)
        view.addSubview(editButton)
        view.addSubview(beforeNameLabel)
        
        currentUserNameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
        
        beforeNameLabel.snp.makeConstraints{make in
            make.top.equalTo(currentUserNameTextField.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(24)
        }
        
        editButton.snp.makeConstraints{make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func divisionName(){
        beforeNameLabel.font = .systemFont(ofSize: 12, weight: .regular)
        if division == "me"{
            beforeNameLabel.text = "이전에 설정한 이름: " + beforeUserName
        }else{
            beforeNameLabel.text = "멤버가 설정한 이름 : " + beforeUserName
        }
    }

    
    @objc private func editButtonTapped(){
        
        if division == "me" {
            AuthorizationAlamofire.shared.editUserName("name", userName){ [self]
                result in
                switch result {
                case .success(let data):
                    if let responseData = data {
                        let object = try?JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary
                        guard let jsonObject = object else {return}
                        print("respose jsonData: \(jsonObject)")
                        UserDefaults.standard.set(userName, forKey: "name")
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }else{
            AuthorizationAlamofire.shared.editSomeoneNickname(selectedId, userName){ [self]
                result in
                switch result {
                case .success(let data):
                    if let responseData = data {
                        let object = try?JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary
                        guard let jsonObject = object else {return}
                        print("respose jsonData: \(jsonObject)")
                        NotificationCenter.default.post(name: .ManagerDelegationBtnTapped, object: nil)
                        self.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }  
    }
}


extension EditUserNameVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let updatedText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        editButton.updateButtonColor(updatedText, false)
        
        if updatedText.isEmpty{
            currentUserNameTextField.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        }else{
            currentUserNameTextField.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        }

        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let text = textField.text {
            userName = text
            print("Entered Text: \(text)")
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditUserNameVC {
    @objc private func keyboardWillShow(notification: Notification) {
            guard let userInfo = notification.userInfo,
                  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            
            let keyboardHeight = keyboardFrame.height
            let offsetData = keyboardHeight

            self.editButton.snp.updateConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-(offsetData-20))
            }
        }
    
    @objc private func keyboardWillHide(notification: Notification) {
        
        self.editButton.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
