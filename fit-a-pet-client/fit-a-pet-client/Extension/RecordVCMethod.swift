
import UIKit

class RecordTotalFolderTableViewMethod: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let folderData = RecordTotalFolderManager.shared.categoryData
    private let petData = PetDataManager.summaryPets
    
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
                cell.folderLabel.font = .systemFont(ofSize: 14, weight: .regular)
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
            
            for pet in petData{
                if pet.id == memoCategory.petId{
                    let userInfo: [AnyHashable: Any] = ["memoCategoryId": memoCategory.memoCategoryId, "memoCategoryName": memoCategory.memoCategoryName, "petName": pet.petName, "type": memoCategory.type, "petId": pet.id]
                    NotificationCenter.default.post(name: .cellSelectedNotification, object: nil, userInfo: userInfo)
                }
            }
        }
    }
}

class RecordFolderTableViewMethod: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let folderData = RecordTotalFolderManager.shared.categoryData
    private let petData = PetDataManager.summaryPets
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var totalCount = 0
        
        for (_, categories) in folderData {
            for category in categories {
                if category.type == "ROOT" {
                    totalCount += 1
                }
            }
        }
        
        return totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FolderTableViewCell", for: indexPath) as! FolderTableViewCell
        
        var allCategories: [MemoCategory] = []
        for (_, categories) in folderData {
            for category in categories {
                if category.type == "ROOT" {
                    allCategories.append(category)
                }
            }
        }
        let adjustedIndex = indexPath.row
        
        if adjustedIndex < allCategories.count {
            let memoCategory = allCategories[adjustedIndex]
            let title = memoCategory.memoCategoryName
            cell.setTitle(title, "(\(memoCategory.totalMemoCount))")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    // MARK: - UITableViewDelegate methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        var allCategories: [MemoCategory] = []
        for (_, categories) in folderData {
            for category in categories {
                if category.type == "ROOT"{
                    allCategories.append(category)
                }
            }
        }
        
        let adjustedIndex = indexPath.row
        
        if adjustedIndex < allCategories.count {
            let memoCategory = allCategories[adjustedIndex]
            
            for pet in petData{
                if pet.id == memoCategory.petId{
                    let userInfo: [AnyHashable: Any] = ["memoCategoryId": memoCategory.memoCategoryId, "memoCategoryName": memoCategory.memoCategoryName, "petId": pet.id]
                    NotificationCenter.default.post(name: .cellSelectedNotification, object: nil, userInfo: userInfo)
                }
            }
        }
    }
}



class RecordListTableViewMethod: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private var recordData: [Memo] {
        return RecordDataListManager.shared.recordData
    }
    
    // MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordListTableViewCell", for: indexPath) as! RecordListTableViewCell
        let data = recordData[indexPath.row]
        cell.setTitle(data.title, data.createdAt, data.content, data.categorySuffix, "/child")


       // let data = recordData[indexPath.row]
//            cell.setTitle(title, "(\(memoCategory.totalMemoCount))")
//
        
        return cell
    }
    
    // MARK: - UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}
