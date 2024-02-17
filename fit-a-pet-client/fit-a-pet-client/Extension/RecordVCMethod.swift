
import UIKit

class RecordFolderTableViewMethod: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let folderData = RecordTotalFolderManager.shared.categoryData
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var totalCount = 0
        
        for (_, categories) in folderData {
            for category in categories {
                if category.type == "ROOT" || category.type == "SUB" {
                    totalCount += 1
                    if let subCategories = category.subCategories, !subCategories.isEmpty {
                        totalCount += subCategories.count
                    }
                }
            }
        }
        
        return totalCount + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderTableViewCell", for: indexPath) as! FolderTableViewCell
        
        // indexPath가 0일 때 "전체보기" 항목을 설정
        if indexPath.row == 0 {
            cell.setTitle("전체보기", "")
            return cell
        }
        
        // "전체보기" 항목을 제외한 나머지 항목들에 대한 처리
        var allCategories: [MemoCategory] = []
        for (_, categories) in folderData {
            for category in categories {
                if category.type == "ROOT" || category.type == "SUB" {
                    allCategories.append(category)
                    if let subCategories = category.subCategories, !subCategories.isEmpty {
                        allCategories.append(contentsOf: subCategories)
                    }
                }
            }
        }
        
        // "전체보기" 항목을 포함하여 indexPath 조정
        let adjustedIndex = indexPath.row - 1
        
        if adjustedIndex < allCategories.count {
            let memoCategory = allCategories[adjustedIndex]
            var title = memoCategory.memoCategoryName
            if memoCategory.type == "SUB" {
                title = "  /" + title
                cell.folderLabel.font = .systemFont(ofSize: 14, weight: .medium)
            }
            cell.setTitle(title, "(\(memoCategory.totalMemoCount))")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    // MARK: - UITableViewDelegate methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != 0 else {
            print("Selected memoCategoryId: 전체")
            NotificationCenter.default.post(name: .cellSelectedNotification, object: 00)
            return
        }
        
        var allCategories: [MemoCategory] = []
        for (_, categories) in folderData {
            for category in categories {
                if category.type == "ROOT" || category.type == "SUB" {
                    allCategories.append(category)
                    if let subCategories = category.subCategories, !subCategories.isEmpty {
                        allCategories.append(contentsOf: subCategories)
                    }
                }
            }
        }
        
        let adjustedIndex = indexPath.row - 1
        
        if adjustedIndex < allCategories.count {
            let memoCategory = allCategories[adjustedIndex]
            print("Selected memoCategoryId: \(memoCategory.memoCategoryId)")
            NotificationCenter.default.post(name: .cellSelectedNotification, object: memoCategory.memoCategoryId)
        }
    }
}
extension Notification.Name {
    static let cellSelectedNotification = Notification.Name("CellSelectedNotification")
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
