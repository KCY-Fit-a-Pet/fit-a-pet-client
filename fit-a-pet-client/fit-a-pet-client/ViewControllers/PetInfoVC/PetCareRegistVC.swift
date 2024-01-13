import UIKit
import SnapKit
import SwiftUI
import PanModal

class PetCareRegistVC: CustomEditNavigationBar {

    private var categories = [String]()
    private var careDateLabel = UILabel()
    private var careDateChange = UIButton()
    private let daysOfWeek = ["일","월", "화", "수", "목", "금", "토"]
    
    private let categoryView = CategoryView()
    private let scheduleView = ScheduleView()
    private let otherSettingView = OtherSettingsView()

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
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    private let careScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white

        initView()
        careDateView()

        categoryView.categoryButton.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        careDateChange.addTarget(self, action: #selector(careDateChangeTapped), for: .touchUpInside)
        
        otherSettingView.carePetButton.addTarget(self, action: #selector(carePetButtonTapped), for: .touchUpInside)

        daysCollectionView.dataSource = self
        daysCollectionView.delegate = self
        
        daysTableView.dataSource = self
        daysTableView.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentDayIndex = getCurrentDayIndex()

        // Select the current day
        let defaultIndexPath = IndexPath(item: currentDayIndex, section: 0)
        daysCollectionView.selectItem(at: defaultIndexPath, animated: false, scrollPosition: .left)
    }
    
    func initView() {
        view.addSubview(careScrollView)
        careScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        careScrollView.addSubview(categoryView)
        careScrollView.addSubview(scheduleView)
        
        categoryView.snp.makeConstraints { make in
            make.height.equalTo(88)
            make.top.equalTo(careScrollView.snp.top).offset(10)
            make.edges.width.equalTo(careScrollView).inset(16)
        }
        
        scheduleView.snp.makeConstraints { make in
            make.height.equalTo(88)
            make.top.equalTo(categoryView.snp.bottom).offset(24)
            make.leading.equalTo(careScrollView).inset(16)
            make.trailing.equalTo(careScrollView).inset(16)
        }
    }
    
    func careDateView(){
        
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
        
        careScrollView.addSubview(stackView)
        careScrollView.addSubview(daysCollectionView)
        careScrollView.addSubview(datePicker)
        careScrollView.addSubview(daysTableView)
        
        daysTableView.isHidden = true
        datePicker.isHidden = false
        
        stackView.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.top.equalTo(scheduleView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        daysCollectionView.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        daysTableView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.top.equalTo(daysCollectionView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        datePicker.snp.makeConstraints { make in
            make.height.equalTo(180)
            make.top.equalTo(daysCollectionView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        careScrollView.addSubview(otherSettingView)
        
        otherSettingView.snp.makeConstraints { make in
            make.height.equalTo(88)
            make.top.equalTo(datePicker.snp.bottom).offset(24)
            make.leading.equalTo(careScrollView).inset(16)
            make.trailing.equalTo(careScrollView).inset(16)
        }
    }

    private func getCurrentDayIndex() -> Int {
        let calendar = Calendar.current
        let today = calendar.component(.weekday, from: Date()) - 1
        return today >= 0 ? today : 0
    }
    
    @objc private func showMenu() {
        
        AuthorizationAlamofire.shared.checkCareCategory{ result in
            switch result {
            case .success(let data):
                if let responseData = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                           let dataObject = json["data"] as? [String: Any],
                           let careCategories = dataObject["careCategories"] as? [Any] {
                            self.categories = careCategories.compactMap { String(describing: $0) }
                            print("careCategories: \(careCategories)")
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        
        // "새로 입력하기" 메뉴 아이템 정의
        let newCategoryAction = UIAction(title: "새로 입력하기") { [self] action in
            print("새로 입력하기")
            categoryView.categoryTextField.text = ""
            categoryView.categoryTextField.isUserInteractionEnabled = true
            categoryView.categoryTextField.becomeFirstResponder()
        }
        
        let categoryActions = categories.map { category in
            UIAction(title: category) { [weak self] _ in
                self!.categoryView.categoryTextField.text = category
                self!.categoryView.categoryTextField.isUserInteractionEnabled = false
            }
        }

        // 메뉴 구성
        let menu = UIMenu(
            title: "",
            children: categoryActions + [newCategoryAction]
        )

        // 메뉴를 버튼에 할당하고, 주요 액션으로 표시되도록 설정
        categoryView.categoryButton.menu = menu
        categoryView.categoryButton.showsMenuAsPrimaryAction = true
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        print("Selected Date: \(selectedDate)")
    }
    
    @objc private func careDateChangeTapped() {
        switch currentState {
        case .daysTableView:
            daysTableView.isHidden = true
            datePicker.isHidden = false
            currentState = .datePicker
        case .datePicker:
            daysTableView.isHidden = false
            datePicker.isHidden = true
            currentState = .daysTableView
        }
    }
    
    @objc private func carePetButtonTapped() {
        let petPanModalVC = PetPanModalVC(title: "반려동물을 선택하세요")
        presentPanModal(petPanModalVC)
    }
    
}

extension PetCareRegistVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        categoryView.categoryTextField.resignFirstResponder()
        return true
    }
}

extension PetCareRegistVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 43, height: 43)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
}
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

extension PetCareRegistVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndices.insert(indexPath.item)
        daysTableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedIndices.remove(indexPath.item)
        daysTableView.reloadData()
    }
}

extension PetCareRegistVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedIndices.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dayTableViewCell", for: indexPath) as! CareDateTableViewCell
            
            let currentDayIndex = getCurrentDayIndex()
            let currentDay = daysOfWeek[currentDayIndex]
            let currentDate = Date()
            
            cell.configure(withDate: currentDay, selectedDate: currentDate)
            return cell
        } else {
            let adjustedIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            let cell = tableView.dequeueReusableCell(withIdentifier: "dayTableViewCell", for: adjustedIndexPath) as! CareDateTableViewCell
            
            let selectedIndex = selectedIndices.sorted()[adjustedIndexPath.row]
            let selectedDay = daysOfWeek[selectedIndex]
            let selectedDate = Date()
            
            cell.configure(withDate: selectedDay, selectedDate: selectedDate)
            return cell
        }
    }
    
}

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



// MARK: - Preview

struct MainViewController_Previews: PreviewProvider {
  static var previews: some View {
    Container().edgesIgnoringSafeArea(.all)
  }
  
  struct Container: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let rootViewController = PetCareRegistVC(title: "반려동물 등록하기")
      return UINavigationController(rootViewController: rootViewController)
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    typealias UIViewControllerType = UIViewController
  }
}
