// CategoryView.swift

import UIKit
import SnapKit

class CategoryView: UIView {
    let categoryButton = UIButton()
    let categoryLabel = UILabel()
    let categoryTextField = UITextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = 8
        stackView.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        stackView.addArrangedSubview(categoryTextField)
        stackView.addArrangedSubview(categoryButton)

        categoryTextField.placeholder = "카테고리 설정"
        categoryTextField.font = .systemFont(ofSize: 14)
        categoryTextField.isUserInteractionEnabled = false//입력 못하도록
        categoryTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        categoryTextField.leftViewMode = .always

        categoryButton.setImage(UIImage(named: "category"), for: .normal)

        categoryLabel.text = "카테고리"
        categoryLabel.font = .boldSystemFont(ofSize: 18)

        self.addSubview(categoryLabel)
        self.addSubview(stackView)

        categoryLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.top.equalTo(self.snp.top).offset(8)
        }

        stackView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.top.equalTo(categoryLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
    }
}


