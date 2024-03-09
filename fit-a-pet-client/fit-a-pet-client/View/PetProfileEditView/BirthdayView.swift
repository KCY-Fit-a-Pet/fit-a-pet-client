import UIKit
import SnapKit

class BirthdayView: UIView {

    let totalBirthdayStackView = UIStackView()
    let totalAgeStackView = UIStackView()
    let birthdayStackView = UIStackView()
    let birthdayChangeBtn = UIButton()
    
    private let ageCheckStackView = UIStackView()
    let ageCheckboxButton = UIButton()
    let ageChangeLabel = UILabel()
    
    let ageStackView = UIStackView()
    
    let birthdayLabel = UILabel()
    let selectedBirthdayLabel = UILabel()
    let ageLabel = UITextField()
    let ageInputTextFeild = UITextField()
    let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupAgeStakView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
       
        birthdayLabel.text = "생일"
        birthdayLabel.font = .boldSystemFont(ofSize: 18)
        
        ageLabel.text = "나이"
        ageLabel.font = .boldSystemFont(ofSize: 18)
        
        ageInputTextFeild.text = "0"
        ageInputTextFeild.backgroundColor = UIColor(named: "Gray1")
        
        textLabel.text = "살"
        textLabel.font = .systemFont(ofSize: 14, weight: .regular)
        
        ageInputTextFeild.layer.borderWidth = 1
        ageInputTextFeild.layer.cornerRadius = 8
        ageInputTextFeild.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        ageInputTextFeild.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        ageInputTextFeild.leftViewMode = .always
        
        birthdayStackView.axis = .horizontal
        birthdayStackView.spacing = 8
        birthdayStackView.distribution = .equalSpacing
        birthdayStackView.layer.borderWidth = 1
        birthdayStackView.layer.cornerRadius = 8
        birthdayStackView.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        birthdayStackView.addArrangedSubview(selectedBirthdayLabel)
        birthdayStackView.addArrangedSubview(birthdayChangeBtn)
        
        ageStackView.axis = .horizontal
        ageStackView.spacing = 8
        ageStackView.distribution = .equalSpacing
        ageStackView.addArrangedSubview(ageInputTextFeild)
        ageStackView.addArrangedSubview(textLabel)

        selectedBirthdayLabel.font = .systemFont(ofSize: 14)
        
        let formattedDate = DateFormatterUtils.formatDateString(DateFormatterUtils.dateFormatter.string(from: Date()))
        
        selectedBirthdayLabel.text =  DateFormatterUtils.formatFullDate(formattedDate!, from: "yyyy-MM-dd HH:mm:ss", to: "yyyy.MM.dd (E)")

        birthdayChangeBtn.setImage(UIImage(named: "calendar"), for: .normal)
        birthdayChangeBtn.isEnabled = false
        
        totalBirthdayStackView.axis = .vertical
        totalBirthdayStackView.spacing = 8
        totalBirthdayStackView.addArrangedSubview(birthdayLabel)
        totalBirthdayStackView.addArrangedSubview(birthdayStackView)

        totalAgeStackView.axis = .vertical
        totalAgeStackView.spacing = 8
        totalAgeStackView.addArrangedSubview(ageLabel)
        totalAgeStackView.addArrangedSubview(ageStackView)

        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.addArrangedSubview(totalBirthdayStackView)
        horizontalStackView.addArrangedSubview(totalAgeStackView)
        horizontalStackView.spacing = 10

    
        self.addSubview(horizontalStackView)

        birthdayLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
        }

        birthdayStackView.snp.makeConstraints{make in
            make.height.equalTo(56)
        }
        
        selectedBirthdayLabel.snp.makeConstraints{make in
            make.leading.equalToSuperview().inset(16)
        }
        
        birthdayChangeBtn.snp.makeConstraints{make in
            make.width.equalTo(50)
        }
        
        ageStackView.snp.makeConstraints{make in
            make.height.equalTo(56)
        }
        ageInputTextFeild.snp.makeConstraints{make in
            make.width.height.equalTo(56)
        }

        horizontalStackView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
        }
        
    }
    
    private func setupAgeStakView(){
        ageCheckStackView.axis = .horizontal
        ageCheckStackView.spacing = 0
        ageCheckStackView.alignment = .center
        ageCheckStackView.distribution = .fillProportionally
        
        ageChangeLabel.text = "나이로 입력하기"
        ageChangeLabel.font = UIFont.systemFont(ofSize: 14)
        
        let checkedImage = UIImage(systemName: "checkmark.square.fill")
        let uncheckedImage = UIImage(systemName: "square")

        ageCheckboxButton.setImage(uncheckedImage, for: .normal)
        ageCheckboxButton.setImage(checkedImage, for: .selected)
        
        ageCheckboxButton.tintColor = UIColor(named: "Gray4")
        ageCheckStackView.addArrangedSubview(ageCheckboxButton)
        ageCheckStackView.addArrangedSubview(ageChangeLabel)
        
        ageCheckboxButton.isSelected = false
        
        self.addSubview(ageCheckStackView)
        
        ageCheckStackView.snp.makeConstraints{make in
            make.top.equalTo(totalBirthdayStackView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
        }
        
        ageCheckboxButton.snp.makeConstraints{make in
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        ageChangeLabel.snp.makeConstraints{make in
            make.height.equalTo(30)
        }
    }
    
    func updateCheckboxColor(){
        if ageCheckboxButton.isSelected{
            ageCheckboxButton.tintColor = UIColor(named: "PrimaryColor")
            ageInputTextFeild.isEnabled = true
            birthdayStackView.backgroundColor = UIColor(named: "Gray1")
            ageInputTextFeild.backgroundColor = UIColor.clear
        }else {
            ageCheckboxButton.tintColor = UIColor(named: "Gray4")
            ageInputTextFeild.isEnabled = false
            birthdayStackView.backgroundColor = UIColor.clear
            ageInputTextFeild.backgroundColor = UIColor(named: "Gray1")
        }
    }
}

