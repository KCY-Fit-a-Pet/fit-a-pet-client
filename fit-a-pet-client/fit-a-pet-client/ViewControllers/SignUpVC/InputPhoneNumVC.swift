//
//  InputPhoneNumVC.swift
//  fit-a-pet-client
//
//  Created by 최희진 on 2023/09/06.
//

import UIKit
import SnapKit

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
        
        inputPhoneNum.snp.makeConstraints{make in
            make.height.equalTo(55)
            make.top.equalTo(view.snp.top).offset(255)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
        }
        
        nextAutnNumBtn.addTarget(self, action: #selector(changeInputAuthNumVC(_:)), for: .touchUpInside)

        nextAutnNumBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
  
        progressBar.setProgress(0.2, animated: true)
    }
    
    @objc func changeInputAuthNumVC(_ sender: UIButton){
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "InputAuthNumVC") else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 입력값이 변경되면 버튼의 색상을 업데이트
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        //문자열을 NSString 값으로 변환, replacingCharacters() 메소드 사용하여 문자열의 일부를 변경
        let updatedText = (inputPhoneNum.text as! NSString).replacingCharacters(in: range, with: string)
        nextAutnNumBtn.updateButtonColor(with: updatedText)
        return true
    }
    
}
