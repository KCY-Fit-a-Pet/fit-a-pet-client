
import UIKit
import SnapKit

class GenderView: UIView {
    let genderChangeBtn = UIButton()
    let genderLabel = UILabel()
    let selectedGenderLabel = UILabel()
    private let genderStackView = UIStackView()
    
    let neuteringCheckboxButton = UIButton()
    let neuteringCheckLabel = UILabel()
    private let neuteringStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGenderStackView()
        setupNeuteringStakView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }

    func setupGenderStackView() {
        genderStackView.axis = .horizontal
        genderStackView.spacing = 8
        genderStackView.distribution = .equalSpacing
        genderStackView.layer.borderWidth = 1
        genderStackView.layer.cornerRadius = 8
        genderStackView.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        genderStackView.addArrangedSubview(selectedGenderLabel)
        genderStackView.addArrangedSubview(genderChangeBtn)

        selectedGenderLabel.font = .systemFont(ofSize: 14)
        selectedGenderLabel.text = "수컷"

        genderChangeBtn.setImage(UIImage(named: "category"), for: .normal)

        genderLabel.text = "성별"
        genderLabel.font = .boldSystemFont(ofSize: 18)

        self.addSubview(genderLabel)
        self.addSubview(genderStackView)
     

        genderLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.top.equalTo(self.snp.top).offset(8)
        }
        
        selectedGenderLabel.snp.makeConstraints{make in
            make.leading.equalToSuperview().inset(16)
        }

        genderStackView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.top.equalTo(genderLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupNeuteringStakView(){
        neuteringStackView.axis = .horizontal
        neuteringStackView.spacing = 3
        neuteringStackView.alignment = .center
        neuteringStackView.distribution = .fillProportionally
        
        neuteringCheckLabel.text = "중성화"
        neuteringCheckLabel.font = UIFont.systemFont(ofSize: 14)
        
        neuteringCheckboxButton.isSelected = false
        
        let checkedImage = UIImage(systemName: "checkmark.square.fill")
        let uncheckedImage = UIImage(systemName: "square")

        neuteringCheckboxButton.setImage(uncheckedImage, for: .normal)
        neuteringCheckboxButton.setImage(checkedImage, for: .selected)
        
        neuteringCheckboxButton.tintColor = UIColor(named: "Gray4")
        
        neuteringStackView.addArrangedSubview(neuteringCheckboxButton)
        neuteringStackView.addArrangedSubview(neuteringCheckLabel)
        
        self.addSubview(neuteringStackView)
        
        neuteringStackView.snp.makeConstraints{make in
            make.top.equalTo(genderStackView.snp.bottom).offset(5)
            make.leading.equalToSuperview()
        }
        
        neuteringCheckboxButton.snp.makeConstraints{make in
            make.height.equalTo(22)
            make.width.equalTo(22)
        }
        neuteringCheckLabel.snp.makeConstraints{make in
            make.height.equalTo(30)
        }
    }
    func updateCheckboxColor(){
        if neuteringCheckboxButton.isSelected{
            neuteringCheckboxButton.tintColor = UIColor(named: "PrimaryColor")
        }else {
            neuteringCheckboxButton.tintColor = UIColor(named: "Gray4")
        }
    }
}


