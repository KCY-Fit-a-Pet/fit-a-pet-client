
import UIKit
import SnapKit

class InputNickVC : UIViewController {
    
    private let completeSignUpBtn = CustomNextBtn(title: "회원가입")
    private let progressBar = CustomProgressBar.shared
    private let inputNick = UITextField()
    private let customLabel = ConstomLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    private func initView(){
        
        view.backgroundColor = .white
        
        self.view.addSubview(completeSignUpBtn)
        self.view.addSubview(inputNick)
        self.view.addSubview(customLabel)
        
        let text = "사용할 닉네임을\n입력해주세요."
        let range = "닉네임"

        customLabel.setAttributedText(text, range)
        
        customLabel.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(164)
            make.left.equalTo(view.snp.left).offset(16)
        }
        
        inputNick.delegate = self
        inputNick.layer.borderWidth = 1
        inputNick.layer.cornerRadius = 5
        inputNick.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        inputNick.placeholder = "닉네임 입력"
        inputNick.font = .systemFont(ofSize:14)
        
        //textfield padding 주기
        inputNick.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        inputNick.leftViewMode = .always
        
        inputNick.snp.makeConstraints{make in
            make.height.equalTo(55)
            make.top.equalTo(view.snp.top).offset(255)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
        completeSignUpBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        completeSignUpBtn.addTarget(self, action: #selector(changeCompleteSignUpVC(_:)), for: .touchUpInside)
        
    }
    
    private func progressBarInit(){
        self.view.addSubview(progressBar)
        progressBar.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(100)
            make.height.equalTo(5)
            make.left.equalTo(view.snp.left).offset(0)
            make.right.equalTo(view.snp.right).offset(0)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        RegistrationManager.shared.addInput(nickname: "최희진2")
       // RegistrationManager.shared.performRegistration()
        
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = " "
        
        progressBarInit()
        UIView.animate(withDuration: 0.5) {
            self.progressBar.setProgress(1.0) 
        }
    }
   
    
    @objc func changeCompleteSignUpVC(_ sender: UIButton){
        AlamofireManager.shared.regist(RegistrationManager.shared.id!, RegistrationManager.shared.nickname!, RegistrationManager.shared.pw!, "", ""){
            result in
            switch result {
            case .success(let data):
                // Handle success
                if let responseData = data {
                    // Process the data
                    let object = try?JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary
                    guard let jsonObject = object else {return}
                    print("respose jsonData: \(jsonObject)")
                }
            case .failure(let error):
                // Handle failure
                print("Error: \(error)")
            }
        }

    }
}

extension InputNickVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        //문자열을 NSString 값으로 변환, replacingCharacters() 메소드 사용하여 문자열의 일부를 변경
        let updatedText = (inputNick.text! as NSString).replacingCharacters(in: range, with: string)
        completeSignUpBtn.updateButtonColor(updatedText,false)
        
        if updatedText.isEmpty{
            inputNick.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        }else{
            inputNick.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        }
        
        return true
    }
}
