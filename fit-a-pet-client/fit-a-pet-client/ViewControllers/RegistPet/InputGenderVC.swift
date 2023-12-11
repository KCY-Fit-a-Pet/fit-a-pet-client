
import UIKit
import SnapKit
import Alamofire

class InputGenderVC: CustomNavigationBar {
    
    private let nextBirthBtn = CustomNextBtn(title: "다음")
    private let genderStackView = UIStackView()
    private let femaleBtn = UIButton()
    private let maleBtn = UIButton()
    
    private let neuteringStackView = UIStackView()
    private let neuteringCheckboxButton = UIButton()
    private let neuteringCheckLabel = UILabel()
    private let progressBar = CustomProgressBar.shared
    private let customLabel = ConstomLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        setupGenderStackView()
        setupNeuteringStakView()
        //checkboxBtn()

        nextBirthBtn.addTarget(self, action: #selector(changeInputPetBirthVC(_:)), for: .touchUpInside)
    }
    private func initView(){
        
        self.view.addSubview(nextBirthBtn)
        self.view.addSubview(customLabel)
        
        view.backgroundColor = .white
        
        let text = "반려동물의\n성별을 선택해주세요."
        let range = "성별"

        customLabel.setAttributedText(text, range)
        
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
    private func setupGenderStackView() {
        
        genderStackView.axis = .horizontal
        genderStackView.spacing = 20
        genderStackView.alignment = .center
        genderStackView.distribution = .fillEqually

        femaleBtn.setTitle("암컷", for: .normal)
        maleBtn.setTitle("수컷", for: .normal)

        femaleBtn.setTitleColor(UIColor(named: "Gray5"), for: .normal)
        maleBtn.setTitleColor(UIColor(named: "Gray5"), for: .normal)
    
        femaleBtn.layer.borderWidth = 1
        femaleBtn.layer.cornerRadius = 5
        femaleBtn.layer.borderColor = UIColor(named: "Gray3")?.cgColor
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
    
    private func setupNeuteringStakView(){
        neuteringStackView.axis = .horizontal
        neuteringStackView.spacing = 0
        neuteringStackView.alignment = .center
        neuteringStackView.distribution = .fillProportionally
        
        neuteringCheckLabel.text = "중성화를 완료했어요"
        neuteringCheckLabel.font = UIFont.systemFont(ofSize: 14)
        
        neuteringCheckboxButton.isSelected = false
        
        let checkedImage = UIImage(systemName: "checkmark.square.fill")
        let uncheckedImage = UIImage(systemName: "square")

        neuteringCheckboxButton.setImage(uncheckedImage, for: .normal)
        neuteringCheckboxButton.setImage(checkedImage, for: .selected)
        
        neuteringCheckboxButton.tintColor = UIColor(named: "Gray9")
        neuteringCheckboxButton.addTarget(self, action: #selector(checkboxButtonTapped(_:)), for: .touchUpInside)
        
        neuteringStackView.addArrangedSubview(neuteringCheckboxButton)
        neuteringStackView.addArrangedSubview(neuteringCheckLabel)
        
        view.addSubview(neuteringStackView)
        
        neuteringStackView.snp.makeConstraints{make in
            make.top.equalTo(genderStackView.snp.bottom).offset(20)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
        neuteringCheckboxButton.snp.makeConstraints{make in
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        neuteringCheckLabel.snp.makeConstraints{make in
            make.height.equalTo(30)
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
    
    private func updateButtonColors() {
       if femaleBtn.isSelected {
           maleBtn.layer.borderColor = UIColor(named: "Gray3")?.cgColor
           maleBtn.backgroundColor = .white
           femaleBtn.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
           femaleBtn.backgroundColor = UIColor(named: "Secondary")
           PetRegistrationManager.shared.addInput(gender: "FEMALE")
       } else if maleBtn.isSelected {
           femaleBtn.layer.borderColor = UIColor(named: "Gray3")?.cgColor
           femaleBtn.backgroundColor = .white
           maleBtn.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
           maleBtn.backgroundColor = UIColor(named: "Secondary")
           PetRegistrationManager.shared.addInput(gender: "MALE")
       }
    }
    
    @objc func checkboxButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        updateCheckboxColor()
    }
    
    private func updateCheckboxColor(){
        if neuteringCheckboxButton.isSelected{
            neuteringCheckboxButton.tintColor = UIColor(named: "PrimaryColor")
            PetRegistrationManager.shared.addInput(neutralization: true)
        }else {
            neuteringCheckboxButton.tintColor = UIColor(named: "Gray9")
            PetRegistrationManager.shared.addInput(neutralization: false)
        }
    }
    
    @objc func changeInputPetBirthVC(_ sender: UIButton){
        let nextVC = InputPetBirthVC(title: "반려동물 등록하기")
        
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    
}


