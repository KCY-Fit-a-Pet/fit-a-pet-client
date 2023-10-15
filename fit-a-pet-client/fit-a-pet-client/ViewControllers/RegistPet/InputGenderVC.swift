
import UIKit
import SnapKit
import Alamofire

//TODO: checkbox 추가 
class InputGenderVC : UIViewController {
    
    let nextBirthBtn = CustomNextBtn(title: "다음")
    let genderStackView = UIStackView()
    let femaleBtn = UIButton()
    let maleBtn = UIButton()
    let progressBar = CustomProgressBar.shared
    let customLabel = ConstomLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        setupStackView()

        nextBirthBtn.addTarget(self, action: #selector(changeInputPetBirthVC(_:)), for: .touchUpInside)
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
        
        self.view.addSubview(nextBirthBtn)
        self.view.addSubview(customLabel)
        
        view.backgroundColor = .white
        
        let text = "반려동물의\n성별을 선택해주세요."
        let attributedText = NSMutableAttributedString(string: text)

        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        let range = (text as NSString).range(of: "성별")

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

        nextBirthBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
    }
    func setupStackView() {
        
        genderStackView.axis = .horizontal
        genderStackView.spacing = 20
        genderStackView.alignment = .center
        genderStackView.distribution = .fillEqually

        femaleBtn.setTitle("암컷", for: .normal)
        maleBtn.setTitle("수컷", for: .normal)

        femaleBtn.setTitleColor(UIColor(named: "Gray6"), for: .normal)
        maleBtn.setTitleColor(UIColor(named: "Gray6"), for: .normal)
    
        femaleBtn.layer.borderWidth = 1
        femaleBtn.layer.cornerRadius = 5
        femaleBtn.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        femaleBtn.backgroundColor = .white
        femaleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        maleBtn.layer.borderWidth = 1
        maleBtn.layer.cornerRadius = 5
        maleBtn.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        maleBtn.backgroundColor = UIColor(named: "Secondary")
        maleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)

        femaleBtn.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
        maleBtn.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)

        genderStackView.addArrangedSubview(femaleBtn)
        genderStackView.addArrangedSubview(maleBtn)
        
        view.addSubview(genderStackView)
        
        genderStackView.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(255)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
        femaleBtn.snp.makeConstraints{make in
            make.height.equalTo(55)
        }
        maleBtn.snp.makeConstraints{make in
            make.height.equalTo(55)
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
            self.progressBar.setProgress(0.6)
        }
    }
    
    @objc func radioButtonTapped(_ sender: UIButton) {
       // Handle radio button selection
       if sender == femaleBtn {
           femaleBtn.isSelected = true
           maleBtn.isSelected = false
       } else if sender == maleBtn {
           femaleBtn.isSelected = false
           maleBtn.isSelected = true
       }
        
        updateButtonColors()
        print("female: \(femaleBtn.isSelected)")
        print("male: \(maleBtn.isSelected)")
    }
    
    func updateButtonColors() {
       if femaleBtn.isSelected {
           maleBtn.layer.borderColor = UIColor(named: "Gray2")?.cgColor
           maleBtn.backgroundColor = .white
           femaleBtn.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
           femaleBtn.backgroundColor = UIColor(named: "Secondary")
       } else if maleBtn.isSelected {
           femaleBtn.layer.borderColor = UIColor(named: "Gray2")?.cgColor
           femaleBtn.backgroundColor = .white
           maleBtn.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
           maleBtn.backgroundColor = UIColor(named: "Secondary")
       }
    }
    
    @objc func changeInputPetBirthVC(_ sender: UIButton){
        let nextVC = InputPetBirthVC()
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    
}


