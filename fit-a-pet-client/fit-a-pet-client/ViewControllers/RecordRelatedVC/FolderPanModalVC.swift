
import UIKit
import PanModal
import SnapKit

class FolderPanModalVC: UIViewController {
    
    private lazy var customPanModalView = CustomPanModalView()
    private let folderView = RecordFolderView()
    private let folderTableViewMethod = RecordFolderTableViewMethod()
    let heightForRow:CGFloat = 56
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        folderView.folderTableView.delegate = folderTableViewMethod
        folderView.folderTableView.dataSource = folderTableViewMethod
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatefolderViewHeight()
    }
    
    func initView(){
        view.addSubview(customPanModalView)
        
        customPanModalView.titleText = ""
        customPanModalView.leftTitleText = "전체 폴더"
        
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
        self.dismiss(animated: true, completion: nil)
    }
    
    func updatefolderViewHeight() {
        let totalCellHeight = CGFloat(folderView.folderTableView.numberOfRows(inSection: 0)) * heightForRow
        
        folderView.snp.updateConstraints { make in
            make.height.equalTo(totalCellHeight)
        }
        
    }
}

extension FolderPanModalVC: PanModalPresentable{
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        let totalCellHeight = CGFloat(folderView.folderTableView.numberOfRows(inSection: 0)) * heightForRow
        return .contentHeight(totalCellHeight + 150)
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(40)
    }//유빈님 질문할 거
    
}
