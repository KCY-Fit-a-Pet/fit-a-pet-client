import UIKit
import SnapKit

class ResetPwVC: CustomNavigationBar{
    
    private let resetPwCompleteBtn = CustomNextBtn(title: "비밀번호 재설정")
    private var titleStackView = UIStackView()
    private let titleLabel = UILabel()
    private let inputPw = UITextField()
    private let inputPwCheck = UITextField()
    
    private var newPw = ""
    private var newPwCheck = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.view.backgroundColor = .white
        initView()
        resetPwCompleteBtn.addTarget(self, action: #selector(resetPwCompleteBtnTapped(_ :)), for: .touchUpInside)
    }
    
    private func initView(){
        
        setTitleStackView()
        
        self.view.addSubview(inputPw)
        self.view.addSubview(inputPwCheck)
        self.view.addSubview(resetPwCompleteBtn)
       
        //inputPw.delegate = self
        inputPw.layer.borderWidth = 1
        inputPw.layer.cornerRadius = 5
        inputPw.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        inputPw.placeholder = "영어 소문자, 숫자 조합 8자리 이상"
        inputPw.font = .systemFont(ofSize:14)
        
        //textfield padding 주기
        inputPw.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        inputPw.leftViewMode = .always
        
        inputPw.delegate = self
        
        inputPw.snp.makeConstraints{make in
            make.height.equalTo(55)
            make.top.equalTo(view.snp.top).offset(255)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
        //inputPwCheck.delegate = self
        inputPwCheck.layer.borderWidth = 1
        inputPwCheck.layer.cornerRadius = 5
        inputPwCheck.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        inputPwCheck.placeholder = "비밀번호 확인"
        inputPwCheck.font = .systemFont(ofSize:14)
        
        //textfield padding 주기
        inputPwCheck.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        inputPwCheck.leftViewMode = .always
        
        inputPwCheck.delegate = self
        
        inputPwCheck.snp.makeConstraints{make in
            make.height.equalTo(55)
            make.top.equalTo(inputPw.snp.bottom).offset(8)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
    
        resetPwCompleteBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
    }
    
    private func setTitleStackView(){
        let titleLabel = UILabel()
        titleLabel.text = "비밀번호 재설정"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "새로운 비밀번호를 입력해주세요."
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.numberOfLines = 2
        subtitleLabel.textAlignment = .center
        
        titleStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        titleStackView.axis = .vertical
        titleStackView.spacing = 12
        
        self.view.addSubview(titleStackView)
        
        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(150)
            make.centerX.equalToSuperview()
        }
    }

    @objc func resetPwCompleteBtnTapped(_ sender: UIButton){
        
        if newPw == newPwCheck{
            
            AlamofireManager.shared.findPw(FindIdPwSwitch.phoneNum, newPwCheck, FindIdPwSwitch.code){
                result in
                switch result {
                case .success(let data):
                    // Handle success
                    if let responseData = data {
                        let object = try?JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary
                        if let status = object?["status"] as? String {
                            print("status: \(status)")
                            
                            if status == "success" {
                                if let loginVC = self.navigationController?.viewControllers.first(where: { $0 is LoginVC }) {
                                    self.navigationController?.popToViewController(loginVC, animated: true)
                                }
                            }
                        }
                    }
                case .failure(let error):
                    // Handle failure
                    print("Error: \(error)")
                }
            }
        }else{
            
            let customPopupVC = CustomPopupViewController()
            customPopupVC.modalPresentationStyle = .overFullScreen
            customPopupVC.messageText = "새 비밀번호와 비밀번호 확인이\n 일치하지 않습니다."
            self.present(customPopupVC, animated: false, completion: nil)
        }
       
    }
    
}

extension ResetPwVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == inputPwCheck {
            //inputPw에 text 값이 있어야만 inputPwText에 입력할 수 있다.
            if let inputPwText = inputPw.text, !inputPwText.isEmpty {
                let updatedText = (inputPwCheck.text! as NSString).replacingCharacters(in: range, with: string)
                
                newPw = inputPw.text!
                newPwCheck = updatedText
                resetPwCompleteBtn.updateButtonColor(updatedText, false)
                
                if updatedText.isEmpty{
                    inputPwCheck.layer.borderColor = UIColor(named: "Gray3")?.cgColor
                }else{
                    inputPwCheck.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
                }
                return true
                
            } else {
                return false
            }
            
        } else{
            let updatedText = (inputPw.text! as NSString).replacingCharacters(in: range, with: string)
            
            if updatedText.isEmpty {
                inputPw.layer.borderColor = UIColor(named: "Gray3")?.cgColor
                
            } else {
                inputPw.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
            }
        }
        return true
    }
}

