
import UIKit
import SnapKit

class RecordListView: UIView{
    
    let recordListTableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
      
        addSubview(recordListTableView)
        
        recordListTableView.register(RecordListTableViewCell.self, forCellReuseIdentifier: "RecordListTableViewCell")
        recordListTableView.isScrollEnabled = false
        
        recordListTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
