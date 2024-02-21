

import UIKit
import SnapKit
import PhotosUI

class CreateRecordVC: CustomEditNavigationBar {
    
    private let dataScrollView = UIScrollView()

    private let titleTextFiled = UITextField()
    private let contentTextView = UITextView()
    private let selecteFolderView = CustomCategoryStackView(label: "폴더를 선택해주세요")
    private var buttonStackView = ButtonStackView()
    private var selections = [String : PHPickerResult]()
    private var selectedAssetIdentifiers = [String]()
    private var imagesDict: [String : UIImage] = [:]
    private var images: [UIImage] = []
    
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
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        petImageCollectionView.delegate = self
        petImageCollectionView.dataSource = self
        petImageCollectionView.register(PetImageCollectionViewCell.self, forCellWithReuseIdentifier: "PetImageCollectionViewCell")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(folderViewTapped))
        selecteFolderView.addGestureRecognizer(tapGestureRecognizer)
    }

    func initView() {
        view.backgroundColor = .white
        
        setupButtonStackView()

        dataScrollView.addSubview(selecteFolderView)
        dataScrollView.addSubview(titleTextFiled)
        dataScrollView.addSubview(petImageCollectionView)
        dataScrollView.addSubview(contentTextView)
        
        titleTextFiled.placeholder = "제목을 입력해주세요."
        selecteFolderView.layer.borderWidth = 0
        
        view.addSubview(dataScrollView)
        view.addSubview(buttonStackView)
        
        setupConstraints()
    }

    private func setupButtonStackView() {

        self.buttonStackView.imageAddButton.addTarget(self, action: #selector(presentPHPicker), for: .touchUpInside)
        self.buttonStackView.keyboardHideButton.addTarget(self, action: #selector(keyboardHideButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        dataScrollView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(buttonStackView.snp.top)
        }
        
        selecteFolderView.snp.makeConstraints{make in
            make.top.equalTo(dataScrollView.snp.top).offset(8)
            make.leading.trailing.equalTo(view).inset(16)
        }
        
        titleTextFiled.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.leading.trailing.equalTo(view).inset(20)
            make.top.equalTo(selecteFolderView.snp.bottom).offset(20)
        }
        
        petImageCollectionView.snp.makeConstraints { make in
            make.height.equalTo(0)
            make.leading.trailing.equalTo(view).inset(16)
            make.top.equalTo(titleTextFiled.snp.bottom).offset(8)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.height.equalTo(700)
            make.leading.trailing.equalTo(view).inset(16)
            make.top.equalTo(petImageCollectionView.snp.bottom)
            make.bottom.equalTo(dataScrollView.snp.bottom)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.snp.bottom).offset(-20)
        }
    }
    
    @objc func folderViewTapped(){
        let nextVC = TotalFolderPanModalVC()
        self.presentPanModal(nextVC)
    }
    
    @objc func presentPHPicker() {
        
        images.removeAll()
        
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
        
            self.buttonStackView.keyboardHideButton.setImage(UIImage(named: "keyboardHide"), for: .normal)
        
            let offsetData = keyboardHeight
            

            self.buttonStackView.snp.updateConstraints { make in
                make.bottom.equalTo(view.snp.bottom).offset(-offsetData)
            }
        }
    
    @objc private func keyboardWillHide(notification: Notification) {
        dataScrollView.contentInset = .zero
        dataScrollView.scrollIndicatorInsets = .zero
        
        self.buttonStackView.keyboardHideButton.setImage(UIImage(named: ""), for: .normal)
        
        self.buttonStackView.snp.updateConstraints { make in
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
        
        if let text = titleTextFiled.text {
            
            RecordCreateManager.shared.addInput(title: text)
            print("Entered Text: \(text)")
        }
        if let text = contentTextView.text {
            RecordCreateManager.shared.addInput(content: text)
            
            print("Entered Text: \(text)")
        }
        
        RecordCreateManager.shared.performRegistration()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension CreateRecordVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selections.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetImageCollectionViewCell", for: indexPath) as! PetImageCollectionViewCell

        let identifier = selectedAssetIdentifiers[indexPath.item]
        let image = imagesDict[identifier]
        
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
                    self.images.append(image)

                    dispatchGroup.leave()
                }
            } else {
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            
            RecordCreateManager.shared.addInput(memoImages: self.images)
            self.petImageCollectionView.reloadData()
        }
    }
}
