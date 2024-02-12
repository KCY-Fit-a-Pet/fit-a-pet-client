
import UIKit

class RecordCustomCheckPopupVC: UIViewController {

    let popupView = CustomCheckPopupView()
    var dismissalCompletion: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 0, alpha: 0.5)

        popupView.customButton1.addTarget(self, action: #selector(cancleButtonTapped(_:)), for: .touchUpInside)
        popupView.customButton2.addTarget(self, action: #selector(keepButtonTapped(_:)), for: .touchUpInside)

        view.addSubview(popupView)

        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(250)
        }
    }
    
    func updateText(_ title: String, _ sub: String, _ cancle: String, _ keep: String){
        popupView.titleLabel.text = title
        popupView.subtitleLabel.text = sub
        popupView.customButton1.setTitle(cancle, for: .normal)
        popupView.customButton2.setTitle(keep, for: .normal)
    }

    @objc func cancleButtonTapped(_ sender: UIButton) {
        self.dismissalCompletion?()
        dismiss(animated: true, completion: nil)
    }

    @objc func keepButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

