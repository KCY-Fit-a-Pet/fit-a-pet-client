
import UIKit

class RecordFolderTableViewMethod: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderTableViewCell", for: indexPath) as! FolderTableViewCell
 
        cell.setTitle("Cell \(indexPath.row + 1)", "(123)")
        
        
        return cell
    }
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}

class RecordListTableViewMethod: NSObject, UITableViewDataSource, UITableViewDelegate {
    
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
