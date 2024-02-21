//
//  RecordDataListManager.swift
//  fit-a-pet-client
//
//  Created by 최희진 on 2024/02/20.
//

import Foundation

struct MemoImage {
    let imgUrl: String
    let memoImageId: Int
}

struct Memo {
    let categorySuffix: String
    let content: String
    let createdAt: String
    let memoId: Int
    let memoImage: MemoImage? 
    let title: String
}

//struct PageType {
//    let currentPageNumber: Int
//    let hasNext: Int
//    let numberOfElements: Int
//    let pageSize: Int
//}

class RecordDataListManager {
    static let shared = RecordDataListManager()
    
    var recordData: [Memo] = []
    
    private init() {}
    
    func updateRecordData(newData: [Memo]) {
        recordData = newData
    }
    
    func clearAllData() {
        recordData.removeAll()
    }
}

