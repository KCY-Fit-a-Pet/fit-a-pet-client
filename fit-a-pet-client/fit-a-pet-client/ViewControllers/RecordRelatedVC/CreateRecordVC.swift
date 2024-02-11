

import UIKit
import SnapKit

class CreateRecordVC: CustomEditNavigationBar{
    
    let dataScrollView = UIScrollView()

    let folderButton = UIButton()
    let selectedFolderLabel = UILabel()
    
    let folderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleTextFiled = UITextField()
    let contentTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
   
        folderButton.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
    }
    
    func initView(){
        
        view.backgroundColor = .white
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
 
        stackView.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        
        stackView.addArrangedSubview(folderImageView)
        stackView.addArrangedSubview(selectedFolderLabel)
        stackView.addArrangedSubview(folderButton)
        
        selectedFolderLabel.text = "폴더를 선택해주세요"
        selectedFolderLabel.textColor = UIColor(named: "Gray3")
        selectedFolderLabel.font = .systemFont(ofSize: 14, weight: .regular)
        folderButton.setImage(UIImage(named: "category"), for: .normal)
        titleTextFiled.placeholder = "제목을 입력해주세요."
        
        
        dataScrollView.addSubview(stackView)
        dataScrollView.addSubview(titleTextFiled)
        dataScrollView.addSubview(contentTextView)
        view.addSubview(dataScrollView)
        
        dataScrollView.snp.makeConstraints{make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        
        folderImageView.snp.makeConstraints{make in
            make.width.height.equalTo(24)
        }
        selectedFolderLabel.snp.makeConstraints{make in
            make.leading.equalTo(folderImageView.snp.trailing).inset(16)
        }
        
        stackView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.top.equalTo(dataScrollView.snp.top).offset(8)
            make.leading.trailing.equalTo(view).inset(16)
        }
        
        titleTextFiled.snp.makeConstraints{make in
            make.height.equalTo(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(stackView.snp.bottom).offset(28)
        }
        contentTextView.snp.makeConstraints{make in
            make.height.equalTo(700)
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleTextFiled.snp.bottom).offset(8)
            make.bottom.equalTo(dataScrollView.snp.bottom)
        }
    }
    
    @objc private func showMenu() {
        let parentFolderData = ["동물 1", "동물 2", "동물 3"]
        let childFolderData = [[], ["동물 2.1", "동물 2.2"], []]
        
        var menuItems = [UIMenuElement]()
        
        for (index, parentFolder) in parentFolderData.enumerated() {
            // 자식 폴더가 있는지 확인하고, 없으면 상위 폴더만 메뉴에 추가
            if !childFolderData[index].isEmpty {
                var childItems = [UIMenuElement]()
                
                // 자식 폴더 생성
                for childFolder in childFolderData[index] {
                    let action = UIAction(title: childFolder) { _ in
                        // 자식 폴더를 선택한 후 수행할 작업
                        self.selectedFolderLabel.text = childFolder
                        self.selectedFolderLabel.textColor = .black
                        self.folderImageView.image = UIImage(named: "subFolder")
                        self.selectedFolderLabel.snp.updateConstraints{make in
                            make.leading.equalTo(self.folderImageView.snp.trailing).offset(8)
                        }
                    }
                    childItems.append(action)
                }
                
                // 상위 폴더와 해당 상위 폴더의 자식 폴더로 UIMenu 생성
                let parentMenu = UIMenu(title: parentFolder, children: childItems)
                menuItems.append(parentMenu)
            } else {
                // 자식 폴더가 없는 경우 상위 폴더만 메뉴에 추가
                let action = UIAction(title: parentFolder) { _ in
                    self.selectedFolderLabel.text = parentFolder
                    self.selectedFolderLabel.textColor = .black
                    
                    self.folderImageView.image = UIImage(named: "folder")
                    self.selectedFolderLabel.snp.updateConstraints{make in
                        make.leading.equalTo(self.folderImageView.snp.trailing).offset(8)
                    }
                }
                menuItems.append(action)
            }
        }
        
        // 메인 메뉴 생성
        let mainMenu = UIMenu(title: "", children: menuItems)
        
        self.folderButton.menu = mainMenu
        self.folderButton.showsMenuAsPrimaryAction = true
    }

}

