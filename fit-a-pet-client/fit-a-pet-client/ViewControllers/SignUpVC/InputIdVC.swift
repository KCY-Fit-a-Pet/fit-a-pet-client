//
//  InputIdVC.swift
//  fit-a-pet-client
//
//  Created by 최희진 on 2023/09/06.
//

import UIKit
import SnapKit

class InputIdVC : UIViewController, UITextFieldDelegate {
    
    let nextPwBtn = SignUpNextBtn(title: "다음")
    let inputId = UITextField()
    let progressBar = SignUpProgressBar()
    let customLabel = SignUpConstomLabel()
        
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
        self.view.addSubview(customLabel)
        
        progressBar.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(100)
            make.left.equalTo(view.snp.left).offset(0)
            make.right.equalTo(view.snp.right).offset(0)
        }
        
        let text = "로그인에 사용할\n아이디를 입력해주세요."
        let attributedText = NSMutableAttributedString(string: text)

        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        let range = (text as NSString).range(of: "아이디")

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
        progressBar.setProgress(0.6, animated: true)
    }
    
    @objc func changeInputPwVC(_ sender: UIButton){
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "InputPwVC") else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        //문자열을 NSString 값으로 변환, replacingCharacters() 메소드 사용하여 문자열의 일부를 변경
        let updatedText = (inputId.text as! NSString).replacingCharacters(in: range, with: string)
        nextPwBtn.updateButtonColor(with: updatedText)
        
        if updatedText.isEmpty{
            inputId.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        }else{
            inputId.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        }
        
        return true
    }
}
