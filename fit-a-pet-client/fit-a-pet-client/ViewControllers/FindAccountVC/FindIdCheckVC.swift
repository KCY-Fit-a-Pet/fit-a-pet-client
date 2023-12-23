
import UIKit
import SnapKit

class FindIdCheckVC: CustomNavigationBar{
    
    private let returnLoginVCBtn = CustomNextBtn(title: "로그인하러 가기")
    private let idCheckLabel = UILabel()
    private var titleStackView = UIStackView()
    private var findPwStackView = UIStackView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.view.backgroundColor = .white
        initView()
        returnLoginVCBtn.addTarget(self, action: #selector(returnLoginVC(_:)), for: .touchUpInside)
    }
    
    private func initView(){
        
        setTitleStackView()
        setFindPwStckView()
        
        idCheckLabel.layer.borderWidth = 1
        idCheckLabel.layer.cornerRadius = 5
        idCheckLabel.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        idCheckLabel.textAlignment = .center
        
        self.view.addSubview(idCheckLabel)
        self.view.addSubview(returnLoginVCBtn)
        
        idCheckLabel.snp.makeConstraints{make in
            make.top.equalTo(titleStackView.snp.bottom).offset(35)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(55)
        }
        
        returnLoginVCBtn.snp.makeConstraints{make in
            make.bottom.equalTo(findPwStackView.snp.top).offset(-20)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AlamofireManager.shared.findId(FindIdPwSwitch.phoneNum, FindIdPwSwitch.code){
            result in
            switch result {
            case .success(let data):
                // Handle success
                if let responseData = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                            if let dataDict = json["data"] as? [String: Any] {
                                if let memberDict = dataDict["member"] as? [String: Any] {
                                    if let uid = memberDict["uid"] as? String {
                                        self.idCheckLabel.text = uid
                                    }
                                }
                            }
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            case .failure(let error):
                // Handle failure
                print("Error: \(error)")
            }
        }
    }
    
    private func setTitleStackView(){
        let titleLabel = UILabel()
        titleLabel.text = "아이디 찾기"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "입력하신 전화번호와 일치하는 아이디입니다."
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
    
    private func setFindPwStckView(){
        let findPwLabel = UILabel()
        findPwLabel.text = "비밀번호를 잊었다면?"
        findPwLabel.font = .systemFont(ofSize: 14)
        findPwLabel.textAlignment = .center
        
        let findPwBtn = UIButton()
        findPwBtn.setTitle("비밀번호 찾기", for: .normal)
        findPwBtn.setTitleColor(UIColor(named: "PrimaryColor"), for: .normal)
        findPwBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        
        findPwStackView = UIStackView(arrangedSubviews: [findPwLabel, findPwBtn])
        findPwStackView.axis = .horizontal
        findPwStackView.spacing = 12
        
        self.view.addSubview(findPwStackView)
        
        findPwStackView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(-60)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func returnLoginVC(_ sender: UIButton){

    }
    
}
