
import UIKit
import SnapKit

class CreateFolderVC: CustomNavigationBar{
    
    private let parentFolderLabel = UILabel()
    let selectFolderView = CustomCategoryStackView(label: "전체보기")
    private let folderNameInputView = CustomVerticalView(labelText: "폴더 이름", placeholder: "이름")
    
    private let createButton = CustomNextBtn(title: "폴더 만들기")
    private var inputCategoryName = ""
    private var categoryId = 0
    private var categoryPetId = 0
    private var seletedPetName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCellSelectedFromRootFolderPanModal(_:)), name: .cellSelectedFromRootFolderPanModal, object: nil)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(folderViewTapped))
        selectFolderView.addGestureRecognizer(tapGestureRecognizer)
        
        createButton.addTarget(self, action: #selector(createFolderAPI), for: .touchUpInside)
        folderNameInputView.textInputField.delegate = self
    }
    
    func initView(){
        
        view.backgroundColor = .white
        
        parentFolderLabel.text = "상위 폴더"
        parentFolderLabel.font = .boldSystemFont(ofSize: 18)
        
        view.addSubview(parentFolderLabel)
        view.addSubview(selectFolderView)
        view.addSubview(folderNameInputView)
        view.addSubview(createButton)
        
        parentFolderLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
        }
        
        selectFolderView.snp.makeConstraints{make in
            make.top.equalTo(parentFolderLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view).inset(16)
        }
        
        folderNameInputView.snp.makeConstraints{make in
            make.top.equalTo(selectFolderView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(88)
        }
        
        createButton.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-50)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    @objc func folderViewTapped(){
        let nextVC = RootFolderPanModalVC()
        self.presentPanModal(nextVC)
    }
    
    @objc func handleCellSelectedFromRootFolderPanModal(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: Any],
              let memoCategoryId = userInfo["memoCategoryId"] as? Int,
              let memoCategoryName = userInfo["memoCategoryName"] as? String,
              let petId = userInfo["petId"] as? Int,
              let petName = userInfo["petName"] as? String
        else {
            return
        }
        print("Selected memoCategoryId: \(memoCategoryId), memoCategoryName: \(memoCategoryName), petId: \(petId), petName: \(petName)")
              
        categoryId = memoCategoryId
        selectFolderView.selectedText = memoCategoryName
        categoryPetId = petId
        seletedPetName = petName
    }
    
    @objc func createFolderAPI(){
        AuthorizationAlamofire.shared.createFolder(categoryPetId, categoryId, inputCategoryName) { [self] result in
            switch result {
            case .success(let data):
                if let responseData = data,
                   let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                    print("response jsonData: \(jsonObject)")
                    
                    NotificationCenter.default.post(name: Notification.Name("folderCreatedNotification"), object: nil, userInfo: ["categoryId": categoryId, "categoryPetId": categoryPetId, "inputCategoryName": inputCategoryName, "petName": seletedPetName])
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CreateFolderVC: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textView: UITextField) {      
        
        if let text = folderNameInputView.textInputField.text {
            inputCategoryName = text
            print("Entered Text: \(text)")
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
