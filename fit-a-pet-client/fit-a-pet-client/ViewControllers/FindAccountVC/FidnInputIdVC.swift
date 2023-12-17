import UIKit
import SnapKit

class FindInputIdVC: CustomNavigationBar{
    
    private let nextInputPhoneNumBtn = CustomNextBtn(title: "아이디 찾기")
    private let findInputId = UITextField()
    private var findIdStackView = UIStackView()
    private let titleLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.view.backgroundColor = .white
        initView()
        nextInputPhoneNumBtn.addTarget(self, action: #selector(changeFindInputPhoneNumVC(_ :)), for: .touchUpInside)
    }
    
    private func initView(){
        
        setFindIdStckView()
        
        titleLabel.text = "찾으려는 아이디를 입력해주세요."
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        
        findInputId.delegate = self
        findInputId.layer.borderWidth = 1
        findInputId.layer.cornerRadius = 5
        findInputId.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        findInputId.placeholder = "아이디를 입력해주세요"
        findInputId.font = .systemFont(ofSize:14)
        
        findInputId.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        findInputId.leftViewMode = .always
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(findInputId)
        self.view.addSubview(nextInputPhoneNumBtn)
    
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(160)
            make.centerX.equalToSuperview()
        }
        
        nextInputPhoneNumBtn.snp.makeConstraints{make in
            make.bottom.equalTo(findIdStackView.snp.top).offset(-20)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
        findInputId.snp.makeConstraints{make in
            make.height.equalTo(55)
            make.top.equalTo(titleLabel.snp.bottom).offset(35)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
    }

    private func setFindIdStckView(){
        let findIdLabel = UILabel()
        findIdLabel.text = "아이디를 잊었다면?"
        findIdLabel.font = .systemFont(ofSize: 14)
        findIdLabel.textAlignment = .center

        let findIdBtn = UIButton()
        findIdBtn.setTitle("아이디 찾기", for: .normal)
        findIdBtn.setTitleColor(UIColor(named: "PrimaryColor"), for: .normal)
        findIdBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)


        findIdStackView = UIStackView(arrangedSubviews: [findIdLabel, findIdBtn])
        findIdStackView.axis = .horizontal
        findIdStackView.spacing = 12

        self.view.addSubview(findIdStackView)

        findIdStackView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(-60)
            make.centerX.equalToSuperview()
        }
    }
    @objc func changeFindInputPhoneNumVC(_ sender: UIButton){
        let nextVC = FindInputPhoneNumVC(title: FindIdPwSwitch.findAuth)
        
        AlamofireManager.shared.existId(FindIdPwSwitch.userUid) { result in
            switch result {
            case .success(let data):
                // Handle success
                if let responseData = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                           let dataDict = json["data"] as? [String: Any],
                           let valid = dataDict["valid"] as? Bool {
                            print("valid: \(valid)")
                            
                            if valid == true{
                                self.navigationController?.pushViewController(nextVC, animated: false)
                            }else{
                                let customPopupVC = CustomPopupViewController()
                                customPopupVC.modalPresentationStyle = .overFullScreen
                                customPopupVC.messageText = "입력하신 아이디를\n찾을 수 없습니다."
                                self.present(customPopupVC, animated: false, completion: nil)
                            }
                        }
                    } catch let error {
                        print("Error decoding JSON: \(error)")
                    }
                }
            case .failure(let error):
                // Handle failure
                print("Error: \(error)")
            }
        }
        
    }
    
}
extension FindInputIdVC: UITextFieldDelegate{
    // 입력값이 변경되면 버튼의 색상을 업데이트
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let updatedText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        nextInputPhoneNumBtn.updateButtonColor(updatedText, false)
        
        FindIdPwSwitch.userUid = updatedText
        print(updatedText)
        
        if updatedText.isEmpty{
            findInputId.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        }else{
            findInputId.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        }

        return true
    }
}


