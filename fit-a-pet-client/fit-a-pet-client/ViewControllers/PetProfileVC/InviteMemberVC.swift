
import Foundation
import UIKit

class InviteMemberVC: UIViewController{
    private let searchMemberTextField =  CustomSearchTextField()
    private let searchButton = CustomNextBtn(title: "멤버 찾기")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setupNavigationBar()
        setupTapGesture()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        searchMemberTextField.delegate = self
    }
    
    func initView(){
        view.backgroundColor = .white
        view.addSubview(searchMemberTextField)
        view.addSubview(searchButton)
        searchMemberTextField.placeholderText = "아이디를 정확하게 입력해주세요"
        
        searchMemberTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
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

