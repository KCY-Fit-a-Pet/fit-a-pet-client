
import UIKit
import PanModal
import SnapKit

class FolderPanModalVC: UIViewController {
    
    private lazy var customPanModalView = CustomPanModalView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(customPanModalView)
        
        customPanModalView.snp.makeConstraints{make in
            make.edges.equalToSuperview()
        }
        customPanModalView.titleText = "Modal Title"
        customPanModalView.buttonText = "Close"
        
        customPanModalView.closeButtonAction = {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension FolderPanModalVC: PanModalPresentable{
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(300)
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(40)
    }
    
}
