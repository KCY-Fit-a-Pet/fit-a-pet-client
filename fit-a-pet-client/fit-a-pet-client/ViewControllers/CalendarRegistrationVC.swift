import UIKit
import SnapKit
import PanModal

class CalendarRegistrationVC: UIViewController, CalendarDateViewDelegate {

    private let scrollView = UIScrollView()
    private let titleLabel = UILabel()
    private let closeBtn = UIButton()
    let scheduleView = CustomVerticalView(labelText: "일정 이름", placeholder: "일정 이름")
    let locationView = CustomVerticalView(labelText: "장소", placeholder: "장소")
    let otherSettingView = OtherSettingsView()
    
    let registrationBtn = CustomNextBtn(title: "등록하기")
    let dateView = CalendarDateView()
    let dateTimePicker = UIDatePicker()
    
    var selecteDateTime = ""
    var reloadClosure: (() -> Void)?
    
    let dateFormatterUtils = DateFormatterUtils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupActions()
        carePetListAPI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let formattedDate = dateFormatterUtils.formatDateString(dateFormatterUtils.dateFormatter.string(from: dateTimePicker.date))

        ScheduleRegistrationManager.shared.addInput(reservationDate: formattedDate)
        
    }
    
    private func setupNavigationBar() {
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = " "
        
        titleLabel.text = "일정 등록하기"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: titleLabel.frame.width, height: titleLabel.frame.height))
        titleView.addSubview(titleLabel)
        
        navigationItem.titleView = titleView
        
        closeBtn.setImage(UIImage(named: "close_icon"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeBtn)
    }

    private func setupViews() {
        
        view.addSubview(scrollView)
        view.addSubview(registrationBtn)
        view.backgroundColor = .white
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(registrationBtn.snp.top).offset(15)
        }
        
        dateView.delegate = self
        scheduleView.textInputField.delegate = self
        locationView.textInputField.delegate = self
        
        dateTimePicker.isHidden = true
        dateTimePicker.datePickerMode = .date
        dateTimePicker.preferredDatePickerStyle = .inline

        scrollView.addSubview(scheduleView)
        scrollView.addSubview(locationView)
        scrollView.addSubview(dateView)
        scrollView.addSubview(dateTimePicker)
        scrollView.addSubview(otherSettingView)

        scheduleView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(16)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(88)
        }

        locationView.snp.makeConstraints { make in
            make.top.equalTo(scheduleView.snp.bottom).offset(16)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(88)
        }
        
        dateView.snp.makeConstraints { make in
            make.top.equalTo(locationView.snp.bottom).offset(16)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(88)
        }
        
        dateTimePicker.snp.makeConstraints { make in
            make.top.equalTo(dateView.snp.bottom).offset(8)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(0)
        }
        
        otherSettingView.snp.makeConstraints{make in
            make.top.equalTo(dateTimePicker.snp.bottom).offset(16)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.height.equalTo(400)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
        
        registrationBtn.snp.makeConstraints{make in
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.snp.bottom).offset(-50)
        }
    }
    
    private func setupActions() {
        otherSettingView.carePetButton.addTarget(self, action: #selector(carePetButtonTapped), for: .touchUpInside)
        otherSettingView.timeAttackButton.addTarget(self, action: #selector(timeAttackButtonTapped), for: .touchUpInside)
        dateTimePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        registrationBtn.addTarget(self, action: #selector(registrationBtnTapped), for: .touchUpInside)
    }
    @objc private func carePetButtonTapped() {
        let petPanModalVC = PetPanModalVC(title: "반려동물을 선택하세요")
        
        self.presentPanModal(petPanModalVC)
    }
    @objc private func timeAttackButtonTapped() {
        let timePanModalVC = TimeAttackPanModalVC(title: "시간 제한")

        self.presentPanModal(timePanModalVC)
    }
    @objc private func closeBtnTapped() {
        self.dismiss(animated: true)
    }
    
    func datePickerButtonTapped() {
        dateTimePicker.datePickerMode = .date
        dateTimePicker.preferredDatePickerStyle = .inline
        if !dateView.isTimePickerSelected{
            if dateTimePicker.isHidden {
                dateTimePicker.isHidden = false
                selecteDateTime = "date"
                dateTimePicker.snp.updateConstraints { make in
                    make.height.equalTo(300)
                }

            } else {
                dateTimePicker.isHidden = true

                dateTimePicker.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
            }
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
    }

    func timePickerButtonTapped() {
        dateTimePicker.datePickerMode = .time
        dateTimePicker.preferredDatePickerStyle = .wheels
        if !dateView.isDatePickerSelected{
            if dateTimePicker.isHidden {
                dateTimePicker.isHidden = false
                selecteDateTime = "time"
                dateTimePicker.snp.updateConstraints { make in
                    make.height.equalTo(200)
                }

            } else {
                dateTimePicker.isHidden = true

                dateTimePicker.snp.updateConstraints { make in
                    make.height.equalTo(0)
                }
            }
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc func datePickerValueChanged() {
        let formattedDate = dateFormatterUtils.formatDateString(dateFormatterUtils.dateFormatter.string(from: dateTimePicker.date))

        if selecteDateTime == "time" {
            if let formattedTime = DateFormatterUtils.formatTime(formattedDate!, from: "yyyy-MM-dd HH:mm:ss", to: "a h:mm") {
                dateView.timePickerBtn.setTitle(formattedTime, for: .normal)
            }
        }else{
            if let formattedFullDate = DateFormatterUtils.formatFullDate(formattedDate!, from: "yyyy-MM-dd HH:mm:ss", to: "yyyy.MM.dd (E)") {
                dateView.datePickerBtn.setTitle(formattedFullDate, for: .normal)
            }
        }

        ScheduleRegistrationManager.shared.addInput(reservationDate: formattedDate)
        print("Selected Date/Time: \(formattedDate)")
    }
    
    private func carePetListAPI(){
        AuthorizationAlamofire.shared.userPetsList{ result in
            switch result {
            case .success(let data):
                if let responseData = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                           let dataObject = json["data"] as? [String: Any],
                           let petsArray = dataObject["pets"] as? [[String: Any]] {
                            
                            PetList.petsList.removeAll()
                            
                            for petData in petsArray {
                                if let id = petData["id"] as? Int,
                                   let petName = petData["petName"] as? String {
                                    let petProfileImage = petData["petProfileImage"] as? String ?? "uploadImage"
                                    
                                    let pet = PetList(id: id, petName: petName, petProfileImage: petProfileImage, selectPet: false)
                                    PetList.petsList.append(pet)
                                }
                            }
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
    @objc func registrationBtnTapped(){
        
        var selectedPetIds: [Int] = []
        selectedPetIds = PetList.petsList
            .filter { $0.selectPet }
            .map { $0.id }
        
        ScheduleRegistrationManager.shared.addInput(petIds: selectedPetIds)
        ScheduleRegistrationManager.shared.performRegistration()
        
        let combinedData: [String: Any] = [
            "scheduleName": ScheduleRegistrationManager.shared.scheduleName ?? "",
            "location": ScheduleRegistrationManager.shared.location ?? "",
            "reservationDate": ScheduleRegistrationManager.shared.reservationDate ?? "",
            "notifyTime": ScheduleRegistrationManager.shared.notifyTime ?? 0,
            "petIds": ScheduleRegistrationManager.shared.petIds ?? [],
        ]
                
        AuthorizationAlamofire.shared.createSchedule(combinedData){ result in
            switch result {
            case .success(let data):
                if let responseData = data {
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] ?? [:]

                        print("Response JSON Data (User Profile): \(jsonObject)")
                        
                        self.dismiss(animated: true){ [weak self] in
                            self?.reloadClosure?()
                        }

                    } catch {
                        print("Error parsing user profile JSON: \(error)")
                    }
                }

            case .failure(let profileError):
                print("Error fetching user profile info: \(profileError)")
            }
        }
    }
}

extension CalendarRegistrationVC: UITextFieldDelegate{

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == scheduleView.textInputField {
            handleTextChange(for: scheduleView, in: range, replacementString: string)
        } else if textField == locationView.textInputField {
            handleTextChange(for: locationView, in: range, replacementString: string)
        }
        
        return true
    }
    
    private func handleTextChange(for customView: CustomVerticalView, in range: NSRange, replacementString string: String) {
        let newText = (customView.textInputField.text! as NSString).replacingCharacters(in: range, with: string)

        if newText.isEmpty {
            customView.textInputField.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        } else {
            customView.textInputField.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = scheduleView.textInputField.text {
            ScheduleRegistrationManager.shared.addInput(scheduleName: text)
            print("Entered Text: \(text)")
        }
        if let text = locationView.textInputField.text {
            ScheduleRegistrationManager.shared.addInput(location: text)
            print("Entered Text: \(text)")
        }
    }
}
