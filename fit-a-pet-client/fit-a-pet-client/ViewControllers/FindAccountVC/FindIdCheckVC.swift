
import UIKit
import SnapKit

class FindIdCheckVC: CustomNavigationBar{
    
    private let returnLoginVCBtn = CustomNextBtn(title: "로그인하러 가기")
    let idCheckLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.view.backgroundColor = .white
        initView()
        //returnLoginVCBtn.addTarget(self, action: #selector(<#T##@objc method#>), for: .touchUpInside)
    }
    
    private func initView(){
        
        let titleLabel = UILabel()
        titleLabel.text = "아이디 찾기"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "입력하신 전화번호와 일치하는 아이디입니다."
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.numberOfLines = 2
        subtitleLabel.textAlignment = .center
        
        let titleStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        titleStackView.axis = .vertical
        titleStackView.spacing = 12
        
        idCheckLabel.layer.borderWidth = 1
        idCheckLabel.layer.cornerRadius = 5
        idCheckLabel.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        idCheckLabel.textAlignment = .center
        
        self.view.addSubview(idCheckLabel)
        self.view.addSubview(titleStackView)
        self.view.addSubview(returnLoginVCBtn)
       
        titleStackView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(130)
            make.centerX.equalToSuperview()
        }
        
        idCheckLabel.snp.makeConstraints{make in
            make.top.equalTo(titleStackView.snp.bottom).offset(35)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(55)
        }
        
        returnLoginVCBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
    }
    
    @objc func returnLoginVC(_ sender: UIButton){
        
    }
    
}
