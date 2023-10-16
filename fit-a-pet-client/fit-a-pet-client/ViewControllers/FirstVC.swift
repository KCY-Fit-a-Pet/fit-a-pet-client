//
//  ViewController.swift
//  fit-a-pet-client
//
//  Created by 최희진 on 2023/08/10.
//

import UIKit
import SnapKit

class FirstVC: UIViewController {
    
    var mainTextLabel = UILabel()
    var signUpBtn = UIButton()
    var loginBtn = UIButton()
    
    var PRYMARYCOLOR = UIColor(named: "PrimaryColor")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = " "
    }
    private func initView(){
        setMainTextLabelStyle()
        setSignUpBtnStyle()
        setLoginBtnStyle()
    }
}
extension FirstVC{
    
    private func setMainTextLabelStyle(){
        self.view.addSubview(mainTextLabel)
        mainTextLabel.text = "내 손안의 반려동물 케어 앱 핏어펫입니다"
        
        mainTextLabel.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(200)
            make.left.equalTo(view.snp.left).offset(16)
        }
        
    }
    
    private func setSignUpBtnStyle(){
        self.view.addSubview(signUpBtn)
        signUpBtn.backgroundColor = PRYMARYCOLOR
        signUpBtn.setTitle("새로 시작하기", for: .normal)
        signUpBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        signUpBtn.layer.cornerRadius = 5
        signUpBtn.setTitleColor(.white, for: .normal)
        signUpBtn.addTarget(self, action: #selector(changeSignUpVC(_:)), for: .touchUpInside)
        
        signUpBtn.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(400)
            make.height.equalTo(50)
            make.width.equalTo(350)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
            
        }
    }

    @objc func changeSignUpVC(_ sender: UIButton){
        let nextVC = InputPhoneNumVC()
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    
    private func setLoginBtnStyle(){
        self.view.addSubview(loginBtn)
        loginBtn.setTitle("로그인 하기", for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        loginBtn.backgroundColor = .white
        loginBtn.layer.cornerRadius = 5
        loginBtn.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        loginBtn.layer.borderWidth = 1
        loginBtn.setTitleColor(UIColor(named: "PrimaryColor"), for: .normal)
        
        loginBtn.addTarget(self, action: #selector(changeLoginVC(_:)), for: .touchUpInside)
        
        loginBtn.snp.makeConstraints{ make in
            make.top.equalTo(signUpBtn.snp.bottom).offset(8)
            make.height.equalTo(50)
            make.width.equalTo(350)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
    }
    
    @objc func changeLoginVC(_ sender: UIButton){
       let nextVC = LoginVC()
        //guard let nextVC = self.storyboard?.instantiateViewController(identifier: "LoginVC") else { return }
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    
}

