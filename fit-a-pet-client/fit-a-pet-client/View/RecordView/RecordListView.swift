
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
        
 
        recordListTableView.delegate = self
        recordListTableView.dataSource = self
        
        
        recordListTableView.register(RecordListTableViewCell.self, forCellReuseIdentifier: "RecordListTableViewCell")
        
    
        recordListTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension RecordListView: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordListTableViewCell", for: indexPath) as! RecordListTableViewCell
 
        cell.setTitle("Cell \(indexPath.row + 1)", "2023.04.05", "임시 데이터ㅓㅓㅓㅓㅓㅓㅓㅓㅓ", "parent", "/child")
        
        
        return cell
    }
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}
