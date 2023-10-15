import UIKit
import SnapKit
import Alamofire

//TODO: 나이 입력 checkbox 
class InputPetBirthVC : UIViewController {
    
    let nextCheckCareBtn = CustomNextBtn(title: "다음")
    let birthDatePicker = UIDatePicker()
    let inputPetBirth = UITextField()
    let doneButton = UIButton()
    let progressBar = CustomProgressBar.shared
    let customLabel = ConstomLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        setupDatePicker()
        setupTextField()
        setupTapGestureRecognizer()

        nextCheckCareBtn.addTarget(self, action: #selector(changeCheckCareVC(_:)), for: .touchUpInside)
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
        
        self.view.addSubview(nextCheckCareBtn)
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

        nextCheckCareBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
    }
    func setupDatePicker() {
       // DatePicker 설정
        birthDatePicker.datePickerMode = .date
        birthDatePicker.preferredDatePickerStyle = .wheels
        birthDatePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    func setupTextField() {
        // TextField 설정
        inputPetBirth.placeholder = "생일 입력"
        inputPetBirth.inputView = birthDatePicker
        inputPetBirth.layer.borderWidth = 1
        inputPetBirth.layer.cornerRadius = 5
        inputPetBirth.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        inputPetBirth.font = .systemFont(ofSize:14)
        
        inputPetBirth.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        inputPetBirth.leftViewMode = .always
        
        inputPetBirth.addTarget(self, action: #selector(textFieldEditingDidBegin), for: .editingDidBegin)

        view.addSubview(inputPetBirth)

        // SnapKit을 사용하여 오토 레이아웃 설정
        inputPetBirth.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(255)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
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
            self.progressBar.setProgress(0.8)
        }
    }

    @objc func datePickerValueChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // 원하는 날짜 형식으로 변경
        inputPetBirth.text = dateFormatter.string(from: birthDatePicker.date)
    }
    
    @objc func textFieldEditingDidBegin() {
          // TextField 편집 모드로 들어갈 때 DatePicker를 업데이트
        birthDatePicker.date = Date() // 기본값으로 현재 날짜 설정
    }
    
    func setupTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissDatePicker))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func dismissDatePicker() {
        // 화면을 터치하면 DatePicker를 닫음
        inputPetBirth.resignFirstResponder()
    }
    
    @objc func changeCheckCareVC(_ sender: UIButton){
        let nextVC = CheckCareVC()
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
}
