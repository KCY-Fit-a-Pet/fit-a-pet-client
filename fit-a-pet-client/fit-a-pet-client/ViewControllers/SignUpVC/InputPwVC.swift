//
//  InputPwVC.swift
//  fit-a-pet-client
//
//  Created by 최희진 on 2023/09/06.
//

import UIKit
import SnapKit

class InputPwVC : UIViewController, UITextFieldDelegate {
    
    let nextNickBtn = SignUpNextBtn(title: "다음")
    let progressBar = SignUpProgressBar()
    let inputPw = UITextField()
    let inputPwCheck = UITextField()
    let customLabel = SignUpConstomLabel()
    
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
        self.view.addSubview(inputPw)
        self.view.addSubview(inputPwCheck)
        self.view.addSubview(customLabel)
        
        progressBar.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(100)
            make.left.equalTo(view.snp.left).offset(0)
            make.right.equalTo(view.snp.right).offset(0)
        }
        let text = "로그인에 사용할\n비밀번호를 입력해주세요."
        let attributedText = NSMutableAttributedString(string: text)

        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        let range = (text as NSString).range(of: "비밀번호")

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
        
        inputPw.delegate = self
        inputPw.layer.borderWidth = 1
        inputPw.layer.cornerRadius = 5
        inputPw.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        inputPw.placeholder = "영어 소문자, 숫자 조합 8자리 이상"
        inputPw.font = .systemFont(ofSize:14)
        
        //textfield padding 주기
        inputPw.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        inputPw.leftViewMode = .always
        
        inputPw.snp.makeConstraints{make in
            make.height.equalTo(55)
            make.top.equalTo(view.snp.top).offset(255)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
        }
        
        inputPwCheck.delegate = self
        inputPwCheck.layer.borderWidth = 1
        inputPwCheck.layer.cornerRadius = 5
        inputPwCheck.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        inputPwCheck.placeholder = "비밀번호 확인"
        inputPwCheck.font = .systemFont(ofSize:14)
        
        //textfield padding 주기
        inputPwCheck.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        inputPwCheck.leftViewMode = .always
        
        inputPwCheck.snp.makeConstraints{make in
            make.height.equalTo(55)
            make.top.equalTo(inputPw.snp.bottom).offset(8)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
        }
        
        nextNickBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        progressBar.setProgress(0.8, animated: true)
    }
    
    @objc func changeInputNickVC(_ sender: UIButton){
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "InputNickVC") else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
       // progressBar.setProgress(1.0, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == inputPwCheck {
            //inputPw에 text 값이 있어야만 inputPwText에 입력할 수 있다.
            if let inputPwText = inputPw.text, !inputPwText.isEmpty {
                let updatedText = (inputPwCheck.text as! NSString).replacingCharacters(in: range, with: string)
                nextNickBtn.updateButtonColor(with: updatedText)
                return true
            } else {
                return false
            }
        }
        return true
    }
}
