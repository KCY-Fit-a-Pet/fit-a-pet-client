
import UIKit

struct MemoCategory {
    let petId: Int
    let memoCategoryId: Int
    let memoCategoryName: String
    let totalMemoCount: Int
    let type: String
    var subCategories: [MemoCategory]?
}

class RecordTotalFolderManager {
    static let shared = RecordTotalFolderManager()
    
    var categoryData: [String: [MemoCategory]] = [:]
    
    private init() {}
    
    func updateCategoryData(categoryName: String, newData: [MemoCategory]) {
        categoryData[categoryName] = newData
    }
    
//    func getCategoryData(for categoryName: String) -> [MemoCategory]? {
//        return categoryData[categoryName]
//    }
//
//    func getAllCategoryData() -> [String: [MemoCategory]] {
//        return categoryData
//    }
    
    func clearAllData() {
        categoryData.removeAll()
    }
}
