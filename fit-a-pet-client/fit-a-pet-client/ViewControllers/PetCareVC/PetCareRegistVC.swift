import UIKit
import SnapKit
import PanModal

//TODO: 요일 하나는 무조건 선택되어 있도록
//TODO: 카테고리 중복 체크
class PetCareRegistVC: CustomEditNavigationBar {

    private var categories: [Categories] = []
    private var careDateLabel = UILabel()
    private var careDateChange = UIButton()
    private let daysOfWeek = ["일","월", "화", "수", "목", "금", "토"]
    
    private let categoryView = CategoryView()
    private let scheduleView = ScheduleView()
    private let otherSettingView = OtherSettingsView()

    var checkNewCategory = false
    var selectedTime = ""
    var currentState: ViewState = .datePicker
    var selectedIndices: Set<Int> = []
    
    private var daysCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CareDateCollectionViewCell.self, forCellWithReuseIdentifier: "dayCollectionViewCell")
        return collectionView
    }()
    
    private var daysTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CareDateTableViewCell.self, forCellReuseIdentifier: "dayTableViewCell")
        return tableView
    }()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(PetCareRegistVC.self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    let careScrollView = UIScrollView()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupDelegates()
        setupActions()
        setupDefaultSelection()
        carePetListAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectCurrentDay()
    }
    
    // MARK: - Setup Functions

    private func setupViews() {
        view.backgroundColor = .white
        initView()
    }
    
    private func setupDelegates() {
        categoryView.categoryTextField.delegate = self
        scheduleView.scheduleTextField.delegate = self
        daysCollectionView.dataSource = self
        daysCollectionView.delegate = self
        daysTableView.dataSource = self
        daysTableView.delegate = self
    }
    
    private func setupDefaultSelection() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        selectedTime = dateFormatter.string(from: Date())
    }
    
    private func setupActions() {
        categoryView.categoryButton.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        careDateChange.addTarget(self, action: #selector(careDateChangeTapped), for: .touchUpInside)
        otherSettingView.carePetButton.addTarget(self, action: #selector(carePetButtonTapped), for: .touchUpInside)
        otherSettingView.timeAttackButton.addTarget(self, action: #selector(timeAttackButtonTapped), for: .touchUpInside)
    }
    
    private func selectCurrentDay() {
        let currentDayIndex = getCurrentDayIndex()
        let defaultIndexPath = IndexPath(item: currentDayIndex, section: 0)
        selectedIndices.insert(currentDayIndex)
        daysCollectionView.selectItem(at: defaultIndexPath, animated: false, scrollPosition: .left)
    }
    
    func initView() {
        
        careScrollView.layer.borderWidth = 2
        careScrollView.layer.borderColor = UIColor.blue.cgColor
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(careDateLabel)
        stackView.addArrangedSubview(careDateChange)
        
        //밑줄 넣기
        let attributedString = NSAttributedString(string: "요일별로 다르게 설정", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])

        careDateChange.setAttributedTitle(attributedString, for: .normal)
        careDateChange.setTitleColor(UIColor(named: "Gray5"), for: .normal)
        careDateChange.titleLabel?.font = .systemFont(ofSize: 12)
        
        careDateLabel.text = "케어 날짜"
        careDateLabel.font = .boldSystemFont(ofSize: 18)
        
        daysTableView.isHidden = true
        datePicker.isHidden = false
        
        careScrollView.addSubview(categoryView)
        careScrollView.addSubview(scheduleView)
        
        careScrollView.addSubview(stackView)
        careScrollView.addSubview(daysCollectionView)
        careScrollView.addSubview(daysTableView)
        careScrollView.addSubview(datePicker)
        careScrollView.addSubview(otherSettingView)
        view.addSubview(careScrollView)
        

        
        careScrollView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        categoryView.snp.makeConstraints { make in
            make.height.equalTo(88)
            make.top.equalTo(careScrollView.snp.top).offset(10)
            make.leading.equalTo(view.snp.leading).inset(16)
            make.trailing.equalTo(view.snp.trailing).inset(16)
            
        }
        
        scheduleView.snp.makeConstraints { make in
            make.height.equalTo(88)
            make.top.equalTo(categoryView.snp.bottom).offset(24)
            make.leading.equalTo(view.snp.leading).inset(16)
            make.trailing.equalTo(view.snp.trailing).inset(16)
        }

        stackView.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.top.equalTo(scheduleView.snp.bottom).offset(32)
            make.leading.equalTo(view.snp.leading).inset(16)
            make.trailing.equalTo(view.snp.trailing).inset(16)
        }

        daysCollectionView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.leading.equalTo(view.snp.leading).inset(16)
            make.trailing.equalTo(view.snp.trailing).inset(16)
        }

        daysTableView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.top.equalTo(daysCollectionView.snp.bottom).offset(8)
            make.leading.equalTo(view.snp.leading).inset(16)
            make.trailing.equalTo(view.snp.trailing).inset(16)
        }
        datePicker.snp.makeConstraints { make in
            make.height.equalTo(180)
            make.top.equalTo(daysCollectionView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }

        otherSettingView.snp.makeConstraints { make in
            make.height.equalTo(147)
            make.top.equalTo(datePicker.snp.bottom).offset(24)
            make.leading.equalTo(view.snp.leading).inset(16)
            make.trailing.equalTo(view.snp.trailing).inset(16)
            make.bottom.equalTo(careScrollView.snp.bottom)
        }
    }
    
    // MARK: - Helper Functions

    private func getCurrentDayIndex() -> Int {
        let calendar = Calendar.current
        let today = calendar.component(.weekday, from: Date()) - 1
        return today >= 0 ? today : 0
    }
    
    @objc private func showMenu() {
        
       
        AuthorizationAlamofire.shared.checkCareCategory(SelectedPetId.petId){ result in
            switch result {
            case .success(let data):
                if let responseData = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                           let dataObject = json["data"] as? [String: Any],
                           let careCategories = dataObject["careCategories"] as? [[String: Any]] {
                            
                            for care in careCategories {
                                
                                if let categoryName = care["categoryName"] as? String,
                                   let id = care["id"] as? Int {
                                    let category = Categories(categoryName: categoryName, id: id)
                                    self.categories.append(category)
                                    print("categories: \(self.categories)")
                                }
                            }
                            // "새로 입력하기" 메뉴 아이템 정의
                            let newCategoryAction = UIAction(title: "새로 입력하기") { [self] action in
                                print("새로 입력하기")
                                checkNewCategory = true
  
                                categoryView.categoryTextField.text = ""
                                categoryView.categoryTextField.isUserInteractionEnabled = true
                                categoryView.categoryTextField.becomeFirstResponder()
                            }
                            
                            let categoryActions = self.categories.map { category in
                                UIAction(title: category.categoryName) { [weak self] _ in
                                    self!.categoryView.categoryTextField.text = category.categoryName
                                    self!.categoryView.categoryTextField.isUserInteractionEnabled = false
                                    PetCareRegistrationManager.shared.addInput(category: (categoryId: category.id, categoryName: category.categoryName))
                                }
                            }
                            
                            // 메뉴 구성
                            let menu = UIMenu(
                                title: "",
                                children: categoryActions + [newCategoryAction]
                            )
                            
                            // 메뉴를 버튼에 할당하고, 주요 액션으로 표시되도록 설정
                            self.categoryView.categoryButton.menu = menu
                            self.categoryView.categoryButton.showsMenuAsPrimaryAction = true
                            self.categoryView.categoryButton.isUserInteractionEnabled = true
                            
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
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        selectedTime = dateFormatter.string(from: selectedDate)
        
        
        for index in selectedIndices {
            let currentWeek = daysOfWeek[index]
    
            if let existingIndex = CareDate.commonData.firstIndex(where: { $0.week == currentWeek }) {
                CareDate.commonData[existingIndex].time = selectedTime
            } else {
                CareDate.commonData.append(CareDate(week: currentWeek, time: selectedTime))
            }
        }
        
        print(CareDate.commonData)
    }
    
    @objc private func careDateChangeTapped() {
        switch currentState {
        case .daysTableView:
            daysTableView.isHidden = true
            datePicker.isHidden = false
            currentState = .datePicker
            ViewState.stateNum = 0
        case .datePicker:
            daysTableView.isHidden = false
            datePicker.isHidden = true
            currentState = .daysTableView
            ViewState.stateNum = 1
        }
    }
    
    @objc private func carePetButtonTapped() {
        let petPanModalVC = PetPanModalVC()
        
        self.presentPanModal(petPanModalVC)
    }
    @objc private func timeAttackButtonTapped() {
        let timePanModalVC = TimeAttackPanModalVC()

        self.presentPanModal(timePanModalVC)
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
                            
                            print(petsArray)
                            
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
}
// MARK: - UITextFieldDelegate

extension PetCareRegistVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = categoryView.categoryTextField.text {
            if checkNewCategory{
                PetCareRegistrationManager.shared.addInput(category: (categoryId: 0, categoryName: text))
            }
            print("Entered Text: \(text)")
        }
        if let text = scheduleView.scheduleTextField.text {
            PetCareRegistrationManager.shared.addInput(careName: text)
            
            print("Entered Text: \(text)")
        }
    }
}
// MARK: - UICollectionViewDelegateFlowLayout

extension PetCareRegistVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 44, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
}
// MARK: - UICollectionViewDataSource
extension PetCareRegistVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysOfWeek.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCollectionViewCell", for: indexPath) as! CareDateCollectionViewCell
        cell.label.text = daysOfWeek[indexPath.item]
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension PetCareRegistVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndices.insert(indexPath.item)
        print(daysOfWeek[indexPath.item])
        
        let currentWeek = daysOfWeek[indexPath.item]
        
        CareDate.commonData.append(CareDate(week: currentWeek, time: selectedTime))
        CareDate.eachData.append(CareDate(week: currentWeek, time: selectedTime))
        print("cell 클릭: \(CareDate.commonData)")
        print("cell 클릭: \(CareDate.eachData)")
        
        daysTableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedIndices.remove(indexPath.item)

        let currentWeek = daysOfWeek[indexPath.item]
        
        if let existingIndex = CareDate.commonData.firstIndex(where: { $0.week == currentWeek }) {
            CareDate.commonData.remove(at: existingIndex)
            CareDate.eachData.remove(at: existingIndex)
        }

        daysTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension PetCareRegistVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedIndices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayTableViewCell", for: indexPath) as! CareDateTableViewCell
        
        let selectedIndex = selectedIndices.sorted()[indexPath.row]
        let selectedDay = daysOfWeek[selectedIndex]
        let selectedDate = Date()
        
        cell.configure(withDate: selectedDay, selectedDate: selectedDate)
        return cell
        
    }
    
}

// MARK: - UITableViewDelegate

extension PetCareRegistVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



