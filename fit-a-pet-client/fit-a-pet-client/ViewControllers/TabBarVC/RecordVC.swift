
import UIKit
import SnapKit
import SwiftUI

class RecordVC: UIViewController{
    
    private let searchRecordTextField =  UITextField()
    private let dataScrollView = UIScrollView()
    private let folderView = CustomCategoryStackView(label: "전체보기")
    private let listView = RecordListView()
    private let listTableViewMethod = RecordListTableViewMethod()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTotalFolderListAPI()
        NotificationCenter.default.addObserver(self, selector: #selector(handleCellSelectionNotificationFromPanModal(_:)), name: .cellSelectedNotificationFromPanModal, object: nil)
        
        initView()
        setupNavigationBar()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(folderViewTapped))
        folderView.addGestureRecognizer(tapGestureRecognizer)
        
        listView.recordListTableView.delegate = listTableViewMethod
        listView.recordListTableView.dataSource = listTableViewMethod
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        recordDataListAPI()
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
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.image = UIImage(named: "search")

        let iconContainerView: UIView = UIView()
        iconContainerView.addSubview(imageView)
        
        
        searchRecordTextField.font = .systemFont(ofSize: 14)
        searchRecordTextField.layer.cornerRadius = 8
        searchRecordTextField.placeholder = "검색"
        searchRecordTextField.backgroundColor = UIColor(named: "Gray1")
        searchRecordTextField.leftView = iconContainerView
        searchRecordTextField.leftViewMode = .always

        imageView.snp.makeConstraints { make in
            make.leading.equalTo(iconContainerView).offset(10)
            make.centerY.equalTo(iconContainerView)
        }
        searchRecordTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }

        iconContainerView.snp.makeConstraints { make in
            make.width.equalTo(38)
            make.height.equalTo(20)
        }
        
        dataScrollView.snp.makeConstraints { make in
            make.top.equalTo(folderView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
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
              let type = userInfo["type"] as? String
        else {
            return
        }
        print("VC Selected memoCategoryId: \(memoCategoryId), memoCategoryName: \(memoCategoryName), petName: \(petName), type: \(type)")
        if type == "ROOT"{
            folderView.selectedText = memoCategoryName
        }else{
            folderView.selectedText = petName + "/" + memoCategoryName
        }
        
        //userTotalFolderListAPI()
    }

    func updatelistViewHeight() {
        
        let heightForRow:CGFloat = 88
        let totalCellHeight = CGFloat(listView.recordListTableView.numberOfRows(inSection: 0)) * heightForRow
      
        listView.snp.updateConstraints { make in
            make.height.equalTo(totalCellHeight + 200)
        }
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
        AuthorizationAlamofire.shared.recordDataListInquiry(1, 8, "") { result in
            switch result {
            case .success(let data):
                if let responseData = data {
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] ?? [:]
                        print(jsonObject)
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
