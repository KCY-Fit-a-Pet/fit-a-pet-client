import UIKit
import SnapKit
import Alamofire

class InputPetNameVC : UIViewController {
    
    let nextGenderBtn = CustomNextBtn(title: "다음")
    let inputPetName = UITextField()
    let progressBar = CustomProgressBar.shared
    let customLabel = ConstomLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()

        nextGenderBtn.addTarget(self, action: #selector(changeInputGenderVC(_:)), for: .touchUpInside)
    }
    private func initView(){
        
        //titleView 만들기
        let titleLabel = UILabel()
        titleLabel.text = "반려동물 등록하기"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        titleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: titleLabel.frame.width, height: titleLabel.frame.height))
        titleView.addSubview(titleLabel)
    
        self.navigationItem.titleView = titleView
        
        self.view.addSubview(nextGenderBtn)
        self.view.addSubview(inputPetName)
        self.view.addSubview(customLabel)
        
        view.backgroundColor = .white
        
        let text = "반려동물의\n이름을 알려주세요."
        let attributedText = NSMutableAttributedString(string: text)

        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        let range = (text as NSString).range(of: "이름")

        attributedText.addAttribute(.font, value: boldFont, range: range)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineSpacing = 8
        
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))

        customLabel.setAttributedText(attributedText)
        
        customLabel.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(164)
            make.left.equalTo(view.snp.left).offset(16)

        }
        
        inputPetName.delegate = self
        inputPetName.layer.borderWidth = 1
        inputPetName.layer.cornerRadius = 5
        inputPetName.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        inputPetName.placeholder = "반려동물 이름"
        inputPetName.font = .systemFont(ofSize:14)
        
        inputPetName.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        inputPetName.leftViewMode = .always
        
        inputPetName.snp.makeConstraints{make in
            make.height.equalTo(55)
            make.top.equalTo(view.snp.top).offset(255)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }

        nextGenderBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
    }
    private func progressBarInit(){
        self.view.addSubview(progressBar)
        progressBar.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(100)
            make.height.equalTo(5)
            make.left.equalTo(view.snp.left).offset(0)
            make.right.equalTo(view.snp.right).offset(0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = " "
        
        progressBarInit()
        UIView.animate(withDuration: 0.5) {
            self.progressBar.setProgress(0.4)
        }
    }
    
    @objc func changeInputGenderVC(_ sender: UIButton){
        let nextVC = InputGenderVC()
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    
}

extension InputPetNameVC: UITextFieldDelegate{
    // 입력값이 변경되면 버튼의 색상을 업데이트
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let updatedText = (inputPetName.text! as NSString).replacingCharacters(in: range, with: string)
        nextGenderBtn.updateButtonColor(updatedText, false)
    
        if updatedText.isEmpty{
            inputPetName.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        }else{
            inputPetName.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        }

        return true
    }
}

