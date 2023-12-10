import UIKit
import SnapKit

class ResetPwVC: CustomNavigationBar{
    
    private let nextInputPhoneNumBtn = CustomNextBtn(title: "비밀번호 재설정")
    private var titleStackView = UIStackView()
    private let titleLabel = UILabel()
    private let inputPw = UITextField()
    private let inputPwCheck = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.view.backgroundColor = .white
        initView()
       // nextInputPhoneNumBtn.addTarget(self, action: #selector(changeFindInputPhoneNumVC(_ :)), for: .touchUpInside)
    }
    
    private func initView(){
        
        setTitleStackView()
        
        self.view.addSubview(inputPw)
        self.view.addSubview(inputPwCheck)
        self.view.addSubview(nextInputPhoneNumBtn)
       
        //inputPw.delegate = self
        inputPw.layer.borderWidth = 1
        inputPw.layer.cornerRadius = 5
        inputPw.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        inputPw.placeholder = "영어 소문자, 숫자 조합 8자리 이상"
        inputPw.font = .systemFont(ofSize:14)
        
        //textfield padding 주기
        inputPw.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        inputPw.leftViewMode = .always
        
        inputPw.snp.makeConstraints{make in
            make.height.equalTo(55)
            make.top.equalTo(view.snp.top).offset(255)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
        //inputPwCheck.delegate = self
        inputPwCheck.layer.borderWidth = 1
        inputPwCheck.layer.cornerRadius = 5
        inputPwCheck.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        inputPwCheck.placeholder = "비밀번호 확인"
        inputPwCheck.font = .systemFont(ofSize:14)
        
        //textfield padding 주기
        inputPwCheck.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        inputPwCheck.leftViewMode = .always
        
        inputPwCheck.snp.makeConstraints{make in
            make.height.equalTo(55)
            make.top.equalTo(inputPw.snp.bottom).offset(8)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
    
        nextInputPhoneNumBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
    }
    
    private func setTitleStackView(){
        let titleLabel = UILabel()
        titleLabel.text = "비밀번호 재설정"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "새로운 비밀번호를 입력해주세요."
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.numberOfLines = 2
        subtitleLabel.textAlignment = .center
        
        titleStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        titleStackView.axis = .vertical
        titleStackView.spacing = 12
        
        self.view.addSubview(titleStackView)
        
        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(160)
            make.centerX.equalToSuperview()
        }
    }

//    @objc func changeFindInputPhoneNumVC(_ sender: UIButton){
//        let nextVC = FindInputPhoneNumVC(title: FindIdPwSwitch.findAuth)
//        self.navigationController?.pushViewController(nextVC, animated: false)
//
//    }
    
}


