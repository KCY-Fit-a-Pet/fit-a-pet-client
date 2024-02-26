
import Foundation
import UIKit

class InviteMemberVC: UIViewController{
    private let searchMemberTextField =  CustomSearchTextField()
    private let searchButton = CustomNextBtn(title: "멤버 찾기")
    private var inputId = ""
    private var searchId = 0
    
    private let searchDataView = UIView()
    private let userDataView = UserDataView()
    private let inviteToggleBtn = UIButton()
    private var isToggled = false

    private let noSearchData = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setupNavigationBar()
        setupTapGesture()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        inviteToggleBtn.addTarget(self, action: #selector(inviteToggleBtnTapped), for: .touchUpInside)
        searchMemberTextField.delegate = self
    }
    
    func initView(){
        view.backgroundColor = .white
        view.addSubview(searchMemberTextField)
        view.addSubview(searchDataView)
        view.addSubview(noSearchData)
        view.addSubview(searchButton)
        
        searchDataView.addSubview(userDataView)
        searchDataView.addSubview(inviteToggleBtn)
        
        searchDataView.isHidden = true
        noSearchData.isHidden = true
        
        searchMemberTextField.placeholderText = "아이디를 정확하게 입력해주세요"
        
        searchMemberTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
        
        searchDataView.snp.makeConstraints{make in
            make.top.equalTo(searchMemberTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(76)
        }
        
        userDataView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(76)
        }
        
        inviteToggleBtn.setTitle("초대 하기", for: .normal)
        inviteToggleBtn.setTitleColor(UIColor(named: "PrimaryColor"), for: .normal)
        inviteToggleBtn.layer.borderWidth = 1
        inviteToggleBtn.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        inviteToggleBtn.layer.cornerRadius = 8
        inviteToggleBtn.backgroundColor = .white
        inviteToggleBtn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        inviteToggleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        inviteToggleBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(84)
        }
        
        noSearchData.numberOfLines = 2
        noSearchData.text = "유저를 찾지 못했어요.\n아이디를 다시 한 번 확인해주세요."
        noSearchData.textAlignment = .center
        noSearchData.font = .systemFont(ofSize: 14, weight: .medium)
        noSearchData.textColor = UIColor(named: "Gray4")
    
        noSearchData.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.top.equalTo(searchMemberTextField.snp.bottom).offset(50)
            make.height.equalTo(45)
        }

        searchButton.snp.makeConstraints{make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    private func setupNavigationBar() {
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = " "
        
        let titleLabel = UILabel()
        let closeBtn = UIButton()
        
        titleLabel.text = "케어 멤버 초대하기"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: titleLabel.frame.width, height: titleLabel.frame.height))
        titleView.addSubview(titleLabel)
        
        navigationItem.titleView = titleView
        
        closeBtn.setImage(UIImage(named: "close_icon"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeBtn)
    }
    
    @objc func searchButtonTapped(){
        AuthorizationAlamofire.shared.searchUserProfile(inputId) { result in
            switch result {
            case .success(let data):
                if let responseData = data {
                    let object = try?JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary
                    guard let jsonObject = object else {return}
                    let status = jsonObject["status"] as? String
                    if status == "success" {
                        
                        if let data = jsonObject["data"] as? [String: Any] {
                            if let member = data["member"] as? [String: Any] {
                                if let id = member["id"] as? Int {
                                    print("Member ID: \(id)")
                                    self.searchId = id
                                }
                                if let uid = member["uid"] as? String {
                                    self.userDataView.profileUserId.text = "@" + uid
                                }
                                if let name = member["name"] as? String {
                                    self.userDataView.profileUserName.text = name
                                }
                                if let profileImageUrl = member["profileImageUrl"] as? String {
                                    
                                }
                            }
                        }
                        
                        self.searchDataView.isHidden = false
                        self.noSearchData.isHidden = true
                        
                    }else{
                        self.searchDataView.isHidden = true
                        self.noSearchData.isHidden = false
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    @objc func inviteToggleBtnTapped(){
        isToggled.toggle()
        
        if isToggled{
            inviteToggleBtn.setTitle("취소", for: .normal)
            inviteToggleBtn.setTitleColor(UIColor(named: "Danger"), for: .normal)
            inviteToggleBtn.layer.borderColor = UIColor(named: "Danger")?.cgColor
            
            AuthorizationAlamofire.shared.inviteMember(SelectedPetId.petId, searchId) {result in
                switch result {
                case .success(let data):
                    if let responseData = data,
                       let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                        print("response jsonData: \(jsonObject)")
                    }
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }else{
            inviteToggleBtn.setTitle("초대 하기", for: .normal)
            inviteToggleBtn.setTitleColor(UIColor(named: "PrimaryColor"), for: .normal)
            inviteToggleBtn.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
            
            AuthorizationAlamofire.shared.deleteInviteMember(SelectedPetId.petId, String(searchId)) {result in
                switch result {
                case .success(let data):
                    if let responseData = data,
                       let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                        print("response jsonData: \(jsonObject)")
                    }
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
        
    }
    
    @objc private func closeBtnTapped() {
        self.dismiss(animated: true)
    }
}

extension InviteMemberVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let updatedText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        searchButton.updateButtonColor(updatedText, false)
    
        return true
    }
    func textFieldDidEndEditing(_ textView: UITextField) {
        
        if let text = textView.text {
            inputId = text
            print("Entered Text: \(text)")
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension InviteMemberVC {
    @objc private func keyboardWillShow(notification: Notification) {
            guard let userInfo = notification.userInfo,
                  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            
            let keyboardHeight = keyboardFrame.height
            let offsetData = keyboardHeight

            self.searchButton.snp.updateConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-(offsetData-20))
            }
        }
    
    @objc private func keyboardWillHide(notification: Notification) {
        
        self.searchButton.snp.updateConstraints { make in
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

