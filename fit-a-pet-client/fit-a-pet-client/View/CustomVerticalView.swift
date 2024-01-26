import UIKit
import SnapKit

class CustomVerticalView: UIView {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()

    var textInputField =  UITextField()

    init(labelText: String, placeholder: String ) {
        super.init(frame: .zero)
        titleLabel.text = labelText
        textInputField.placeholder = placeholder
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(titleLabel)
        addSubview(textInputField)
        
        textInputField.font = .systemFont(ofSize: 14)
        textInputField.layer.borderWidth = 1
        textInputField.layer.cornerRadius = 8
        textInputField.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        textInputField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        textInputField.leftViewMode = .always

        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.top.equalTo(self.snp.top).offset(10)
        }
        
        textInputField.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
    }
}

