import UIKit

class CustomPopupViewController: UIViewController {

    let popupView = CustomPopupView()
    var messageText: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        popupView.messageLabel.text = messageText
        popupView.closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)

        view.addSubview(popupView)

        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(240)
            make.height.equalTo(160)
        }
    }

    @objc func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

