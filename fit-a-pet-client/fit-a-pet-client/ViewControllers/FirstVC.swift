import UIKit
import SnapKit
import KakaoSDKAuth
import KakaoSDKUser

class FirstVC: UIViewController {
    
    private let mainTextLabel = UILabel()
    private let signUpBtn = UIButton()
    private let loginBtn = UIButton()
    private let loginView = UIView()
    
    let PRYMARYCOLOR = UIColor(named: "PrimaryColor")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = " "
    }
    private func initView(){
        self.view.backgroundColor = .white
        
        setMainTextLabelStyle()
        setSignUpBtnStyle()
        setLoginBtnStyle()
        setLoginViewStyle()
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
            make.top.equalTo(view.snp.bottom).offset(-350)
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
    
    private func setLoginViewStyle() {
        let loginLabel = UILabel()
        loginLabel.text = "혹은 간편 로그인"
        loginLabel.textColor = UIColor(named: "Gray5")
        
        let dividerLeft = UIView()
        dividerLeft.backgroundColor = UIColor(named: "Gray5")
        
        let dividerRight = UIView()
        dividerRight.backgroundColor = UIColor(named: "Gray5")
        
        let naverLogin = UIButton()
        let kakaoLogin = UIButton()
        let googleLogin = UIButton()
        let appleLogin = UIButton()
        
        naverLogin.setImage(UIImage(named: "naver_icon"), for: .normal)
        kakaoLogin.setImage(UIImage(named: "kakao_icon"), for: .normal)
        googleLogin.setImage(UIImage(named: "google_icon"), for: .normal)
        appleLogin.setImage(UIImage(named: "apple_icon"), for: .normal)
        
        
        kakaoLogin.addTarget(self, action: #selector(kakaoLoginBtnTapped(_:)), for: .touchUpInside)
        
        let loginButtons = [naverLogin, kakaoLogin, googleLogin, appleLogin]
        
        let loginIcon = UIStackView(arrangedSubviews: loginButtons)
        
        loginIcon.axis = .horizontal
        loginIcon.distribution = .fillEqually
        loginIcon.spacing = 16
        
        loginView.addSubview(loginLabel)
        loginView.addSubview(dividerLeft)
        loginView.addSubview(dividerRight)
        loginView.addSubview(loginIcon)
        
        self.view.addSubview(loginView)
        
        loginView.snp.makeConstraints { make in
            make.top.equalTo(loginBtn.snp.bottom).offset(24)
            make.bottom.equalTo(view.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(loginView.snp.top).offset(16)
            make.centerX.equalTo(loginView.snp.centerX)
        }
        
        dividerLeft.snp.makeConstraints { make in
            make.centerY.equalTo(loginLabel.snp.centerY)
            make.height.equalTo(1)
            make.width.equalTo(loginLabel.snp.width).multipliedBy(0.4)
            make.trailing.equalTo(loginLabel.snp.leading).offset(-8)
        }
        
        dividerRight.snp.makeConstraints { make in
            make.centerY.equalTo(loginLabel.snp.centerY)
            make.height.equalTo(1)
            make.width.equalTo(loginLabel.snp.width).multipliedBy(0.4)
            make.leading.equalTo(loginLabel.snp.trailing).offset(8)
        }
        
        loginIcon.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(24)
            make.left.equalTo(loginView.snp.left).offset(52)
            make.right.equalTo(loginView.snp.right).offset(-52)
            make.height.equalTo(60) 
        }
    }

    @objc func kakaoLoginBtnTapped(_ sender: UIButton){
        print("touch")
        
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
           
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")
                
                //do something
                _ = oauthToken
            }
        }
    }
    
}

