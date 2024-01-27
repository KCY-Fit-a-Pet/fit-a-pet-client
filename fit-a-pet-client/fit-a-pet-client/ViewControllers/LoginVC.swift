//
//  LoginVC.swift
//  fit-a-pet-client
//
//  Created by 최희진 on 2023/09/10.
//

import UIKit
import SnapKit
import Alamofire

class LoginVC: UIViewController{
    
    private let loginLabel = UILabel()
    private let inputId = UITextField()
    private let inputPw = UITextField()
    private let loginBtn = UIButton()
    
    private var uid = ""
    private var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        stackBtnView()
        
        inputId.delegate = self
        inputPw.delegate = self
        
        loginBtn.addTarget(self, action: #selector(changeTabBarVC(_:)), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(retryLoginNotification(_:)), name: .retryLoginNotification, object: nil)
        
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    deinit {
        // Remove the observer when the view controller is deallocated
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func retryLoginNotification(_ notification: Notification) {

        let firstVC = FirstVC()
           
        if UIApplication.shared.delegate is AppDelegate {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate {
                let mainViewController = FirstVC()
                let navigationController = UINavigationController(rootViewController: mainViewController)
                sceneDelegate.window?.rootViewController = navigationController
            }
        } else {
            print("Unable to access the app delegate")
        }
    }
    private func initView(){
        
        view.backgroundColor = .white
        
        let containerView = UIView()
        
        
        containerView.addSubview(loginLabel)
        containerView.addSubview(inputId)
        containerView.addSubview(inputPw)
        containerView.addSubview(loginBtn)
        view.addSubview(containerView)
        
        containerView.layer.borderWidth = 1
        
        containerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(350)
            make.leading.trailing.equalToSuperview()
        }
        
        loginLabel.text = "로그인"
        loginLabel.font = .boldSystemFont(ofSize: 20)
        
        loginLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        inputId.layer.borderWidth = 1
        inputId.layer.cornerRadius = 5
        inputId.layer.borderColor = UIColor(named: "Gray3")?.cgColor
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
        inputPw.layer.borderColor = UIColor(named: "Gray3")?.cgColor
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
        
        findIdBtn.addTarget(self, action: #selector(changeFindIdVC(_:)), for: .touchUpInside)
        
        let findPwBtn = UIButton(type: .system)
        findPwBtn.setTitle("비밀번호 찾기", for: .normal)
        findPwBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        findPwBtn.setTitleColor(.black, for: .normal)
        
        findPwBtn.addTarget(self, action: #selector(changeFindPwVC(_:)), for: .touchUpInside)
        
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
    
    @objc func changeTabBarVC(_ sender: UIButton) {
        let mainVC = TabBarController()
        mainVC.modalPresentationStyle = .fullScreen

        
        AnonymousAlamofire.shared.login("heejin", "heejin123") { [weak self] loginResult in
            switch loginResult {
            case .success(let data):
                if let responseData = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                           let dataObject = json["data"] as? [String: Any]{
                            if let userId = dataObject["userId"] as? Int {
                                print("userId: \(userId)")
                                UserDefaults.standard.set(userId, forKey: "id")
                                
                                self?.present(mainVC, animated: false, completion: nil)
                            }
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }

            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    @objc func changeFindIdVC(_ sender: UIButton){
        FindIdPwSwitch.findAuth = "아이디 찾기"
        FindIdPwSwitch.findtype = "uid"
        let findIdVC = FindInputPhoneNumVC(title: FindIdPwSwitch.findAuth)
        self.navigationController?.pushViewController(findIdVC, animated: false)
    }
    
    @objc func changeFindPwVC(_ sender: UIButton){
        FindIdPwSwitch.findAuth = "비밀번호 찾기"
        FindIdPwSwitch.findtype = "password"
        let findPwVC = FindInputIdVC(title: FindIdPwSwitch.findAuth)
        self.navigationController?.pushViewController(findPwVC, animated: false)
    }
}
    
extension LoginVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == inputPw {
            //inputPw에 text 값이 있어야만 inputPwText에 입력할 수 있다.
            if let inputPwText = inputId.text, !inputPwText.isEmpty {
                let updatedText = (inputPw.text! as NSString).replacingCharacters(in: range, with: string)
                password = updatedText
                
                if updatedText.isEmpty{
                    inputPw.layer.borderColor = UIColor(named: "Gray3")?.cgColor
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
                inputId.layer.borderColor = UIColor(named: "Gray3")?.cgColor
                
            } else {
                inputId.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
            }
        }
        return true
    }
}
