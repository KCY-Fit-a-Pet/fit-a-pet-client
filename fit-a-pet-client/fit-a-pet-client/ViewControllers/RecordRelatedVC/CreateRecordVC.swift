

import UIKit
import SnapKit
import PhotosUI

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
    private let stackView = UIStackView()
    private var selections = [String : PHPickerResult]()
    private var selectedAssetIdentifiers = [String]()
    var imagesDict: [String : UIImage] = [:]
    
    let petImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
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
        
        setupStackView()
        setupButtonStackView()

        dataScrollView.addSubview(stackView)
        dataScrollView.addSubview(titleTextFiled)
        dataScrollView.addSubview(petImageCollectionView)
        dataScrollView.addSubview(contentTextView)
        
        titleTextFiled.placeholder = "제목을 입력해주세요."
        
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
        
        folderImageView.contentMode = .scaleAspectFit
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
        imageAddButton.addTarget(self, action: #selector(presentPHPicker), for: .touchUpInside)
        
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
            make.height.equalTo(0)
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
            make.bottom.equalTo(view.snp.bottom).offset(-20)
        }
    }
    
    @objc private func showMenu() {
        let parentFolderData = ["동물 1", "동물 2", "동물 3"]
        let childFolderData = [[], ["동물 2.1", "동물 2.2"], []]
        
        var menuItems = [UIMenuElement]()
        
        for (index, parentFolder) in parentFolderData.enumerated() {
            if !childFolderData[index].isEmpty {
                var childItems = [UIMenuElement]()
                
                for childFolder in childFolderData[index] {
                    let action = UIAction(title: childFolder) { _ in
                        self.selectedFolderLabel.text = childFolder
                        self.selectedFolderLabel.textColor = .black
                        self.folderImageView.image = UIImage(named: "subFolder")
                        self.selectedFolderLabel.snp.updateConstraints{make in
                            make.leading.equalTo(self.folderImageView.snp.trailing).offset(8)
                        }
                    }
                    childItems.append(action)
                }
 
                let parentMenu = UIMenu(title: parentFolder, children: childItems)
                menuItems.append(parentMenu)
            } else {

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
        
        let mainMenu = UIMenu(title: "", children: menuItems)
        
        self.folderButton.menu = mainMenu
        self.folderButton.showsMenuAsPrimaryAction = true
    }
    
    @objc func presentPHPicker() {
       
            var configuration = PHPickerConfiguration(photoLibrary: .shared())
            configuration.filter = .images
            configuration.selectionLimit = 6
            configuration.preselectedAssetIdentifiers = self.selectedAssetIdentifiers
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
    }

    @objc func keyboardHideButtonTapped() {
        dismissKeyboard()
    }

}

extension CreateRecordVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        var newSelections = [String: PHPickerResult]()
        
        for result in results {
            let identifier = result.assetIdentifier!
            newSelections[identifier] = selections[identifier] ?? result
        }
        
        selections = newSelections
        selectedAssetIdentifiers = results.compactMap { $0.assetIdentifier }
        
        if !selections.isEmpty {
            loadImages()
            self.petImageCollectionView.reloadData()
            petImageCollectionView.snp.updateConstraints { make in
                make.height.equalTo(100)
            }
        }
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
        
            keyboardHideButton.setImage(UIImage(named: "keyboardHide"), for: .normal)
        
            let offsetData = keyboardHeight
            

            btnStackView.snp.updateConstraints { make in
                make.bottom.equalTo(view.snp.bottom).offset(-offsetData)
            }
        }
    
    @objc private func keyboardWillHide(notification: Notification) {
        dataScrollView.contentInset = .zero
        dataScrollView.scrollIndicatorInsets = .zero
        
        keyboardHideButton.setImage(UIImage(named: ""), for: .normal)
        
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
        return selections.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetImageCollectionViewCell", for: indexPath) as! PetImageCollectionViewCell
        
//        // 선택된 이미지를 가져오기 위해 selections 딕셔너리를 순회합니다.
//        for (_, result) in selections {
//            let assetIdentifier = result.assetIdentifier
//
//            // 선택된 이미지의 식별자로 PHAsset을 가져옵니다.
//            if let assetIdentifier = assetIdentifier {
//                let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: nil)
//                if let phAsset = fetchResult.firstObject {
//                    let options = PHImageRequestOptions()
//                    options.isSynchronous = false
//
//                    PHImageManager.default().requestImage(for: phAsset, targetSize: CGSize(width: 80, height: 80), contentMode: .aspectFill, options: options) { image, _ in
//                        DispatchQueue.main.async {
//                            print("???")
//                            cell.updatePetImage(image)
//                        }
//                    }
//                }
//            }
//        }
        
        
        let identifier = selectedAssetIdentifiers[indexPath.item]
            guard let image = imagesDict[identifier] else {
                // 해당 식별자에 해당하는 이미지가 없으면 기본 이미지를 표시하거나 아무 작업을 하지 않습니다.
                return cell
            }

            cell.updatePetImage(image)
        
        return cell
    }



    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    
    func loadImages() {
        let dispatchGroup = DispatchGroup()

        for (identifier, result) in selections {
            dispatchGroup.enter()

            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    guard let image = image as? UIImage else { return }

                    self.imagesDict[identifier] = image
                    dispatchGroup.leave()
                }
            } else {
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }

            self.petImageCollectionView.reloadData()
        }
    }



    
}
