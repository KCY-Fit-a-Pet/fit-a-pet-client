import UIKit
import SnapKit
import PanModal

//class MainVC: UIViewController{
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = UIColor(named: "PrimaryColor")
//    }
//}
class MainVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = UIColor(named: "PrimaryColor")
        
        let showModalButton = UIButton(type: .system)
        showModalButton.setTitle("Show Modal", for: .normal)
        showModalButton.tintColor = .black
        showModalButton.addTarget(self, action: #selector(showModal), for: .touchUpInside)
        view.addSubview(showModalButton)
        
        showModalButton.snp.makeConstraints{ make in
            // 세로 중앙 정렬
            make.centerY.equalTo(view.snp.centerY)
            // 가로 중앙 정렬
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(50)
            make.width.equalTo(350)
        }
    }
    
    @objc func showModal() {
        let modalViewController = ModalViewController()

           self.presentPanModal(modalViewController)
    }
}

class ModalViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

    }

}
extension ModalViewController: PanModalPresentable {

    // 스크롤되는 tableview 나 collectionview 가 있다면 여기에 넣어주면 PanModal 이 모달과 스크롤 뷰 사이에서 팬 제스처를 원활하게 전환합니다.
    var panScrollable: UIScrollView? {
        return nil
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(280)
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(0)
    }
}


