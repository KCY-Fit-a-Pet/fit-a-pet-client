//
//  CancellationPopupVC.swift
//  fit-a-pet-client
//
//  Created by 최희진 on 3/1/24.
//

import UIKit

class CancellationPopupVC: UIViewController {

    let popupView = CustomCheckPopupView()
    var userId = 0
    var isCancellation = false

    var dismissalCompletion: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateBtnColor()

        view.backgroundColor = UIColor(white: 0, alpha: 0.5)

        popupView.customButton1.addTarget(self, action: #selector(cancellationButtonTapped(_:)), for: .touchUpInside)
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
    
    func updateBtnColor(){
        if isCancellation{
            popupView.customButton1.backgroundColor = UIColor(named: "Danger")
            popupView.customButton2.layer.borderColor = UIColor(named: "Danger")?.cgColor
            popupView.customButton2.setTitleColor(UIColor(named: "Danger"), for: .normal)
        }
    }

    @objc func cancellationButtonTapped(_ sender: UIButton) {
        
        if isCancellation{
            AuthorizationAlamofire.shared.cancellationManager(SelectedPetId.petId, userId){ [self] result in
                switch result {
                case .success(let data):
                    if let responseData = data,
                       let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                        print("response jsonData: \(jsonObject)")
                        dismiss(animated: true, completion: nil)
                        NotificationCenter.default.post(name: .ManagerCancellationBtnTapped, object: nil)
                    }
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }else{
            AuthorizationAlamofire.shared.managerDelegation(SelectedPetId.petId, userId){ [self] result in
                switch result {
                case .success(let data):
                    if let responseData = data,
                       let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                        print("response jsonData: \(jsonObject)")
                        dismiss(animated: true, completion: nil)
                        NotificationCenter.default.post(name: .ManagerDelegationBtnTapped, object: nil)
                    }
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }

    @objc func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
