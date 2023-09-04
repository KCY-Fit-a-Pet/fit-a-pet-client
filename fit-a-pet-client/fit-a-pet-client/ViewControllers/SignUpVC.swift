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

var progressBar: UIProgressView = {
    let view = UIProgressView()
    /// progress 배경 색상
    view.trackTintColor = GRAY3
    /// progress 진행 색상
    view.progressTintColor = PRIMARYCOLOR
    view.progress = 0.2
    return view
}()

var nextBtn: UIButton = {
    let btn = UIButton()
    
    btn.setTitle("다음", for: .normal)
    btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    btn.setTitleColor(.white, for: .normal)
    btn.backgroundColor = GRAY2
    btn.layer.cornerRadius = 5
    
    return btn
}()
//class SignUpVC : UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
////        //navigation back 버튼 스타일
////        self.navigationController?.navigationBar.tintColor = .black
////        self.navigationController?.navigationBar.topItem?.title = ""
//    }
//}

class InputPhoneNumVC : UIViewController {
    
    var nextAutnNumBtn: UIButton = nextBtn
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        nextAutnNumBtn.addTarget(self, action: #selector(changeInputAuthNumVC(_:)), for: .touchUpInside)
        
        
        //navigation back 버튼 스타일
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    private func initView(){
        
        self.view.addSubview(nextBtn)
        self.view.addSubview(progressBar)
        
        progressBar.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(100)
            make.height.equalTo(5)
            make.left.equalTo(view.snp.left).offset(0)
            make.right.equalTo(view.snp.right).offset(0)
        }
        
        nextBtn.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(400)
            make.height.equalTo(50)
            make.width.equalTo(60)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("phone num!!!!!!!!!!!!!!!!!!!!!!")
        
        initView()
        progressBar.progress = 0.2
    }
    
    @objc func changeInputAuthNumVC(_ sender: UIButton){
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "InputAuthNumVC") else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
        progressBar.setProgress(0.4, animated: true)
    }
    
}

class InputAuthNumVC : UIViewController {
    
    var nextIdBtn: UIButton = nextBtn
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        nextIdBtn.addTarget(self, action: #selector(changeInputIdVC(_:)), for: .touchUpInside)
        
        //navigation back 버튼 스타일
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
        
    }
    private func initView(){
        
        self.view.addSubview(nextBtn)
        self.view.addSubview(progressBar)
        
        progressBar.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(100)
            make.height.equalTo(5)
            make.left.equalTo(view.snp.left).offset(0)
            make.right.equalTo(view.snp.right).offset(0)
        }
        
        nextBtn.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(400)
            make.height.equalTo(50)
            make.width.equalTo(60)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Auth num!!!!!!!!!!!!!!!!!!!!!!")
        
        initView()
        progressBar.progress = 0.4
    }
    
    @objc func changeInputIdVC(_ sender: UIButton){
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "InputIdVC") else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
        progressBar.setProgress(0.6, animated: true)
    }
}

class InputIdVC : UIViewController {
    
    var nextPwBtn = nextBtn
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        nextPwBtn.addTarget(self, action: #selector(changeInputPwVC(_:)), for: .touchUpInside)
        
        //navigation back 버튼 스타일
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    private func initView(){
        
        self.view.addSubview(nextBtn)
        self.view.addSubview(progressBar)
        
        progressBar.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(100)
            make.height.equalTo(5)
            make.left.equalTo(view.snp.left).offset(0)
            make.right.equalTo(view.snp.right).offset(0)
        }
        
        nextBtn.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(400)
            make.height.equalTo(50)
            make.width.equalTo(60)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Auth num!!!!!!!!!!!!!!!!!!!!!!")
        
        initView()
        progressBar.progress = 0.6
    }
    
    @objc func changeInputPwVC(_ sender: UIButton){
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "InputPwVC") else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
        progressBar.setProgress(0.8, animated: true)
    }
}

class InputPwVC : UIViewController {
    
    var nextNickBtn = nextBtn
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initView()
    
        nextNickBtn.addTarget(self, action: #selector(changeInputNickVC(_:)), for: .touchUpInside)
        
        //navigation back 버튼 스타일
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    private func initView(){
        self.view.addSubview(nextBtn)
        self.view.addSubview(progressBar)
        
        progressBar.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(100)
            make.height.equalTo(5)
            make.left.equalTo(view.snp.left).offset(0)
            make.right.equalTo(view.snp.right).offset(0)
        }
        
        nextBtn.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(400)
            make.height.equalTo(50)
            make.width.equalTo(60)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initView()
        progressBar.progress = 0.8
    }
    
    @objc func changeInputNickVC(_ sender: UIButton){
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "InputNickVC") else { return }
        self.navigationController?.pushViewController(nextVC, animated: true)
        progressBar.setProgress(1.0, animated: true)
    }
}

class InputNickVC : UIViewController {
    
    var completeSignUpBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(completeSignUpBtn)
        
        self.view.addSubview(progressBar)
        
        progressBar.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(100)
            make.height.equalTo(5)
            make.left.equalTo(view.snp.left).offset(0)
            make.right.equalTo(view.snp.right).offset(0)
        }
        
        completeSignUpBtn.setTitle("회원가입", for: .normal)
        completeSignUpBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        completeSignUpBtn.setTitleColor(.white, for: .normal)
        completeSignUpBtn.backgroundColor = GRAY2
        completeSignUpBtn.layer.cornerRadius = 5
        completeSignUpBtn.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(100)
            make.height.equalTo(50)
            make.width.equalTo(60)
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



