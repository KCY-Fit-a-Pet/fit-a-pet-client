import UIKit
import SnapKit
import KakaoSDKAuth
import KakaoSDKUser
import GoogleSignIn
import Alamofire
import NaverThirdPartyLogin
import AuthenticationServices

class FirstVC: UIViewController {
    
    private let mainTextLabel = UILabel()
    private let signUpBtn = UIButton()
    private let loginBtn = UIButton()
    private let loginView = UIView()
    
    let PRYMARYCOLOR = UIColor(named: "PrimaryColor")
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = " "
        
        loginInstance?.delegate = self
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
        googleLogin.addTarget(self, action: #selector(googleLoginBtnTapped(_ :)), for:  .touchUpInside)
        naverLogin.addTarget(self, action: #selector(naverLoginBtnTapped(_ :)), for:  .touchUpInside)
        appleLogin.addTarget(self, action: #selector(appleLoginBtnTapped(_ :)), for:  .touchUpInside)
        
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
}

extension FirstVC{
    
    //TODO: 이미 가입된 유저가 아닌 경우 팝업창
    
    @objc func kakaoLoginBtnTapped(_ sender: UIButton){
        
        let mainVC = TabBarController()
        mainVC.modalPresentationStyle = .fullScreen
        
        let nextVC = InputPhoneNumVC()
        
        let nonce = CryptoHelpers.randomNonceString()
        print("nonce 값: \(nonce)")
        let hashedString = CryptoHelpers.sha256(nonce)
        print("hashedString 값: \(hashedString)")

        UserApi.shared.loginWithKakaoAccount(prompts:[.Login], nonce: hashedString) {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")
                
                KeychainHelper.saveTempToken(tempToken: oauthToken!.idToken!)
                print(oauthToken!.idToken as Any)
                
                UserApi.shared.me() {(user, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("사용자 정보 가져오기 성공")
                    
                        print(user!.id as Any)
                        
                        OauthInfo.provider = "kakao"
                        OauthInfo.nonce = hashedString
                        OauthInfo.oauthId = String(user!.id!)
                        
                        AnonymousAlamofire.shared.oauthLogin(){
                            result in
                            switch result {
                            case .success(let data):
                                // Handle success
                                if let responseData = data {
                                    // Process the data
                                    let object = try?JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary
                                    guard let jsonObject = object else {return}
                                    print("respose jsonData: \(jsonObject)")
                                    if let dataValue = jsonObject["data"], dataValue is NSNull {
                                        self.present(mainVC, animated: false, completion: nil)
                                    }else{
                                        RegistDivision.oauth = true
                                        self.navigationController?.pushViewController(nextVC, animated: false)
                                    }
                                }
                            case .failure(let error):
                                // Handle failure
                                print("Error: \(error)")
                            }
                        }
                    }
                }
            }
        }
    }
    @objc func googleLoginBtnTapped(_ sender: UIButton){
        
        let mainVC = TabBarController()
        mainVC.modalPresentationStyle = .fullScreen
        
        let nextVC = InputPhoneNumVC()
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: self) { signInResult, error in
                guard error == nil else { return }
                guard let signInResult = signInResult else { return }
                
                let user = signInResult.user
                let userId = user.userID
                let emailAddress = user.profile?.email
                let fullName = user.profile?.name
                let profilePicUrl = user.profile?.imageURL(withDimension: 320)
                
                print("user: \(user)")
                print("userId: \(userId)")
                print("emailAddress: \(String(describing: emailAddress))")
                print("fullName: \(String(describing: fullName))")
                print("profileUrl: \(String(describing: profilePicUrl))")
                
                signInResult.user.refreshTokensIfNeeded { user, error in
                    guard error == nil else { return }
                    guard let user = user else { return }
                    
                    let idToken = user.idToken?.tokenString
                    
                    KeychainHelper.saveTempToken(tempToken: idToken!)
                    print("idToken: \(idToken)")
                    
                    OauthInfo.provider = "google"
                    OauthInfo.oauthId = userId!
                    
                    AnonymousAlamofire.shared.oauthLogin(){
                        result in
                        switch result {
                        case .success(let data):
                            // Handle success
                            if let responseData = data {
                                // Process the data
                                let object = try?JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary
                                guard let jsonObject = object else {return}
                                print("respose jsonData: \(jsonObject)")
                                
                                if let dataValue = jsonObject["data"], dataValue is NSNull {
                                    self.present(mainVC, animated: false, completion: nil)
                                }else{
                                    RegistDivision.oauth = true
                                    self.navigationController?.pushViewController(nextVC, animated: false)
                                }
                            }
                        case .failure(let error):
                            // Handle failure
                            print("Error: \(error)")
                        }
                    }
                }
             
                //무작위로 생성된 nonce를 해싱하면 결과 해시가 예측 불가능하고 무작위로 표시되도록 할 수 있다.
            }
    }
    
    @objc func naverLoginBtnTapped(_ sender: UIButton){
        loginInstance?.requestThirdPartyLogin()
//        loginInstance?.requestDeleteToken() 로그아웃
        
    }
    @objc func appleLoginBtnTapped(_ sender: UIButton){
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
    }
    
    @objc func changeSignUpVC(_ sender: UIButton){
        let nextVC = InputPhoneNumVC()
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    
    @objc func changeLoginVC(_ sender: UIButton){
       let nextVC = LoginVC()
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    
}

extension FirstVC: NaverThirdPartyLoginConnectionDelegate{
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        loginInstance?.accessToken
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print("log out")
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("error = \(error.localizedDescription)")
    }
    
 
    // 로그인에 성공한 경우 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("Success login")
        getInfo()
    }
    
    // RESTful API, id가져오기
    func getInfo() {
        guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        
        if !isValidAccessToken {
            return
        }
        
        guard let tokenType = loginInstance?.tokenType else { return }
        guard let accessToken = loginInstance?.accessToken else { return }
        
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        let authorization = "\(tokenType) \(accessToken)"
        
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseJSON { response in
            guard let result = response.value as? [String: Any] else { return }
            guard let object = result["response"] as? [String: Any] else { return }
            guard let name = object["name"] as? String else { return }
            guard let email = object["email"] as? String else { return }
            guard let id = object["id"] as? String else {return}
            
            print("email: \(email)")
            print("name: \(name)")
            print("id: \(id)")
            print("result: \(result)")
         
        }
    }
}

extension FirstVC: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate{
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // 계정 정보 가져오기
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let idToken = appleIDCredential.identityToken!
            let tokeStr = String(data: idToken, encoding: .utf8)
         
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            print("token : \(String(describing: tokeStr))")
            
        default:
            break
        }
    }
    
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}
