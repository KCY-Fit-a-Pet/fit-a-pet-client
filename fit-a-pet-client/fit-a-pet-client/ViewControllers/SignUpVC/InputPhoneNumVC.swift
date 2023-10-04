//
//  InputPhoneNumVC.swift
//  fit-a-pet-client
//
//  Created by 최희진 on 2023/09/06.
//

import UIKit
import SnapKit
import Alamofire

class InputPhoneNumVC : UIViewController {
    
    let nextAutnNumBtn = CustomNextBtn(title: "다음")
    let inputPhoneNum = UITextField()
    let progressBar = CustomProgressBar.shared
    let customLabel = ConstomLabel()
    
    var phone: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()

        nextAutnNumBtn.addTarget(self, action: #selector(changeInputAuthNumVC(_:)), for: .touchUpInside)
    }
    private func initView(){
        
        self.view.addSubview(nextAutnNumBtn)
        self.view.addSubview(inputPhoneNum)
        self.view.addSubview(customLabel)
        
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
            make.top.equalTo(view.snp.top).offset(164)
            make.left.equalTo(view.snp.left).offset(16)

        }
        
        inputPhoneNum.delegate = self
        inputPhoneNum.layer.borderWidth = 1
        inputPhoneNum.layer.cornerRadius = 5
        inputPhoneNum.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        inputPhoneNum.placeholder = "010-2345-6789"
        inputPhoneNum.font = .systemFont(ofSize:14)
        
        inputPhoneNum.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        inputPhoneNum.leftViewMode = .always
        
        inputPhoneNum.snp.makeConstraints{make in
            make.height.equalTo(55)
            make.top.equalTo(view.snp.top).offset(255)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }

        nextAutnNumBtn.snp.makeConstraints{make in
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
            self.progressBar.setProgress(0.2)
        }
    }
    
    @objc func changeInputAuthNumVC(_ sender: UIButton){
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "InputAuthNumVC") else { return }
        
        let url = "http://www.fitapet.co.kr:8080/api/v1/members/sms"
        let params = ["phone": phone] as Dictionary

        
//        AF.request(url,
//                   method: .get,
//                   parameters: params)
//                   .response { response in
//
//        switch response.result{
//            case .success(let data):
//                print(data)
//                break
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        //nextVC.phone = phone
        //if inputPhoneNum.text!.count>0{
            self.navigationController?.pushViewController(nextVC, animated: false)
        //}
        
        
    }
    
}

extension InputPhoneNumVC: UITextFieldDelegate{
    // 입력값이 변경되면 버튼의 색상을 업데이트
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        let updatedText = (inputPhoneNum.text! as NSString).replacingCharacters(in: range, with: string)
        nextAutnNumBtn.updateButtonColor(updatedText, false)
        if updatedText.isEmpty{
            inputPhoneNum.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        }else{
            inputPhoneNum.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        }
        
        //JSPhoneFormat 라이브러리로 바꾸기!!!!!!!!!
        
        if let text = inputPhoneNum.text {
            // 입력된 문자열에서 하이픈을 제거하고 숫자만 남기기
            let strippedPhoneNumber = text.replacingOccurrences(of: "-", with: "")
            
            // 입력된 문자열에서 숫자만 추출
            let digits = strippedPhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            
            var formattedText = ""
            
            // 하이픈을 추가할 위치 계산
            if digits.count >= 3 {
                formattedText += String(digits.prefix(3)) + "-"
                if digits.count >= 7 {
                    formattedText += String(digits.prefix(6).suffix(4)) + "-"
                    if digits.count >= 10 {
                        formattedText += String(digits.prefix(10).suffix(4))
                    } else {
                        formattedText += String(digits.suffix(digits.count - 6))
                    }
                } else {
                    formattedText += String(digits.suffix(digits.count - 3))
                }
            } else {
                formattedText = digits
            }
            
            inputPhoneNum.text = formattedText
            // 텍스트 필드에 포맷된 문자열을 표시
           
           // phone = Int(strippedPhoneNumber) ?? 0 // 하이픈이 제거된 문자열을 정수로 변환
            
//           // 하이픈을 추가할 위치 계산
//           if formattedText.count == 3 {
//               formattedText.insert("-", at: formattedText.index(formattedText.startIndex, offsetBy: 3))
//           } else if formattedText.count == 8 {
//               formattedText.insert("-", at: formattedText.index(formattedText.startIndex, offsetBy: 8))
//           } else if formattedText.count == 14{
//               formattedText = ""
//               return false
//           }
           
           // 텍스트 필드에 포맷된 문자열을 표시
           // phone = Int(inputPhoneNum.text!.replacingOccurrences(of: "-", with: ""))!
            
            return true
        }
        return true
    }
}
