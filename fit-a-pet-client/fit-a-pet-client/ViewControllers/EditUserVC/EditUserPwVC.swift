import UIKit
import SnapKit

class EditUserPwVC: CustomEditNavigationBar {

    private var currentPasswordTextField = UITextField()
    private var newPasswordTextField = UITextField()
    private var confirmPasswordTextField = UITextField()
    
    private var prePassword = ""
    private var newPassword = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        currentPasswordTextField = createTextField(with: "현재 비밀번호", placeholder: "현재 비밀번호")
        newPasswordTextField = createTextField(with: "새 비밀번호", placeholder: "새 비밀번호")
        confirmPasswordTextField = createTextField(with: "새 비밀번호 확인", placeholder: "비밀번호 재입력")

        let mainStackView = UIStackView(arrangedSubviews: [currentPasswordTextField, newPasswordTextField, confirmPasswordTextField])
        mainStackView.axis = .vertical
        mainStackView.spacing = 16

        view.addSubview(mainStackView)

        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
//
        currentPasswordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        newPasswordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
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
        let allFieldsFilled = !(currentPasswordTextField.text?.isEmpty ?? true) &&
                              !(newPasswordTextField.text?.isEmpty ?? true) &&
                              !(confirmPasswordTextField.text?.isEmpty ?? true)
        
        prePassword = currentPasswordTextField.text!
        newPassword = newPasswordTextField.text!
        
        userPwData = ["prePassword": prePassword, "newPassword": newPassword]
        
        saveButton.tintColor = allFieldsFilled ? UIColor(named: "PrimaryColor") : UIColor(named: "Gray3")
    }
}


