
import UIKit
import SnapKit
import SwiftUI

class RecordVC: UIViewController{
    
    private let searchRecordTextField =  CustomSearchTextField()
    private let dataScrollView = UIScrollView()
    private let folderView = CustomCategoryStackView(label: "전체보기")
    private let listView = RecordListView()
    private let listTableViewMethod = RecordListTableViewMethod()
    private let noListDataView = NoRecordDataView()
    private var selectedMemoCategoryId = 0
    private var selectedPetId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCellSelectionNotificationFromPanModal(_:)), name: .cellSelectedNotificationFromPanModal, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleFolderCreatedNotification(_:)), name: Notification.Name("FolderCreatedNotification"), object: nil)
        
        initView()
        setupNavigationBar()
        userTotalFolderListAPI()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(folderViewTapped))
        folderView.addGestureRecognizer(tapGestureRecognizer)
        
        listView.recordListTableView.delegate = listTableViewMethod
        listView.recordListTableView.dataSource = listTableViewMethod
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatelistViewHeight()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func initView(){
        view.backgroundColor = .white
        
        view.addSubview(searchRecordTextField)
        view.addSubview(dataScrollView)
        view.addSubview(folderView)
        dataScrollView.addSubview(listView)
        dataScrollView.addSubview(noListDataView)
        
        noListDataView.isHidden = true
        
        searchRecordTextField.placeholderText = "검색"
        searchRecordTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }

        dataScrollView.snp.makeConstraints { make in
            make.top.equalTo(folderView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        folderView.snp.makeConstraints{make in
            make.top.equalTo(searchRecordTextField.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view).inset(16)
        }
        
        listView.snp.makeConstraints{make in
            make.top.equalTo(dataScrollView.snp.top).offset(8)
            make.leading.trailing.equalTo(view).inset(16)
            make.height.equalTo(0)
            make.bottom.equalTo(dataScrollView.snp.bottom)
        }
        noListDataView.snp.makeConstraints{make in
            make.centerX.centerY.equalTo(dataScrollView)
            make.height.equalTo(50)
        }
        
    }
    
    func setupNavigationBar() {
        let leftLabel = UILabel()
        leftLabel.text = "기록"
        leftLabel.font = .boldSystemFont(ofSize: 18)
        leftLabel.textColor = .black

        let leftItem = UIBarButtonItem(customView: leftLabel)
        navigationItem.leftBarButtonItem = leftItem

        let folderButton = UIBarButtonItem(image: UIImage(named: "folder_add"), style: .plain, target: self, action: #selector(didTapfolederAddButton))
        let recordButton = UIBarButtonItem(image: UIImage(named: "record_add"), style: .plain, target: self, action: #selector(didTapRecordAddButton))
        folderButton.tintColor = .black
        recordButton.tintColor = .black
        navigationItem.rightBarButtonItems = [recordButton, folderButton]
    }
    
    func updatelistViewHeight() {
        
        let heightForRow:CGFloat = 88
        let totalCellHeight = CGFloat(listView.recordListTableView.numberOfRows(inSection: 0)) * heightForRow
      
        listView.snp.updateConstraints { make in
            make.height.equalTo(totalCellHeight + 200)
        }
    }
    
    @objc func didTapfolederAddButton(){
        let nextVC = CreateFolderVC(title: "폴더 만들기")
        nextVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)

    }
    
    @objc func didTapRecordAddButton(){
        let nextVC = CreateRecordVC(title: "")
        nextVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    @objc func folderViewTapped(){
        userTotalFolderListAPI()
        let nextVC = TotalFolderPanModalVC()
        self.presentPanModal(nextVC)
    }
    
    @objc func handleCellSelectionNotificationFromPanModal(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any],
              let memoCategoryId = userInfo["memoCategoryId"] as? Int,
              let memoCategoryName = userInfo["memoCategoryName"] as? String,
              let petName = userInfo["petName"] as? String,
              let type = userInfo["type"] as? String,
              let petId = userInfo["petId"] as? Int
        else {
            return
        }
        print("VC Selected memoCategoryId: \(memoCategoryId), memoCategoryName: \(memoCategoryName), petName: \(petName), type: \(type), petId: \(petId)")
        selectedMemoCategoryId = memoCategoryId
        selectedPetId = petId
        if type == "ROOT"{
            folderView.selectedText = memoCategoryName
        }else{
            folderView.selectedText = petName + "/" + memoCategoryName
        }
        
        recordDataListAPI()
    }
    
    @objc func handleFolderCreatedNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any],
           let categoryId = userInfo["categoryId"] as? Int,
           let categoryPetId = userInfo["categoryPetId"] as? Int,
           let inputCategoryName = userInfo["inputCategoryName"] as? String,
           let petName = userInfo["petName"] as? String
        else {
            return
        }
        
        self.folderView.selectedText = "\(petName)/\(inputCategoryName)"
        selectedMemoCategoryId = categoryId
        selectedPetId = categoryPetId
        recordDataListAPI()
    }

    func userTotalFolderListAPI(){
        AuthorizationAlamofire.shared.recordTotalFolderList { result in
            switch result {
            case .success(let data):
                if let responseData = data {
                    do {
                        if let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                           let jsonData = jsonObject["data"] as? [String: Any],
                           let rootCategoriesData = jsonData["rootMemoCategories"] as? [[String: Any]] {
                            
                            for categoryInfo in rootCategoriesData {
                                if let petId = categoryInfo["petId"] as? Int,
                                   let memoCategoryId = categoryInfo["memoCategoryId"] as? Int,
                                   let memoCategoryName = categoryInfo["memoCategoryName"] as? String,
                                   let totalMemoCount = categoryInfo["totalMemoCount"] as? Int,
                                   let type = categoryInfo["type"] as? String {
                                    
                                    var subCategories: [MemoCategory] = []
                                    
                                    if let subCategoriesData = categoryInfo["subMemoCategories"] as? [[String: Any]] {
                                        for subCategoryInfo in subCategoriesData {
                                            if let rootPetId = subCategoryInfo["petId"] as? Int,
                                               let subMemoCategoryId = subCategoryInfo["memoCategoryId"] as? Int,
                                               let subMemoCategoryName = subCategoryInfo["memoCategoryName"] as? String,
                                               let subTotalMemoCount = subCategoryInfo["totalMemoCount"] as? Int,
                                               let subType = subCategoryInfo["type"] as? String {
                                                
                                                let subCategory = MemoCategory(petId: rootPetId,
                                                                               memoCategoryId: subMemoCategoryId,
                                                                               memoCategoryName: subMemoCategoryName,
                                                                               totalMemoCount: subTotalMemoCount,
                                                                               type: subType)
                                                subCategories.append(subCategory)
                                            }
                                        }
                                    }
                                    
                                    let memoCategory = MemoCategory(petId: petId,
                                                                    memoCategoryId: memoCategoryId,
                                                                    memoCategoryName: memoCategoryName,
                                                                    totalMemoCount: totalMemoCount,
                                                                    type: type,
                                                                    subCategories: subCategories)
                                    RecordTotalFolderManager.shared.updateCategoryData(categoryName: memoCategoryName, newData: [memoCategory])
                                }
                            }
                            print(RecordTotalFolderManager.shared.categoryData)
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            case .failure(let error):
                print("Error fetching: \(error)")
            }
        }
    }
    
    func recordDataListAPI(){
        AuthorizationAlamofire.shared.recordDataListInquiry(selectedPetId, selectedMemoCategoryId, "") { result in
            switch result {
            case .success(let data):
                if let responseData = data {
                    do {
                        var memoList: [Memo] = []
                        if let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                           let jsonData = jsonObject["data"] as? [String: Any],
                           let memoDatas = jsonData["memos"] as? [[String: Any]] {
                            for memoData in memoDatas {
                                let memoImageDict = memoData["memoImage"] as? [String: Any]
                                let memoImage: MemoImage?
                                if let memoImageDict = memoImageDict {
                                    memoImage = MemoImage(imgUrl: memoImageDict["imgUrl"] as? String ?? "",
                                                          memoImageId: memoImageDict["memoImageId"] as? Int ?? 0)
                                } else {
                                    memoImage = nil
                                }
                                let memo = Memo(categorySuffix: memoData["categorySuffix"] as? String ?? "",
                                                content: memoData["content"] as? String ?? "",
                                                createdAt: memoData["createdAt"] as? String ?? "",
                                                memoId: memoData["memoId"] as? Int ?? 0,
                                                memoImage: memoImage,
                                                title: memoData["title"] as? String ?? "")
                                memoList.append(memo)
                            }
                        }
                        if memoList.count == 0{
                            self.noListDataView.isHidden = false
                            self.listView.isHidden = true
                        }else{
                            self.noListDataView.isHidden = true
                            self.listView.isHidden =  false
                        }
                        RecordDataListManager.shared.updateRecordData(newData: memoList)
                        print( RecordDataListManager.shared.recordData)

                        self.listView.recordListTableView.reloadData()
                        self.updatelistViewHeight()
                        
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            case .failure(let error):
                print("Error fetching: \(error)")
            }
        }
    }
}
