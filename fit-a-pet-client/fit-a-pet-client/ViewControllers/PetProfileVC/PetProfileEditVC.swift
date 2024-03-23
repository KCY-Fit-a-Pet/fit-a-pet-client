

import UIKit
import SnapKit

class PetProfileEditVC: CustomNavigationBar{
    
    private let imagePickerUtil = ImagePickerUtil()
    private let choosePhotoBtn = UIButton()
    private let scrollView = UIScrollView()
    private let basicUserInofoView = BasicUserInfoView()
    private let addInfoLabel = UILabel()
    private let feedInputView = CustomVerticalView(labelText: "사료", placeholder: "사료")
    
    private let deleteButton = UIButton()
    private let editButton = CustomNextBtn(title: "수정하기")
    
    var birthTapGestureRecognizer: UITapGestureRecognizer!
    var genderTapGestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        setupActions()
        petTotalInfoCheckAPI()
        
        self.basicUserInofoView.nameInputView.textInputField.delegate = self
        self.basicUserInofoView.birthdayView.ageInputTextFeild.delegate = self
        self.feedInputView.textInputField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCellSelectedFromGenderPanModal(_:)), name: .cellSelectedFromGenderPanModal, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    func initView(){
        view.backgroundColor = .white

        scrollView.addSubview(choosePhotoBtn)
        scrollView.addSubview(basicUserInofoView)
        scrollView.addSubview(addInfoLabel)
        scrollView.addSubview(feedInputView)
        scrollView.addSubview(deleteButton)
        scrollView.addSubview(editButton)
        view.addSubview(scrollView)
        
        choosePhotoBtn.setImage(UIImage(named: "uploadPhoto"), for: .normal)
        
        addInfoLabel.text = "추가 정보"
        addInfoLabel.font = .boldSystemFont(ofSize: 16)
        
        deleteButton.setTitle("삭제하기", for: .normal)
        deleteButton.setTitleColor(UIColor(named: "Danger"), for: .normal)
        deleteButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        
        scrollView.snp.makeConstraints{make in
            make.top.bottom.leading.trailing.equalTo(view)
        }
        
        choosePhotoBtn.snp.makeConstraints{ make in
            make.width.equalTo(120)
            make.height.equalTo(120)
            make.centerX.equalToSuperview()
            make.top.equalTo(scrollView.snp.top).offset(16)
        }
        
        basicUserInofoView.snp.makeConstraints{make in
            make.top.equalTo(choosePhotoBtn.snp.bottom).offset(16)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(400)
        }
        
        addInfoLabel.snp.makeConstraints{make in
            make.leading.trailing.equalTo(view).inset(16)
            make.top.equalTo(basicUserInofoView.snp.bottom).offset(16)
            make.height.equalTo(24)
        }
        
        feedInputView.snp.makeConstraints{make in
            make.leading.trailing.equalTo(view).inset(16)
            make.top.equalTo(addInfoLabel.snp.bottom)
            make.height.equalTo(88)
        }
        
        deleteButton.snp.makeConstraints{make in
            make.height.equalTo(44)
            make.width.equalTo(50)
            make.centerX.equalTo(view)
            make.top.equalTo(feedInputView.snp.bottom).offset(58)
        }
        
        editButton.snp.makeConstraints{make in
            make.top.equalTo(deleteButton.snp.bottom).offset(40)
            make.leading.trailing.equalTo(view).inset(16)
            make.height.equalTo(56)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
      
    }
    
    private func setupActions() {
        choosePhotoBtn.addTarget(self, action: #selector(choosePhotoButtonTapped), for: .touchUpInside)
        basicUserInofoView.genderView.neuteringCheckboxButton.addTarget(self, action: #selector(checkboxButtonTapped), for: .touchUpInside)
        basicUserInofoView.birthdayView.ageCheckboxButton.addTarget(self, action: #selector(ageCheckboxButtonTapped), for: .touchUpInside)
        basicUserInofoView.datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        genderTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(genderViewTapped))
        basicUserInofoView.genderView.genderStackView.addGestureRecognizer(genderTapGestureRecognizer)
        
        birthTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(datePickerViewTapped))
        basicUserInofoView.birthdayView.birthdayStackView.addGestureRecognizer(birthTapGestureRecognizer)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    private func petTotalInfoCheckAPI() {
        AuthorizationAlamofire.shared.petTotalInfoCheck(SelectedPetId.petId) { result in
            switch result {
            case .success(let data):
                if let responseData = data,
                   let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                   let dataObject = jsonObject["data"] as? [String: Any],
                   let petObject = dataObject["pet"] as? [String: Any] {
                    
                    let id = petObject["id"] as? Int ?? 0
                    let petName = petObject["petName"] as? String ?? ""
                    let petProfileImage = petObject["petProfileImage"] as? String ?? ""
                    let gender = petObject["gender"] as? String ?? ""
                    let neutered = petObject["neutered"] as? Bool ?? false
                    let birthdate = petObject["birthdate"] as? String ?? ""
                    let species = petObject["species"] as? String ?? ""
                    let feed = petObject["feed"] as? String ?? ""
                    
                    self.basicUserInofoView.nameInputView.textInputField.text = petName
                    self.basicUserInofoView.genderView.selectedGenderLabel.text = (gender == "FEMALE" ? "암컷" : "수컷")
                    self.basicUserInofoView.birthdayView.selectedBirthdayLabel.text = birthdate
                    self.basicUserInofoView.genderView.neuteringCheckboxButton.isSelected = neutered
                    self.feedInputView.textInputField.text = feed
                    self.basicUserInofoView.genderView.updateCheckboxColor()
                    self.editButton.backgroundColor = UIColor(named: "Primary")
                    
                    let newPetEditData = PetEditData(id: id, petName: petName, petProfileImage: petProfileImage, gender: gender, neutered: neutered, birthdate: birthdate, species: species, feed: feed)
                    
                    PetDataManager.petEditData = newPetEditData
                    print(PetDataManager.petEditData)
                }
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    @objc private func genderViewTapped() {
        let nextVC = SelectGenderPanModalVC()
        self.presentPanModal(nextVC)
    }
    
    @objc func datePickerViewTapped() {

        if basicUserInofoView.datePicker.isHidden {
            basicUserInofoView.datePicker.isHidden = false
           
            basicUserInofoView.datePicker.snp.updateConstraints { make in
                make.height.equalTo(300)
            }
            
            basicUserInofoView.snp.updateConstraints { make in
                make.height.equalTo(700)
            }
            
            
        } else {
            basicUserInofoView.datePicker.isHidden = true
            
            basicUserInofoView.datePicker.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            basicUserInofoView.snp.updateConstraints { make in
                make.height.equalTo(400)
            }
            
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }

    }
    
    @objc func datePickerValueChanged() {

        let formattedDate = DateFormatterUtils.formatDateString(DateFormatterUtils.dateFormatter.string(from: basicUserInofoView.datePicker.date))
        let date =  DateFormatterUtils.formatFullDate(formattedDate!, from: "yyyy-MM-dd HH:mm:ss", to: "yyyy.MM.dd (E)")
        
        basicUserInofoView.birthdayView.selectedBirthdayLabel.text = date
        PetDataManager.petEditData.birthdate = formattedDate!
    }
    
    @objc func checkboxButtonTapped() {
        self.basicUserInofoView.genderView.neuteringCheckboxButton.isSelected.toggle()
        print( self.basicUserInofoView.genderView.neuteringCheckboxButton.isSelected)
        self.basicUserInofoView.genderView.updateCheckboxColor()
    }
    
    @objc func ageCheckboxButtonTapped(){
        self.basicUserInofoView.birthdayView.ageCheckboxButton.isSelected.toggle()
        
        if self.basicUserInofoView.birthdayView.ageCheckboxButton.isSelected{
            birthTapGestureRecognizer.isEnabled = false
        }else{
            birthTapGestureRecognizer.isEnabled = true
        }
        
        self.basicUserInofoView.birthdayView.updateCheckboxColor()
    }
    
    @objc func choosePhotoButtonTapped(_ sender: UIButton) {
           imagePickerUtil.present(from: self) { image in
               if let selectedImage = image {
                   // 선택한 이미지 처리 코드 
               } else {
                   //이미지 선택하지 않은 경우 처리 코드
               }
           }
       }

    @objc private func handleCellSelectedFromGenderPanModal(_ notification: Notification){
        self.basicUserInofoView.genderView.selectedGenderLabel.text =  (PetDataManager.petEditData.gender == "FEMALE" ? "암컷" : "수컷")
    }
    
    @objc private func editButtonTapped(){
        
        self.view.endEditing(true)//모든 textField 편집 종료
        
        let petEditData = PetDataManager.petEditData
        
        let combinedData: [String: Any] = [
            "petName": petEditData.petName,
            "gender": petEditData.gender,
            "neutralization": petEditData.neutered,
            "birthdate": petEditData.birthdate,
            "species": petEditData.species,
            "feed": petEditData.feed
        ]
        
        AuthorizationAlamofire.shared.petInfoEdit(SelectedPetId.petId, combinedData){ result in
            switch result {
            case .success(let data):
                if let responseData = data,
                   let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                    print("response jsonData: \(jsonObject)")
                    self.navigationController?.popViewController(animated: true)
                }
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    @objc func deleteButtonTapped(){
        AuthorizationAlamofire.shared.petDelete(SelectedPetId.petId){ result in
            switch result {
            case .success(let data):
                if let responseData = data,
                   let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                    print("response jsonData: \(jsonObject)")
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
extension PetProfileEditVC: UITextFieldDelegate{

    func textFieldDidEndEditing(_ textfield: UITextField) {
        
        if let text = textfield.text{
            if textfield == self.basicUserInofoView.nameInputView.textInputField {
                PetDataManager.petEditData.petName = text
                print(PetDataManager.petEditData)
            } else if textfield == self.basicUserInofoView.birthdayView.ageInputTextFeild{
                let calendar = Calendar.current
                let currentDate = Date()
                let currentComponents = calendar.dateComponents([.year], from: currentDate)
                let currentYear = currentComponents.year!
                let birthdateComponents = DateComponents(year: currentYear - Int(text)! + 1, month: 1, day: 1)
                let birthdate = calendar.date(from: birthdateComponents)!

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let formattedBirthdate = dateFormatter.string(from: birthdate)

                PetDataManager.petEditData.birthdate = formattedBirthdate
                
            } else if textfield == self.feedInputView.textInputField{
                PetDataManager.petEditData.feed = text
                print(PetDataManager.petEditData)
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
