//
//  SignUpVC.swift
//  fit-a-pet-client
//
//  Created by 최희진 on 2023/08/27.
//


import UIKit
import SnapKit

var GRAY2 = UIColor(named: "Gray2")
var GRAY3 = UIColor(named: "Gray3")
var PRIMARYCOLOR = UIColor(named: "PrimaryColor")

//class SignUpVC : UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
////        //navigation back 버튼 스타일
////        self.navigationController?.navigationBar.tintColor = .black
////        self.navigationController?.navigationBar.topItem?.title = ""
//    }
//}

class InputPhoneNumVC : UIViewController, UITextFieldDelegate {
    
    let nextAutnNumBtn = SignUpNextBtn(title: "다음")
    let inputPhoneNum = UITextField()
    let progressBar = SignUpProgressBar()
    let customLabel = SignUpConstomLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        //navigation back 버튼 스타일
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    private func initView(){
        
        self.view.addSubview(nextAutnNumBtn)
        self.view.addSubview(progressBar)
        self.view.addSubview(inputPhoneNum)
        self.view.addSubview(customLabel)
        
        progressBar.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(100)
            make.height.equalTo(5)
            make.left.equalTo(view.snp.left).offset(0)
            make.right.equalTo(view.snp.right).offset(0)
        }
        
        let text = "인증을 위해\n전화번호를 입력해주세요."
        let attributedText = NSMutableAttributedString(string: text)

        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        let range = (text as NSString).range(of: "전화번호")

        attributedText.addAttribute(.font, value: boldFont, range: range)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineSpacing = 8 
        
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))

        customLabel.setAttributedText(attributedText)
        
        customLabel.snp.makeConstraints{make in
            make.top.equalTo(progressBar.snp.top).offset(64)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-160)

        }
        
        inputPhoneNum.delegate = self
        inputPhoneNum.layer.borderWidth = 1
        inputPhoneNum.layer.cornerRadius = 5
        inputPhoneNum.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        
//        inputPhoneNum.snp.makeConstraints{make in
//            make.height.equalTo(55)
//            make.top.equalTo(view.snp.top).offset(255)
//            make.left.equalTo(view.snp.left).offset(20)
//            make.right.equalTo(view.snp.right).offset(-20)
//        }
        
        nextAutnNumBtn.addTarget(self, action: #selector(changeInputAuthNumVC(_:)), for: .touchUpInside)

        nextAutnNumBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initView()
        progressBar.setProgress(0.2, animated: true)
    }
    
    @objc func changeInputAuthNumVC(_ sender: UIButton){
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "InputAuthNumVC") else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
        progressBar.setProgress(0.4, animated: true)
    }
    
    // 입력값이 변경되면 버튼의 색상을 업데이트
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        //문자열을 NSString 값으로 변환, replacingCharacters() 메소드 사용하여 문자열의 일부를 변경
        let updatedText = (inputPhoneNum.text as! NSString).replacingCharacters(in: range, with: string)
        nextAutnNumBtn.updateButtonColor(with: updatedText)
        return true
    }
    
}

class InputAuthNumVC : UIViewController, UITextFieldDelegate {
    
    let nextIdBtn = SignUpNextBtn(title: "다음")
    let inputAuthNum = UITextField()
    let progressBar = SignUpProgressBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        nextIdBtn.addTarget(self, action: #selector(changeInputIdVC(_:)), for: .touchUpInside)
        
        //navigation back 버튼 스타일
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
        
    }
    private func initView(){
        
        self.view.addSubview(nextIdBtn)
        self.view.addSubview(progressBar)
        self.view.addSubview(inputAuthNum)
        
        progressBar.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(100)
            make.left.equalTo(view.snp.left).offset(0)
            make.right.equalTo(view.snp.right).offset(0)
        }
        
        inputAuthNum.delegate = self
        inputAuthNum.layer.borderWidth = 1
        inputAuthNum.layer.cornerRadius = 5
        inputAuthNum.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        inputAuthNum.placeholder = "인증번호 6자리 입력"
        inputAuthNum.font = .systemFont(ofSize:14)
        
        //textfield padding 주기
        inputAuthNum.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        inputAuthNum.leftViewMode = .always
        
        inputAuthNum.snp.makeConstraints{make in
            make.height.equalTo(55)
            make.top.equalTo(view.snp.top).offset(200)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
        }
        
        nextIdBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initView()
        progressBar.setProgress(0.4, animated: true)
    }
    
    @objc func changeInputIdVC(_ sender: UIButton){
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "InputIdVC") else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
        progressBar.setProgress(0.6, animated: true)
    }
    
    // 입력값이 변경되면 버튼의 색상을 업데이트
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        //문자열을 NSString 값으로 변환, replacingCharacters() 메소드 사용하여 문자열의 일부를 변경
        let updatedText = (inputAuthNum.text as! NSString).replacingCharacters(in: range, with: string)
        nextIdBtn.updateButtonColor(with: updatedText)
        return true
    }
}

class InputIdVC : UIViewController, UITextFieldDelegate {
    
    let nextPwBtn = SignUpNextBtn(title: "다음")
    let inputId = UITextField()
    let progressBar = SignUpProgressBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        nextPwBtn.addTarget(self, action: #selector(changeInputPwVC(_:)), for: .touchUpInside)
        
        //navigation back 버튼 스타일
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    private func initView(){
        
        self.view.addSubview(nextPwBtn)
        self.view.addSubview(progressBar)
        self.view.addSubview(inputId)
        
        progressBar.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(100)
            make.left.equalTo(view.snp.left).offset(0)
            make.right.equalTo(view.snp.right).offset(0)
        }
        
        inputId.delegate = self
        inputId.layer.borderWidth = 1
        inputId.layer.cornerRadius = 5
        inputId.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        inputId.placeholder = "영어 소문자, 숫자 조합 아이디"
        inputId.font = .systemFont(ofSize:14)
        
        //textfield padding 주기
        inputId.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        inputId.leftViewMode = .always
        
        inputId.snp.makeConstraints{make in
            make.height.equalTo(55)
            make.top.equalTo(view.snp.top).offset(255)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
        }
        
        nextPwBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initView()
        progressBar.setProgress(0.6, animated: true)
    }
    
    @objc func changeInputPwVC(_ sender: UIButton){
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "InputPwVC") else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
        progressBar.setProgress(0.8, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        //문자열을 NSString 값으로 변환, replacingCharacters() 메소드 사용하여 문자열의 일부를 변경
        let updatedText = (inputId.text as! NSString).replacingCharacters(in: range, with: string)
        nextPwBtn.updateButtonColor(with: updatedText)
        return true
    }
}

class InputPwVC : UIViewController {
    
    let nextNickBtn = SignUpNextBtn(title: "다음")
    let progressBar = SignUpProgressBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initView()
    
        nextNickBtn.addTarget(self, action: #selector(changeInputNickVC(_:)), for: .touchUpInside)
        
        //navigation back 버튼 스타일
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    private func initView(){
        self.view.addSubview(nextNickBtn)
        self.view.addSubview(progressBar)
        
        progressBar.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(100)
            make.left.equalTo(view.snp.left).offset(0)
            make.right.equalTo(view.snp.right).offset(0)
        }
        
        nextNickBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initView()
        progressBar.setProgress(0.8, animated: true)
    }
    
    @objc func changeInputNickVC(_ sender: UIButton){
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "InputNickVC") else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
        progressBar.setProgress(1.0, animated: true)
    }
}

class InputNickVC : UIViewController {
    
    let completeSignUpBtn = SignUpNextBtn(title: "회원가입")
    let progressBar = SignUpProgressBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(completeSignUpBtn)
        self.view.addSubview(progressBar)
        
        progressBar.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(100)
            make.left.equalTo(view.snp.left).offset(0)
            make.right.equalTo(view.snp.right).offset(0)
        }
        
        completeSignUpBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
//        completeSignUpBtn.addTarget(self, action: #selector(changeCompleteSignUpVC(_:)), for: .touchUpInside)
        
        //navigation back 버튼 스타일
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
//    @objc func changeCompleteSignUpVC(_ sender: UIButton){
//        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "InputPwVC") else { return }
//        self.navigationController?.pushViewController(nextVC, animated: true)
//    }
}



