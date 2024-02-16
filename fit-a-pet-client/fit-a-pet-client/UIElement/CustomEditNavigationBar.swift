import UIKit

class CustomEditNavigationBar: UIViewController {
    
    private var titleLabel: UILabel!
    private var cancleButton: UIBarButtonItem!
    var saveButton: UIBarButtonItem!
    
    private var currentTitle = ""
    var userPwData: [String: String] = [:]
    var userName = ""

    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        setupNavigationBar(title: title)
        currentTitle = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupNavigationBar(title: String) {
        cancleButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
        
        cancleButton.tintColor = UIColor(named: "PrimaryColor")
        saveButton.tintColor = UIColor(named: "Gray3")

        if let font = UIFont(name: "Helvetica-Bold", size: 16) {
            cancleButton.setTitleTextAttributes([.font: font], for: .normal)
            saveButton.setTitleTextAttributes([.font: font], for: .normal)
        }
    
        
        self.navigationItem.leftBarButtonItem = cancleButton
        self.navigationItem.rightBarButtonItem = saveButton

        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        titleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: titleLabel.frame.width, height: titleLabel.frame.height))
        titleView.addSubview(titleLabel)
        
        self.navigationItem.titleView = titleView
    }
    
    @objc func cancelButtonTapped() {
        
        switch (currentTitle) {
        case "":
            return presentPopupView()
        default:
            return
        }
//        navigationController?.popToRootViewController(animated: true)
    }

    @objc func saveButtonTapped() {
        
        switch (currentTitle) {
        case "비밀번호 변경":
            return editUserPwAPI()
        case "이름 변경하기":
            return editUserNameAPI()
        case "케어 등록하기":
            return careCategoryCheckAPI()
        case "":
            return createRecordAPI()
        default:
            return
        }
    }
}

extension CustomEditNavigationBar{
    func editUserPwAPI(){
        AuthorizationAlamofire.shared.editUserPw("password", userPwData["prePassword"]!, userPwData["newPassword"]!){
            result in
            switch result {
            case .success(let data):
                if let responseData = data {
                    let object = try?JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary
                    guard let jsonObject = object else {return}
                    print("respose jsonData: \(jsonObject)")
                    self.navigationController?.popToRootViewController(animated: true)
                }
            case .failure(let error):

                print("Error: \(error)")
            }
        }
    }
    
    func editUserNameAPI(){
        AuthorizationAlamofire.shared.editUserName("name", userName){ [self]
            result in
            switch result {
            case .success(let data):
                if let responseData = data {
                    let object = try?JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary
                    guard let jsonObject = object else {return}
                    print("respose jsonData: \(jsonObject)")
                    UserDefaults.standard.set(userName, forKey: "name")
                    self.navigationController?.popToRootViewController(animated: true)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func careCategoryCheckAPI(){
        
        var selectedPetIds: [Int] = []
        selectedPetIds = PetList.petsList
            .filter { $0.selectPet }
            .map { $0.id }
        AuthorizationAlamofire.shared.careCategoryCheck(PetCareRegistrationManager.shared.category!.categoryName, selectedPetIds) { [self] result in
            switch result {
            case .success(let data):
                if let responseData = data {
                    let object = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                    guard let jsonObject = object else { return }
                    
                    print("respose jsonData: \(jsonObject)")

                    if let dataDict = jsonObject["data"] as? [String: Any],
                       let categories = dataDict["categories"] as? [[String: Any]], !categories.isEmpty {
                        var petArray: [[String: Int]] = []
                        for category in categories {
                            if let petId = category["petId"] as? Int,
                               let careCategoryId = category["careCategoryId"] as? Int {
                                print("petId: \(petId), careCategoryId: \(careCategoryId)")
                                let petDictionary: [String: Int] = ["petId": petId, "categoryId": careCategoryId]
                                petArray.append(petDictionary)
                            }
                        }
                        PetCareRegistrationManager.shared.addInput(pets: petArray)
                        createCareRequest()
                        
                    } else {
                        PetCareRegistrationManager.shared.addInput(pets: selectedPetIds.map { ["petId": $0, "categoryId": 0] })

                        createCareRequest()
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }

    }
    private func createCareRequest() {
        
        switch ViewState.stateNum {
        case 0:
            PetCareRegistrationManager.shared.setCareDate(from: CareDate.commonData)
          
        case 1:
            PetCareRegistrationManager.shared.setCareDate(from: CareDate.eachData)
        default:
            PetCareRegistrationManager.shared.setCareDate(from: CareDate.commonData)
        }
        
        let categoryDictionary = PetCareRegistrationManager.shared.categoryDictionaryRepresentation
        let careDictionary = PetCareRegistrationManager.shared.careDictionaryRepresentation
        let petsDictionary = PetCareRegistrationManager.shared.petsDictionaryRepresentation
        
        let combinedData: [String: Any] = [
            "category": categoryDictionary!,
            "care": careDictionary!,
            "pets": petsDictionary!
        ]

        print("combinedData: \(combinedData)")

        AuthorizationAlamofire.shared.createCare(combinedData: combinedData, petId: SelectedPetId.petId) { result in
            switch result {
            case .success(let data):
                if let responseData = data,
                   let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                    print("response jsonData: \(jsonObject)")
                }

            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    private func presentPopupView(){
        let customPopupVC = RecordCustomCheckPopupVC()
        customPopupVC.modalPresentationStyle = .overFullScreen
        customPopupVC.updateText("등록을 취소할까요?", "작성중인 글은 삭제됩니다.", "등록 취소하기", "계속 작성하기")
        self.present(customPopupVC, animated: true, completion: nil)
        
        customPopupVC.dismissalCompletion = {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    private func createRecordAPI() {
        
        let images: [UIImage] = RecordCreateManager.shared.memoImages!
        var urls = [String]()
        
        let dispatchGroup = DispatchGroup()

        for image in images {
            dispatchGroup.enter() // Enter the group
            
            AnonymousAlamofire.shared.presignedURL("memos", "jpeg") { result in
                defer {
                    dispatchGroup.leave() 
                }
                
                switch result {
                case .success(let data):
                    if let responseData = data {
                        do {
                            let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]

                            if let payloadValue = jsonObject?["payload"] as? String,
                               let payloadURL = URL(string: payloadValue),
                               let components = URLComponents(url: payloadURL, resolvingAgainstBaseURL: false),
                               let queryItems = components.queryItems {
                                
                                if let range = payloadValue.range(of: "?") {
                                    PAYLOADURL.PAYLOAD = String(payloadValue[..<range.lowerBound])
                                } else {
                                    PAYLOADURL.PAYLOAD = payloadValue
                                }
                                
                                PAYLOADURL.algorithm = queryItems[0].value ?? ""
                                PAYLOADURL.credential = queryItems[1].value ?? ""
                                PAYLOADURL.date = queryItems[2].value ?? ""
                                PAYLOADURL.expires = queryItems[3].value ?? ""
                                PAYLOADURL.signature = queryItems[4].value ?? ""
                                PAYLOADURL.signedHeaders = queryItems[5].value ?? ""
                                PAYLOADURL.acl = queryItems[6].value ?? ""
                                
                                print("JSON Object: \(jsonObject ?? [:]) + \(PAYLOADURL.PAYLOAD)")
                                
                                urls.append(PAYLOADURL.PAYLOAD)
                                
                                AnonymousAlamofire.shared.uploadImage(image) { result in
                                    switch result {
                                    case .success(let data):
                                        if let unwrappedData = data,
                                           let resultString = String(data: unwrappedData, encoding: .utf8) {
                                            print("Success: \(resultString)")
                                        } else {
                                            print("Success with nil or non-text data")
                                        }
                                        
                                    case .failure(let error):
                                        print("Error: \(error)")
                                    }
                                }
                            } else {
                                print("Payload key not found in the JSON response.")
                            }
                        } catch {
                            print("Error parsing JSON: \(error)")
                        }
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            RecordCreateManager.shared.addInput(memoImageUrls: urls)
            
            let title = RecordCreateManager.shared.title ?? ""
            let content = RecordCreateManager.shared.content ?? ""
            let memoImageUrls = RecordCreateManager.shared.memoImageUrls ?? []

            let combinedData: [String: Any] = [
                "title": title,
                "content": content,
                "memoImageUrls": memoImageUrls
            ]

            print("combinedData: \(combinedData)")

            AuthorizationAlamofire.shared.createRecord(combinedData, 8) { result in
                switch result {
                case .success(let data):
                    if let responseData = data,
                       let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                        print("response jsonData: \(jsonObject)")
                    }

                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
        
    }
}
