
import UIKit
import SnapKit

class InputIdVC : UIViewController {
    
    private let nextPwBtn = CustomNextBtn(title: "다음")
    private let inputId = UITextField()
    private let progressBar = CustomProgressBar.shared
    private let customLabel = ConstomLabel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        nextPwBtn.addTarget(self, action: #selector(changeInputPwVC(_:)), for: .touchUpInside)
        
    }
    private func initView(){
        
        view.backgroundColor = .white
        
        self.view.addSubview(nextPwBtn)
        self.view.addSubview(inputId)
        self.view.addSubview(customLabel)
    
        let text = "로그인에 사용할\n아이디를 입력해주세요."
        let range = "아이디"

        customLabel.setAttributedText(text, range)        
        
        customLabel.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(164)
            make.left.equalTo(view.snp.left).offset(16)

        }
        
        inputId.delegate = self
        inputId.layer.borderWidth = 1
        inputId.layer.cornerRadius = 5
        inputId.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        inputId.placeholder = "영어 소문자, 숫자 조합 아이디"
        inputId.font = .systemFont(ofSize:14)
        
        //textfield padding 주기
        inputId.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        inputId.leftViewMode = .always
        
        inputId.snp.makeConstraints{make in
            make.height.equalTo(55)
            make.top.equalTo(view.snp.top).offset(255)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
        nextPwBtn.snp.makeConstraints{make in
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
        self.navigationController?.navigationBar.topItem?.title = ""
        
        progressBarInit()
        UIView.animate(withDuration: 0.5) {
            self.progressBar.setProgress(0.6)
        }
    }
    
    @objc func changeInputPwVC(_ sender: UIButton){
        
        if let id = inputId.text {
            RegistrationManager.shared.addInput(id: id)
        }
        
        let nextVC = InputPwVC()
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
}
extension InputIdVC: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        //문자열을 NSString 값으로 변환, replacingCharacters() 메소드 사용하여 문자열의 일부를 변경
        let updatedText = (inputId.text! as NSString).replacingCharacters(in: range, with: string)
        nextPwBtn.updateButtonColor(updatedText, false)
        
        if updatedText.isEmpty{
            inputId.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        }else{
            inputId.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        }
        
        return true
    }
}
