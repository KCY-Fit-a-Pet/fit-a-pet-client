//
//  LoginVC.swift
//  fit-a-pet-client
//
//  Created by 최희진 on 2023/09/10.
//

import UIKit
import SnapKit
import Alamofire

class LoginVC: UIViewController, UITextFieldDelegate{
    
    let loginLabel = UILabel()
    let inputId = UITextField()
    let inputPw = UITextField()
    let loginBtn = UIButton()
    
    var uid = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        stackBtnView()
        
        loginBtn.addTarget(self, action: #selector(changeTabBarVC(_:)), for: .touchUpInside)
        
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    private func initView(){
        
        view.backgroundColor = .white
        self.view.addSubview(loginLabel)
        self.view.addSubview(inputId)
        self.view.addSubview(inputPw)
        self.view.addSubview(loginBtn)
        
        inputId.delegate = self
        inputPw.delegate = self
        
        loginLabel.text = "로그인"
        loginLabel.font = .boldSystemFont(ofSize: 20)
        
        loginLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(200)
            
            //수평 중앙정렬
            make.centerX.equalToSuperview()
        }
        
        inputId.layer.borderWidth = 1
        inputId.layer.cornerRadius = 5
        inputId.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        inputId.placeholder = "아이디"
        inputId.font = .systemFont(ofSize:14)
        
        inputId.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        inputId.leftViewMode = .always
        
        inputId.snp.makeConstraints{make in
            make.height.equalTo(55)
            make.top.equalTo(loginLabel.snp.bottom).offset(24)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
        inputPw.layer.borderWidth = 1
        inputPw.layer.cornerRadius = 5
        inputPw.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        inputPw.placeholder = "비밀번호"
        inputPw.font = .systemFont(ofSize:14)
        
        inputPw.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        inputPw.leftViewMode = .always
        
        inputPw.snp.makeConstraints{make in
            make.height.equalTo(55)
            make.top.equalTo(inputId.snp.bottom).offset(16)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
        loginBtn.backgroundColor = UIColor(named: "PrimaryColor")
        loginBtn.setTitle("로그인", for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        loginBtn.layer.cornerRadius = 5
        loginBtn.setTitleColor(.white, for: .normal)
        
        
        loginBtn.snp.makeConstraints{make in
            make.top.equalTo(inputPw.snp.bottom).offset(24)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
            make.height.equalTo(55)
        }
        
    }
    private func stackBtnView(){
        let stackView = UIStackView()
            stackView.axis = .horizontal // 수평 정렬
            stackView.spacing = 32 // 버튼 사이의 간격
            stackView.alignment = .center // 중앙 정렬
            stackView.distribution = .fillEqually // 버튼 사이즈를 동일하게 분배

            // 버튼 3개 생성
            let findIdBtn = UIButton(type: .system)
            findIdBtn.setTitle("아이디 찾기", for: .normal)
            findIdBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            findIdBtn.setTitleColor(.black, for: .normal)
            
            let findPwBtn = UIButton(type: .system)
            findPwBtn.setTitle("비밀번호 찾기", for: .normal)
            findPwBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            findPwBtn.setTitleColor(.black, for: .normal)
            
            let SignUpBtn = UIButton(type: .system)
            SignUpBtn.setTitle("회원가입", for: .normal)
            SignUpBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            SignUpBtn.setTitleColor(.black, for: .normal)

            // UIStackView에 버튼들 추가
            stackView.addArrangedSubview(findIdBtn)
            stackView.addArrangedSubview(findPwBtn)
            stackView.addArrangedSubview(SignUpBtn)

            // UIStackView를 뷰에 추가
            view.addSubview(stackView)

            // UIStackView의 제약 조건 설정
            stackView.snp.makeConstraints { make in
                make.centerX.equalToSuperview() // 수평 중앙 정렬
                make.top.equalTo(loginBtn.snp.bottom).offset(30) // 원하는 위치로 조정
            }
    }
    
    @objc func changeTabBarVC(_ sender: UIButton){

        //guard let nextVC = self.storyboard?.instantiateViewController(identifier: "TabBarController") else { return }
        let nextVC = TabBarController()
        nextVC.modalPresentationStyle = .fullScreen
        let url = URL(string: "http://www.fitapet.co.kr:8080/api/v1/members/login")!
        var request = URLRequest(url: url)

        //post body부분
        let loginData = ["uid": "jayang", "password": "dkssudgktpdy"] as Dictionary
        let jsonData = try! JSONSerialization.data(withJSONObject: loginData, options: [])
            
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
      
        
//        AlamofireManager.shared.login("jayang", "dkssudgktpdy"){
//            result in
//            switch result {
//            case .success(let data):
//                // Handle success
//                if let responseData = data {
//                    // Process the data
//                    let object = try?JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary
//                    guard let jsonObject = object else {return}
//                    print("respose jsonData: \(jsonObject)")
//                   // print("Received data: \(responseData)")
//                }
//            case .failure(let error):
//                // Handle failure
//                print("Error: \(error)")
//            }
//        }
        
        // 모달로 다음 뷰 컨트롤러를 표시
        self.present(nextVC, animated: false, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == inputPw {
            //inputPw에 text 값이 있어야만 inputPwText에 입력할 수 있다.
            if let inputPwText = inputId.text, !inputPwText.isEmpty {
                let updatedText = (inputPw.text! as NSString).replacingCharacters(in: range, with: string)
                password = updatedText
                
                if updatedText.isEmpty{
                    inputPw.layer.borderColor = UIColor(named: "Gray2")?.cgColor
                }else{
                    inputPw.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
                }
                return true
                
            } else {
                return false
            }
            
        } else{
            let updatedText = (inputId.text! as NSString).replacingCharacters(in: range, with: string)
            uid = updatedText
            if updatedText.isEmpty {
                inputId.layer.borderColor = UIColor(named: "Gray2")?.cgColor
                
            } else {
                inputId.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
            }
        }
        return true
    }
}
    

