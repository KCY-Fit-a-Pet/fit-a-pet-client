
import UIKit
import SnapKit

class CreateFolderVC: CustomNavigationBar{
    
    let folderButton = UIButton()
    let parentFolderLabel = UILabel()
    let selectedFolderLabel = UILabel()
    
    let folderNameInputView = CustomVerticalView(labelText: "폴더 이름", placeholder: "이름")
    
    let createButton = CustomNextBtn(title: "폴더 만들기")

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
        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = 8
        stackView.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        stackView.addArrangedSubview(selectedFolderLabel)
        stackView.addArrangedSubview(folderButton)
        
        selectedFolderLabel.text = "선택"
        selectedFolderLabel.font = .systemFont(ofSize: 14, weight: .regular)
        
        folderButton.setImage(UIImage(named: "category"), for: .normal)
        
        parentFolderLabel.text = "상위 폴더"
        parentFolderLabel.font = .boldSystemFont(ofSize: 18)
        
        view.addSubview(parentFolderLabel)
        view.addSubview(stackView)
        view.addSubview(folderNameInputView)
        view.addSubview(createButton)
        
        parentFolderLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
        }
        
        selectedFolderLabel.snp.makeConstraints{make in
            make.leading.equalToSuperview().inset(16)
        }
        
        stackView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.top.equalTo(parentFolderLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        folderNameInputView.snp.makeConstraints{make in
            make.top.equalTo(stackView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(88)
        }
        
        createButton.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-50)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    @objc private func showMenu() {
        
        let dataArray = ["data1", "data2"]
        
        var menuItems = [UIAction]()
        
        for data in dataArray {
            let action = UIAction(title: data) { _ in
                self.selectedFolderLabel.text = data
            }
            menuItems.append(action)
        }
        
        let menu = UIMenu(title: "title", options: .displayInline, children: menuItems)
        
        self.folderButton.menu = menu
        self.folderButton.showsMenuAsPrimaryAction = true
    }
}
