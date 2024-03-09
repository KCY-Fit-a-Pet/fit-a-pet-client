
import UIKit
import SnapKit

class CustomTableView: UIView{
    
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
      
        addSubview(tableView)
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
    
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

