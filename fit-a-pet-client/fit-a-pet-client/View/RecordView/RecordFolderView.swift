
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
        
 
        folderTableView.delegate = self
        folderTableView.dataSource = self
        
        
        folderTableView.register(FolderTableViewCell.self, forCellReuseIdentifier: "FolderTableViewCell")
        
    
        folderTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension RecordFolderView: UITableViewDataSource, UITableViewDelegate {
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderTableViewCell", for: indexPath) as! FolderTableViewCell
 
        cell.setTitle("Cell \(indexPath.row + 1)")
        
        return cell
    }
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
