//
//  ViewController.swift
//  fit-a-pet-client
//
//  Created by 최희진 on 2023/08/10.
//

import UIKit
import SnapKit

class MainVC: UIViewController {
    
    var mainTextLabel = UILabel()
    var signUpBtn = UIButton()
    var loginBtn = UIButton()
    
    var PRYMARYCOLOR = UIColor(named: "PrimaryColor")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    private func initView(){
        setMainTextLabelStyle()
        setSignUpBtnStyle()
        setLoginBtnStyle()
    }
}
extension MainVC{
    
    private func setMainTextLabelStyle(){
        self.view.addSubview(mainTextLabel)
        mainTextLabel.text = "내 손안의 반려동물 케어 앱 핏어펫입니다"
        
        mainTextLabel.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(250)
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
            make.top.equalTo(view.snp.top).offset(480)
            make.height.equalTo(50)
            make.width.equalTo(350)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
            
        }
    }

    @objc func changeSignUpVC(_ sender: UIButton){
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "InputPhoneNumVC") else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
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
        
        loginBtn.snp.makeConstraints{ make in
            make.top.equalTo(signUpBtn.snp.top).offset(60)
            make.height.equalTo(50)
            make.width.equalTo(350)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
    }
    
}

