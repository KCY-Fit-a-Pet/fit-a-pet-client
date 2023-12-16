import UIKit
import SnapKit

class EditUserNameVC: CustomEditNavigationBar {

    private var currentUserNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        currentUserNameTextField = createTextField(with: "이름", placeholder: "이름")

        let mainStackView = UIStackView(arrangedSubviews: [currentUserNameTextField])
        mainStackView.axis = .vertical
        mainStackView.spacing = 16

        view.addSubview(mainStackView)

        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        currentUserNameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    private func createTextField(with labelText: String, placeholder: String) -> UITextField {
        let label = UILabel()
        label.text = labelText
        label.font = .boldSystemFont(ofSize: 18)

        let textField = UITextField()
        textField.font = .systemFont(ofSize: 14)
        textField.placeholder = placeholder
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8.0, height: 0.0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect

        textField.snp.makeConstraints { make in
            make.height.equalTo(56)
        }

        let stackView = UIStackView(arrangedSubviews: [label, textField])
        stackView.axis = .vertical
        stackView.spacing = 8

        view.addSubview(stackView)

        return textField
    }

    @objc private func textFieldDidChange() {
        let fieldsFilled = !(currentUserNameTextField.text?.isEmpty ?? true)
        userName = currentUserNameTextField.text!
        saveButton.tintColor = fieldsFilled ? UIColor(named: "PrimaryColor") : UIColor(named: "Gray3")
    }
}


