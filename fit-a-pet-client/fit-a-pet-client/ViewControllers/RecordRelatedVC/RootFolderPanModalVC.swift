import UIKit
import PanModal
import SnapKit

class RootFolderPanModalVC: UIViewController {
    
    private lazy var customPanModalView = CustomPanModalView()
    private let folderView = RecordFolderView()
    private let folderTableViewMethod = RecordFolderTableViewMethod()
    let heightForRow:CGFloat = 56
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        folderView.folderTableView.delegate = folderTableViewMethod
        folderView.folderTableView.dataSource = folderTableViewMethod
        
        customPanModalView.closeButtonAction = {
            self.closeButtonTapped()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCellSelectionNotification(_:)), name: .cellSelectedFolder, object: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatefolderViewHeight()
    }
    
    func initView(){
        view.addSubview(customPanModalView)
        
        customPanModalView.titleText = "반려동물 선택"
        customPanModalView.leftTitleText = ""
        
        customPanModalView.closeButtonAction = {
            self.dismiss(animated: true, completion: nil)
        }
        
        customPanModalView.snp.makeConstraints{make in
            make.edges.equalToSuperview()
        }
        
        customPanModalView.contentView.addSubview(folderView)
        folderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    @objc func closeButtonTapped() {
        NotificationCenter.default.removeObserver(self, name: .cellSelectedFolder, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func updatefolderViewHeight() {
        let totalCellHeight = CGFloat(folderView.folderTableView.numberOfRows(inSection: 0)) * heightForRow
        
        folderView.snp.updateConstraints { make in
            make.height.equalTo(totalCellHeight)
        }
    }
    
    @objc func handleCellSelectionNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any],
              let memoCategoryId = userInfo["memoCategoryId"] as? Int,
              let memoCategoryName = userInfo["memoCategoryName"] as? String,
              let petId = userInfo["petId"] as? Int,
              let petName = userInfo["petName"] as? String
        else {
            return
        }
        print("Selected memoCategoryId: \(memoCategoryId), memoCategoryName: \(memoCategoryName), petId: \(petId), petName: \(petName)")
        
        NotificationCenter.default.removeObserver(self, name: .cellSelectedFolder, object: nil)
        NotificationCenter.default.post(name: .cellSelectedFromRootFolderPanModal, object: nil, userInfo: userInfo)

        self.dismiss(animated: true, completion: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension RootFolderPanModalVC: PanModalPresentable{
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        let totalCellHeight = CGFloat(folderView.folderTableView.numberOfRows(inSection: 0)) * heightForRow
        return .contentHeight(totalCellHeight + 150)
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(40)
    }
}
