
import UIKit
import SnapKit

class RecordFolderView: UIView{
    
    let folderTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
      
        addSubview(folderTableView)
        
        folderTableView.register(FolderTableViewCell.self, forCellReuseIdentifier: "FolderTableViewCell")
        
    
        folderTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

