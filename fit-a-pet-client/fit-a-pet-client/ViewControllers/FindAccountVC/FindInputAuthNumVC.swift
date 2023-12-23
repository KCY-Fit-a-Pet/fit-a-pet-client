import UIKit
import SnapKit

class FindInputAuthNumVC: CustomNavigationBar{
    
    private let nextIdCheckBtn = CustomNextBtn(title: FindIdPwSwitch.findAuth)
    private let inputAuthNum = UITextField()
    
    var phone: String = ""
    var code: String = ""
    
    init(title: String, phone: String) {
        self.phone = phone
        super.init(title: title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.view.backgroundColor = .white
        inputAuthNum.delegate = self
        initView()
        nextIdCheckBtn.addTarget(self, action: #selector(changeFindIdCheckVC(_ :)), for: .touchUpInside)
    }
    
    private func initView(){
        
        let titleLabel = UILabel()
        titleLabel.text = "전송된 인증번호를 입력해주세요."
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
        self.view.addSubview(inputAuthNum)
        self.view.addSubview(nextIdCheckBtn)
        
        inputAuthNum.layer.borderWidth = 1
        inputAuthNum.layer.cornerRadius = 5
        inputAuthNum.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        inputAuthNum.placeholder = "인증번호 6자리 입력"
        inputAuthNum.font = .systemFont(ofSize:14)
        
        inputAuthNum.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        inputAuthNum.leftViewMode = .always
        
        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(130)
            make.centerX.equalToSuperview()
        }
        
        inputAuthNum.snp.makeConstraints{make in
            make.height.equalTo(55)
            make.top.equalTo(view.snp.top).offset(245)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
        nextIdCheckBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
    }
    
    @objc func changeFindIdCheckVC(_ sender: UIButton){
        let nextVC = ResetPwVC(title: FindIdPwSwitch.findAuth)
        
        if  FindIdPwSwitch.findAuth == "아이디 찾기"{
            let nextVC = FindIdCheckVC(title: FindIdPwSwitch.findAuth)
        }
        
        AlamofireManager.shared.checkAuthSms(FindIdPwSwitch.phoneNum, FindIdPwSwitch.code){
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
                customPopupVC.messageText = "인증번호가 일치하지 않습니다."
                self.present(customPopupVC, animated: false
                             , completion: nil)
            }
        }
        
    }
}

extension FindInputAuthNumVC: UITextFieldDelegate{
    // 입력값이 변경되면 버튼의 색상을 업데이트
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        //문자열을 NSString 값으로 변환, replacingCharacters() 메소드 사용하여 문자열의 일부를 변경
        let updatedText = (inputAuthNum.text! as NSString).replacingCharacters(in: range, with: string)
       
        nextIdCheckBtn.updateButtonColor(updatedText, true)
        
        FindIdPwSwitch.code = updatedText
     
        if updatedText.isEmpty{
            inputAuthNum.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        }else{
            inputAuthNum.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        }
        
        return true
    }
}
