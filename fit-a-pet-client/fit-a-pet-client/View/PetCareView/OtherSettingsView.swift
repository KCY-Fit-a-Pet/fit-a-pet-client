import UIKit
import SnapKit

class OtherSettingsView: UIView {
    
    let otherSettingLabel = UILabel()
    let carePetLabel = UILabel()
    let carePetButton = UIButton()
    let timeAttackLabel = UILabel()
    let timeAttackButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        
        self.addSubview(otherSettingLabel)
        otherSettingLabel.text = "기타설정"
        otherSettingLabel.font = .boldSystemFont(ofSize: 18)
        
        otherSettingLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.top.equalTo(self.snp.top).offset(10)
        }
        
        let carePetStackView = UIStackView()
        carePetStackView.axis = .horizontal
        carePetStackView.spacing = 8
        carePetStackView.distribution = .equalSpacing

        carePetLabel.text = "케어 동물 추가"
        carePetLabel.font = .boldSystemFont(ofSize: 16)
        carePetStackView.addArrangedSubview(carePetLabel)

        carePetButton.setImage(UIImage(named: "right_icon"), for: .normal)
        carePetStackView.addArrangedSubview(carePetButton)

        addSubview(carePetStackView)
        carePetStackView.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.top.equalTo(otherSettingLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview()
        }

        let timeAttackStackView = UIStackView()
        timeAttackStackView.axis = .horizontal
        timeAttackStackView.spacing = 8
        timeAttackStackView.distribution = .equalSpacing

        timeAttackLabel.text = "시간 제한"
        timeAttackLabel.font = .boldSystemFont(ofSize: 16)
        timeAttackStackView.addArrangedSubview(timeAttackLabel)

        timeAttackButton.setImage(UIImage(named: "right_icon"), for: .normal)
        timeAttackStackView.addArrangedSubview(timeAttackButton)

        addSubview(timeAttackStackView)
        timeAttackStackView.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.top.equalTo(carePetStackView.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview()
        }
    }
}

