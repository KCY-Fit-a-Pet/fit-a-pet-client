import UIKit
import SnapKit
import FSCalendar

class CalendarVC: UIViewController {
    let calendarStackView = CalendarStackView()
    let calendarView = CalendarView()
    let scheduleView = CalendarScheduleView()
    
    var scheduleListResponse: ScheduleListResponse?
    
    private lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "yyyy년 M월"
        return df
    }()
    
    private lazy var selectedDataFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "dd. E"
        return df
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Secondary")
        setupNavigationBar()
        initView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scheduleView.selectedDateLabel.text = self.selectedDataFormatter.string(from: Date())
        setCalendar()
        
        let currentDateComponents: DateComponents = {
            if SelectedDate.date == Date() {
                scheduleView.selectedDateLabel.text = self.selectedDataFormatter.string(from: Date())
                return Calendar.current.dateComponents([.year, .month, .day], from: Date())
            }
            scheduleView.selectedDateLabel.text = self.selectedDataFormatter.string(from: SelectedDate.date!)
            return Calendar.current.dateComponents([.year, .month, .day], from: SelectedDate.date!)
        }()
        
        petScheduleListAPI(
            String(currentDateComponents.year ?? 0),
            String(currentDateComponents.month ?? 0),
            String(currentDateComponents.day ?? 0)
        )
    }

    func initView() {
        calendarStackView.delegate = self
        calendarView.calendar.delegate = self
        view.addSubview(calendarStackView)
        view.addSubview(calendarView)
        view.addSubview(scheduleView)
        
        scheduleView.backgroundColor = .white
        scheduleView.layer.cornerRadius = 35
        
        scheduleView.scheduleListCollectionView.delegate = self
        scheduleView.scheduleListCollectionView.dataSource = self
        scheduleView.scheduleListCollectionView.register(ScheduleListCollectionViewCell.self, forCellWithReuseIdentifier: "ScheduleListCollectionViewCell")
        
        calendarStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }
        
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(calendarStackView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
            let height = view.safeAreaLayoutGuide.layoutFrame.height / 2 - navigationBarHeight - 100
            make.height.equalTo(height)
        }
        
        scheduleView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    func setupNavigationBar() {
        let leftLabel = UILabel()
        leftLabel.text = "달력"
        leftLabel.font = .boldSystemFont(ofSize: 18)
        leftLabel.textColor = .black

        let leftItem = UIBarButtonItem(customView: leftLabel)
        navigationItem.leftBarButtonItem = leftItem

        let addButton = UIBarButtonItem(image: UIImage(named: "icon_add"), style: .plain, target: self, action: #selector(didTapAddButton))
        addButton.tintColor = UIColor(named: "PrimaryColor")
        navigationItem.rightBarButtonItem = addButton
    }

    @objc func didTapAddButton() {
        let calendarRegistrationVC = CalendarRegistrationVC()
        let navigationController = UINavigationController(rootViewController: calendarRegistrationVC)
        
        calendarRegistrationVC.reloadClosure = { [weak self] in
            self?.viewWillAppear(true)
        }
        
        self.present(navigationController, animated: true)
    }
    func petScheduleListAPI(_ year: String, _ month: String, _ day: String){
        AuthorizationAlamofire.shared.petScheduleList(year, month, day){ result in
            switch result {
            case .success(let data):
                if let responseData = data {
                    do {
                        self.scheduleListResponse = try JSONDecoder().decode(ScheduleListResponse.self, from: responseData)
                        self.scheduleView.scheduleListCollectionView.reloadData()
                        let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] ?? [:]
                        
                        print("Response JSON Data (User Profile): \(jsonObject)")
                        
                        
                    } catch {
                        print("Error decoding schedule list JSON: \(error)")
                    }
                }
                
            case .failure(let profileError):
                print("Error fetching user pets list: \(profileError)")
            }
        }
    }
}

extension CalendarVC: CalendarStackViewDelegate{
    @objc func didTapPrevButton() {
        let currentMonth = calendarView.calendar.currentPage
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? Date()
        calendarView.calendar.setCurrentPage(previousMonth, animated: true)
    }
    
    @objc func didTapNextButton() {
        let currentMonth = calendarView.calendar.currentPage
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? Date()
        calendarView.calendar.setCurrentPage(nextMonth, animated: true)
    }
}

extension CalendarVC: FSCalendarDelegate, FSCalendarDelegateAppearance{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        scheduleView.selectedDateLabel.text = self.selectedDataFormatter.string(from: date)
        SelectedDate.date = date
        
        if let year = components.year,
           let month = components.month,
           let day = components.day {
            petScheduleListAPI(String(year),String(month),String(day))
            self.scheduleView.scheduleListCollectionView.reloadData()
        }
        
        print("Selected Date: \(date)")
    }
    
    func setCalendar() {
        calendarView.calendar.scope = .month
        calendarStackView.titleLabel.text = self.dateFormatter.string(from: calendarView.calendar.currentPage)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendarStackView.titleLabel.text = self.dateFormatter.string(from: calendarView.calendar.currentPage)
    }
}

extension CalendarVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scheduleListResponse?.data.schedules.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleListCollectionViewCell", for: indexPath) as! ScheduleListCollectionViewCell

        let date = scheduleListResponse?.data.schedules[indexPath.item].reservationDate
        let formattedTime = DateFormatterUtils.formatTime(date!, from: "yyyy-MM-dd HH:mm:ss", to: "a h:mm")
        cell.scheduleTimeLabel.text = formattedTime
        cell.scheduleNameLabel.text = scheduleListResponse?.data.schedules[indexPath.item].scheduleName
        cell.scheduleLocationLabel.text = scheduleListResponse?.data.schedules[indexPath.item].location
        cell.updatePetImage((scheduleListResponse?.data.schedules[indexPath.item].pets)!)
        
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 130)
    }
}
