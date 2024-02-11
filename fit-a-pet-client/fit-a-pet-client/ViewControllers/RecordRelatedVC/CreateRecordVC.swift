

import UIKit
import SnapKit

class CreateRecordVC: CustomEditNavigationBar {
    
    private let dataScrollView = UIScrollView()
    private let folderButton = UIButton()
    private let selectedFolderLabel = UILabel()
    private let folderImageView = UIImageView()
    private let titleTextFiled = UITextField()
    private let contentTextView = UITextView()
    private let imageAddButton = UIButton()
    private let keyboardHideButton = UIButton()
    private let btnStackView = UIStackView()
    private let stackView = UIStackView() // 추가
    
    let petImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        setupTextView()
        setupTapGesture()
        
        folderButton.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        petImageCollectionView.delegate = self
        petImageCollectionView.dataSource = self
        petImageCollectionView.register(PetImageCollectionViewCell.self, forCellWithReuseIdentifier: "PetImageCollectionViewCell")
    }
    
    func initView() {
        view.backgroundColor = .white
        
        setupStackView() // stackView 설정
        setupButtonStackView() // btnStackView 설정

        // 추가: 각 view를 scrollView에 추가
        dataScrollView.addSubview(stackView)
        dataScrollView.addSubview(titleTextFiled)
        dataScrollView.addSubview(petImageCollectionView)
        dataScrollView.addSubview(contentTextView)
        
        // 레이아웃에 scrollView 추가
        view.addSubview(dataScrollView)
        view.addSubview(btnStackView)
        
        setupConstraints()
    }
    
    private func setupStackView() {
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
    }
    
    private func setupButtonStackView() {
        btnStackView.axis = .horizontal
        btnStackView.spacing = 8
        btnStackView.distribution = .equalSpacing
        
        btnStackView.addArrangedSubview(imageAddButton)
        btnStackView.addArrangedSubview(keyboardHideButton)
        
        imageAddButton.setImage(UIImage(named: "addPhoto"), for: .normal)
        imageAddButton.addTarget(self, action: #selector(imageAddButtonTapped), for: .touchUpInside)
        
        keyboardHideButton.setImage(UIImage(named: "keyboardHide"), for: .normal)
        keyboardHideButton.addTarget(self, action: #selector(keyboardHideButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        dataScrollView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(btnStackView.snp.top)
        }
        
        folderImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        
        selectedFolderLabel.snp.makeConstraints { make in
            make.leading.equalTo(folderImageView.snp.trailing).inset(16)
        }
        
        imageAddButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
        }
        
        keyboardHideButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
        }
        
        stackView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.top.equalTo(dataScrollView.snp.top).offset(8)
            make.leading.trailing.equalTo(view).inset(16)
        }
        
        titleTextFiled.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.leading.trailing.equalTo(view).inset(20)
            make.top.equalTo(stackView.snp.bottom).offset(10)
        }
        
        petImageCollectionView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.leading.trailing.equalTo(view).inset(16)
            make.top.equalTo(titleTextFiled.snp.bottom).offset(8)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.height.equalTo(700)
            make.leading.trailing.equalTo(view).inset(16)
            make.top.equalTo(petImageCollectionView.snp.bottom).offset(8)
            make.bottom.equalTo(dataScrollView.snp.bottom)
        }
        
        btnStackView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
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
    
    @objc func imageAddButtonTapped() {
        
    }
    @objc func keyboardHideButtonTapped() {
        dismissKeyboard()
    }

}

extension CreateRecordVC {
    @objc private func keyboardWillShow(notification: Notification) {
            guard let userInfo = notification.userInfo,
                  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            
            let keyboardHeight = keyboardFrame.height
            let buttonBottomSpace: CGFloat = 10
            
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight + buttonBottomSpace, right: 0)
            dataScrollView.contentInset = contentInset
            dataScrollView.scrollIndicatorInsets = contentInset
        
            let offsetData = keyboardHeight
            

            btnStackView.snp.updateConstraints { make in
                make.bottom.equalTo(view.snp.bottom).offset(-offsetData)
            }
        }
    
    @objc private func keyboardWillHide(notification: Notification) {
        dataScrollView.contentInset = .zero
        dataScrollView.scrollIndicatorInsets = .zero
        
        btnStackView.snp.updateConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(-20)
        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension CreateRecordVC: UITextViewDelegate {
    func setupTextView() {
        contentTextView.delegate = self
        contentTextView.text = "내용을 입력해주세요."
        contentTextView.textColor = UIColor(named: "Gray3")
        contentTextView.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if contentTextView.textColor == UIColor(named: "Gray3") {
            contentTextView.text = nil
            contentTextView.textColor = UIColor.black
        }
        if titleTextFiled.textColor == UIColor(named: "Gray3") {
            titleTextFiled.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력해주세요."
            textView.textColor = UIColor(named: "Gray3")
        }
    }
}

extension CreateRecordVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetImageCollectionViewCell", for: indexPath) as! PetImageCollectionViewCell
        // 셀에 데이터 설정
        // 예: cell.imageView.image = yourImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 셀의 크기 설정
        return CGSize(width: 80, height: 80)
    }
}
