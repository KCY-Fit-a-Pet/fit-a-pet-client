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
        navigationController?.popToRootViewController(animated: true)
    }

    @objc func saveButtonTapped() {
        
        switch (currentTitle) {
        case "비밀번호 변경":
            return editUserPwAPI()
        case "이름 변경하기":
            return editUserNameAPI()
        case "케어 등록하기":
            return careCategoryCheckAPI()
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
}
