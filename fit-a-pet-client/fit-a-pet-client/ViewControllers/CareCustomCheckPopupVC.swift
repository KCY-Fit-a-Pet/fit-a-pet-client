import UIKit

class CareCustomCheckPopupVC: UIViewController {

    let popupView = CustomCheckPopupView()

    var dismissalCompletion: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 0, alpha: 0.5)

        popupView.customButton1.addTarget(self, action: #selector(confirmButtonTapped(_:)), for: .touchUpInside)
        popupView.customButton2.addTarget(self, action: #selector(cancelButtonTapped(_:)), for: .touchUpInside)

        view.addSubview(popupView)

        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(250)
        }
    }
    func updateText(_ title: String, _ sub: String, _ confirm: String, _ cancel: String){
        popupView.titleLabel.text = title
        popupView.subtitleLabel.text = sub
        popupView.customButton1.setTitle(confirm, for: .normal)
        popupView.customButton2.setTitle(cancel, for: .normal)
    }

    @objc func confirmButtonTapped(_ sender: UIButton) {
        AuthorizationAlamofire.shared.petCareComplete(careCompleteData.petId, careCompleteData.careId, careCompleteData.caredateId) { result in
            switch result {
            case .success(let data):
                if let responseData = data {
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] ?? [:]
                        
                        print("Response JSON Data (User Profile): \(jsonObject)")
                        self.dismissalCompletion?()
                    
                    } catch {
                        print("Error parsing user profile JSON: \(error)")
                    }
                }
                
            case .failure(let profileError):
                print("Error fetching user profile info: \(profileError)")
            }
            
        }
        dismiss(animated: true, completion: nil)
    }

    @objc func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

