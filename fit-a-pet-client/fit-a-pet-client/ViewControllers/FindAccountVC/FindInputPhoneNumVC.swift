import UIKit
import SnapKit


class FindInputPhoneNumVC: CustomNavigationBar{
    
    private let nextInputAuthNumBtn = CustomNextBtn(title: "인증번호 전송")
    private let inputPhoneNum = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.view.backgroundColor = .white
        
        inputPhoneNum.delegate = self
        nextInputAuthNumBtn.addTarget(self, action: #selector(changeFindInputAuthNumVC(_ :)), for: .touchUpInside)
        initView()
    }
    
    private func initView(){
        
        let titleLabel = UILabel()
        titleLabel.text = "본인의 휴대폰 번호를 입력해주세요."
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "회원정보의 전화번호와 일치하여야\n아이디를 확인할 수 있습니다."
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.numberOfLines = 2
        subtitleLabel.textAlignment = .center
        
        let titleStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        titleStackView.axis = .vertical
        titleStackView.spacing = 10
        
        self.view.addSubview(titleStackView)
        self.view.addSubview(inputPhoneNum)
        self.view.addSubview(nextInputAuthNumBtn)
    
        inputPhoneNum.layer.borderWidth = 1
        inputPhoneNum.layer.cornerRadius = 5
        inputPhoneNum.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        inputPhoneNum.placeholder = "010-1234-1234"
        inputPhoneNum.font = .systemFont(ofSize:14)
        
        inputPhoneNum.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        inputPhoneNum.leftViewMode = .always
        
        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(130)
            make.centerX.equalToSuperview()
        }
        
        inputPhoneNum.snp.makeConstraints{make in
            make.height.equalTo(55)
            make.top.equalTo(view.snp.top).offset(245)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
        nextInputAuthNumBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
    }
    @objc func changeFindInputAuthNumVC(_ sender: UIButton){
        let nextVC = FindInputAuthNumVC(title: FindIdPwSwitch.findAuth, phone: FindIdPwSwitch.phoneNum)
        
        AlamofireManager.shared.sendAuthSms(FindIdPwSwitch.phoneNum, FindIdPwSwitch.userUid){
            result in
            switch result {
            case .success(let data):
                
                if let responseData = data {
                    let object = try?JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary
                    guard let jsonObject = object else {return}
                    print("respose jsonData: \(jsonObject)")
                }
                
                self.navigationController?.pushViewController(nextVC, animated: false)
                     
            case .failure(let error):
                print("Error: \(error)")
                
                let customPopupVC = CustomPopupViewController()
                customPopupVC.modalPresentationStyle = .overFullScreen
                customPopupVC.messageText = "해당 전화번호가 사용된\n아이디가 없습니다."
                self.present(customPopupVC, animated: false
                             
                             , completion: nil)
            }
        }
        
    }
    
}

extension FindInputPhoneNumVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = (inputPhoneNum.text! as NSString).replacingCharacters(in: range, with: string)
        nextInputAuthNumBtn.updateButtonColor(updatedText, false)
        
        if updatedText.isEmpty {
            inputPhoneNum.layer.borderColor = UIColor(named: "Gray3w")?.cgColor
        } else {
            inputPhoneNum.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        }
        
        if !updatedText.isEmpty {
            let strippedPhoneNumber = updatedText.replacingOccurrences(of: "-", with: "")
            var formattedText: String = ""
            let hippen: Character = "-"
            
            formattedText = strippedPhoneNumber
            
            if strippedPhoneNumber.count >= 3 && updatedText.count != 4 {
                formattedText.insert(hippen, at: formattedText.index(formattedText.startIndex, offsetBy: 3))
            }
            if strippedPhoneNumber.count >= 7 && updatedText.count != 9 {
                formattedText.insert(hippen, at: formattedText.index(formattedText.startIndex, offsetBy: 8))
            }
            
            if strippedPhoneNumber.count > 11 {
                return false
                
            }else{
                inputPhoneNum.text = formattedText
                FindIdPwSwitch.phoneNum = formattedText.replacingOccurrences(of: "-", with: "")
            }
        }else{
            inputPhoneNum.text = ""
        }
        
        return false
    }
}

