
import UIKit
import SnapKit

class RecordVC: UIViewController{
    
    private let searchRecordTextField =  UITextField()
    private let dataScrollView = UIScrollView()
    private let folderView = RecordFolderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        setupNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatefolderViewHeight()
    }
    
    func initView(){
        view.backgroundColor = .white
        
        view.addSubview(searchRecordTextField)
        view.addSubview(dataScrollView)
        dataScrollView.addSubview(folderView)
        
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
            make.top.equalTo(searchRecordTextField.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        folderView.snp.makeConstraints{make in
            make.top.equalTo(dataScrollView.snp.top)
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
        navigationItem.rightBarButtonItems = [folderButton, recordButton]
    }
    @objc func didTapfolederAddButton(){
        
    }
    
    @objc func didTapRecordAddButton(){
        
    }
    
    func updatefolderViewHeight() {
        
        let heightForRow:CGFloat = 56
        let totalCellHeight = CGFloat(folderView.folderTableView.numberOfRows(inSection: 0)) * heightForRow
      
        folderView.snp.updateConstraints { make in
            make.height.equalTo(totalCellHeight)
        }
    }
}
