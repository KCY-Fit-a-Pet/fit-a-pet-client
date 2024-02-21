import UIKit

class CustomCheckPopupView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()

    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(named: "Gray5")
        label.numberOfLines = 1
        return label
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()

    let customButton1: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "PrimaryColor")
        button.layer.cornerRadius = 8
        return button
    }()

    let customButton2: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor(named: "PrimaryColor"), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        
        addSubview(stackView)
        addSubview(customButton1)
        addSubview(customButton2)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }

        customButton1.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(56)
        }

        customButton2.snp.makeConstraints { make in
            make.top.equalTo(customButton1.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(56)
        }
    }

}

