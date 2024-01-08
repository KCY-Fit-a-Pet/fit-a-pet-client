import UIKit
import SnapKit
import Alamofire

class OauthCodeVC: UIViewController {
    private let textField1: UITextField = {
        let textField = UITextField()
        textField.placeholder = "번호 입력"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let textField2: UITextField = {
        let textField = UITextField()
        textField.placeholder = "코드 입력"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let sendsmsButton: UIButton = {
        let button = UIButton()
        button.setTitle("sendsms", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(sendsmsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let checksmsButton: UIButton = {
        let button = UIButton()
        button.setTitle("checksms", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(checksmsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let registsButton: UIButton = {
        let button = UIButton()
        button.setTitle("registuser", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(registButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(textField1)
        view.addSubview(textField2)
        view.addSubview(sendsmsButton)
        view.addSubview(checksmsButton)
        view.addSubview(registsButton)
        
        self.view.backgroundColor = .white
        
        textField1.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        textField2.snp.makeConstraints { make in
            make.top.equalTo(textField1.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        sendsmsButton.snp.makeConstraints { make in
            make.top.equalTo(textField2.snp.bottom).offset(20)
            make.centerX.equalToSuperview().offset(-70)
        }
        
        checksmsButton.snp.makeConstraints { make in
            make.top.equalTo(textField2.snp.bottom).offset(20)
            make.centerX.equalToSuperview().offset(70)
        }
        
        registsButton.snp.makeConstraints { make in
            make.top.equalTo(sendsmsButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview().offset(70)
        }
    }
    
    @objc private func sendsmsButtonTapped() {
        
        //OauthInfo.phoneNum = textField1.text!
        
        if let text1 = textField1.text, let text2 = textField2.text {
            print("Text 1: \(text1), Text 2: \(text2)")
        }
        
        AnonymousAlamofire.shared.oauthSendSms(){
            result in
            switch result {
            case .success(let data):
                // Handle success
                if let responseData = data {
                    // Process the data
                    let object = try?JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary
                    guard let jsonObject = object else {return}
                    print("respose jsonData: \(jsonObject)")
                }
            case .failure(let error):
                // Handle failure
                print("Error: \(error)")
            }
        }
    }
    
    @objc private func checksmsButtonTapped() {
    
        AnonymousAlamofire.shared.oauthCheckSms(textField2.text!){
            result in
            switch result {
            case .success(let data):
                // Handle success
                if let responseData = data {
                    // Process the data
                    let object = try?JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary
                    guard let jsonObject = object else {return}
                    print("respose jsonData: \(jsonObject)")
                }
            case .failure(let error):
                // Handle failure
                print("Error: \(error)")
            }
        }
    }
    @objc private func registButtonTapped() {
    
        AuthorizationAlamofire.shared.oauthRegistUser("hee", "jin"){
            result in
            switch result {
            case .success(let data):
                // Handle success
                if let responseData = data {
                    // Process the data
                    let object = try?JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary
                    guard let jsonObject = object else {return}
                    print("respose jsonData: \(jsonObject)")
                }
            case .failure(let error):
                // Handle failure
                print("Error: \(error)")
            }
        }
    }
}

