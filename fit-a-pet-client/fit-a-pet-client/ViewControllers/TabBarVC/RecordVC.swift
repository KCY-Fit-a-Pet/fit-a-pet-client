
import UIKit
import SnapKit
import SwiftUI

class RecordVC: UIViewController{
    
    private let searchRecordTextField =  UITextField()
    private let dataScrollView = UIScrollView()
    private let folderView = CustomStackView(label: "전체보기")
    //private let folderView = RecordFolderView()
    private let listView = RecordListView()

    //private let folderTableViewMethod = RecordFolderTableViewMethod()
    private let listTableViewMethod = RecordListTableViewMethod()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        setupNavigationBar()
//        folderView.folderTableView.delegate = folderTableViewMethod
//        folderView.folderTableView.dataSource = folderTableViewMethod
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(folderViewTapped))
        folderView.addGestureRecognizer(tapGestureRecognizer)
        
        listView.recordListTableView.delegate = listTableViewMethod
        listView.recordListTableView.dataSource = listTableViewMethod
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userTotalFolderListAPI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //updatefolderViewHeight()
        updatelistViewHeight()
    }
    
    func initView(){
        view.backgroundColor = .white
        
        view.addSubview(searchRecordTextField)
        view.addSubview(dataScrollView)
        dataScrollView.addSubview(folderView)
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
            make.top.equalTo(searchRecordTextField.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        folderView.snp.makeConstraints{make in
            make.top.equalTo(dataScrollView.snp.top)
            make.leading.trailing.equalTo(view).inset(16)
        }
        
        listView.snp.makeConstraints{make in
            make.top.equalTo(folderView.snp.bottom).offset(8)
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
        let nextVC = FolderPanModalVC()
        self.presentPanModal(nextVC)
    }
    
//    func updatefolderViewHeight() {
//
//        let heightForRow:CGFloat = 56
//        let totalCellHeight = CGFloat(folderView.folderTableView.numberOfRows(inSection: 0)) * heightForRow
//
//        folderView.snp.updateConstraints { make in
//            make.height.equalTo(totalCellHeight)
//        }
//    }
    func updatelistViewHeight() {
        
        let heightForRow:CGFloat = 88
        let totalCellHeight = CGFloat(listView.recordListTableView.numberOfRows(inSection: 0)) * heightForRow
      
        listView.snp.updateConstraints { make in
            make.height.equalTo(totalCellHeight)
        }
    }
    func userTotalFolderListAPI(){
        AuthorizationAlamofire.shared.recordTotalFolderList{ result in
            switch result {
            case .success(let data):
                if let responseData = data {
                    let object = try?JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary
                    guard let jsonObject = object else {return}
                    print("respose jsonData: \(jsonObject)")
                }
                
            case .failure(let error):
                print("Error fetching")
            }
        }
    }
}
