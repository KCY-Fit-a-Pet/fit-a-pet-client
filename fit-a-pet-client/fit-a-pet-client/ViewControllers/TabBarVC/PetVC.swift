

import UIKit
import SnapKit

class PetVC: UIViewController{
    
    let nextBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextBtn.setTitle("Next Screen", for: .normal)
        nextBtn.backgroundColor = .blue
        nextBtn.addTarget(self, action: #selector(nextScreenButtonTapped), for: .touchUpInside)
        
        view.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
    }
    @objc func nextScreenButtonTapped() {
        let nextVC = PetCareRegistVC(title: "care 등록")
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
