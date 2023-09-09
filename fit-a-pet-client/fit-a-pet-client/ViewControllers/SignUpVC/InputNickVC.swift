//
//  InputNickVC.swift
//  fit-a-pet-client
//
//  Created by 최희진 on 2023/09/06.
//

import UIKit
import SnapKit

class InputNickVC : UIViewController, UITextFieldDelegate {
    
    let completeSignUpBtn = SignUpNextBtn(title: "회원가입")
    let progressBar = SignUpProgressBar()
    let inputNick = UITextField()
    let customLabel = SignUpConstomLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        //navigation back 버튼 스타일
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func initView(){
        self.view.addSubview(completeSignUpBtn)
        self.view.addSubview(progressBar)
        self.view.addSubview(inputNick)
        self.view.addSubview(customLabel)
        
        progressBar.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(100)
            make.left.equalTo(view.snp.left).offset(0)
            make.right.equalTo(view.snp.right).offset(0)
        }
        
        let text = "사용할 닉네임을\n입력해주세요."
        let attributedText = NSMutableAttributedString(string: text)

        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        let range = (text as NSString).range(of: "닉네임")

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
        
        inputNick.delegate = self
        inputNick.layer.borderWidth = 1
        inputNick.layer.cornerRadius = 5
        inputNick.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        inputNick.placeholder = "닉네임 입력"
        inputNick.font = .systemFont(ofSize:14)
        
        //textfield padding 주기
        inputNick.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        inputNick.leftViewMode = .always
        
        inputNick.snp.makeConstraints{make in
            make.height.equalTo(55)
            make.top.equalTo(view.snp.top).offset(255)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
        }
        
        completeSignUpBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
//        completeSignUpBtn.addTarget(self, action: #selector(changeCompleteSignUpVC(_:)), for: .touchUpInside)
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        //문자열을 NSString 값으로 변환, replacingCharacters() 메소드 사용하여 문자열의 일부를 변경
        let updatedText = (inputNick.text as! NSString).replacingCharacters(in: range, with: string)
        completeSignUpBtn.updateButtonColor(with: updatedText)
        
        if updatedText.isEmpty{
            inputNick.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        }else{
            inputNick.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        }
        
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        progressBar.setProgress(1.0, animated: true)
    }
    
//    @objc func changeCompleteSignUpVC(_ sender: UIButton){
//        progressBar.setProgress(1.0, animated: true)
//
//    }
}
