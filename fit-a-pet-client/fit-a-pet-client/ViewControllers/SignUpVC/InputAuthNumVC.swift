

import UIKit
import SnapKit

class InputAuthNumVC : UIViewController{
    
    private let nextIdBtn = CustomNextBtn(title: "다음")
    private let inputAuthNum = UITextField()
    private let progressBar = CustomProgressBar.shared
    private let customLabel = ConstomLabel()
    
    var phone: String = ""
    var code: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        nextIdBtn.addTarget(self, action: #selector(changeInputIdVC(_:)), for: .touchUpInside)
    }
    private func initView(){
        
        view.backgroundColor = .white
        
        self.view.addSubview(nextIdBtn)
        self.view.addSubview(inputAuthNum)
        self.view.addSubview(customLabel)
       
        let text = "전송받은 인증번호 6자리를\n입력해주세요."
        let range = "인증번호 6자리"

        customLabel.setAttributedText(text, range)
        
        
        customLabel.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(164)
            make.left.equalTo(view.snp.left).offset(16)
        }
        
        inputAuthNum.delegate = self
        inputAuthNum.layer.borderWidth = 1
        inputAuthNum.layer.cornerRadius = 5
        inputAuthNum.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        inputAuthNum.placeholder = "인증번호 6자리 입력"
        inputAuthNum.font = .systemFont(ofSize: 14)
        
        //textfield padding 주기
        inputAuthNum.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        inputAuthNum.leftViewMode = .always
        
        inputAuthNum.snp.makeConstraints{make in
            make.height.equalTo(55)
            make.top.equalTo(view.snp.top).offset(255)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
        nextIdBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
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
        
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = " "
        
        progressBarInit()
        UIView.animate(withDuration: 0.5) {
            self.progressBar.setProgress(0.4) 
        }
        
    }
    @objc func changeInputIdVC(_ sender: UIButton){
        phone = RegistrationManager.shared.phone!
        
        AlamofireManager.shared.checkSms(phone, code){
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
        
        let nextVC = InputIdVC()

        self.navigationController?.pushViewController(nextVC, animated: false)
        
    }
}

extension InputAuthNumVC: UITextFieldDelegate{
    // 입력값이 변경되면 버튼의 색상을 업데이트
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        //문자열을 NSString 값으로 변환, replacingCharacters() 메소드 사용하여 문자열의 일부를 변경
        let updatedText = (inputAuthNum.text! as NSString).replacingCharacters(in: range, with: string)
        
        nextIdBtn.updateButtonColor(updatedText, true)
        
        code = updatedText
        
        if updatedText.isEmpty{
            inputAuthNum.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        }else{
            inputAuthNum.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        }
        
        return true
    }
}
