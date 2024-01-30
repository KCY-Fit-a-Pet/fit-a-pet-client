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
        
        scheduleView.scheduleListTableView.delegate = self
        scheduleView.scheduleListTableView.dataSource = self
        scheduleView.scheduleListTableView.register(ScheduleListTableViewCell.self, forCellReuseIdentifier: "ScheduleListTableViewCell")
        
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

        let addButton = UIBarButtonItem(image: UIImage(named: "calendar_add"), style: .plain, target: self, action: #selector(didTapAddButton))
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
                        
                        let schedules = self.scheduleListResponse!.data.schedules
                        self.scheduleView.scheduleListTableView.reloadData()
                        for schedule in schedules {
                            print("Reservation Date: \(schedule.reservationDate)")
                            print("Schedule ID: \(schedule.scheduleId)")
                            print("Schedule Name: \(schedule.scheduleName)")
                            print("Location: \(schedule.location)")
                            
                            for pet in schedule.pets {
                                print("Pet ID: \(pet.petId)")
                                print("Pet Profile Image: \(pet.petProfileImage)")
                            }
                        }
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
            self.scheduleView.scheduleListTableView.reloadData()
        }
        
        print("Selected Date: \(date)")
    }
    
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//
//        print("[INFO] dateFormatter.string(from: date) : " + dateFormatter.string(from: date))
//
//        switch dateFormatter.string(from: date) {
//            case dateFormatter.string(from: Date()):
//            return .blue
//            default:
//                return nil
//        }
//    }
    
    func setCalendar() {
        calendarView.calendar.scope = .month
        calendarStackView.titleLabel.text = self.dateFormatter.string(from: calendarView.calendar.currentPage)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendarStackView.titleLabel.text = self.dateFormatter.string(from: calendarView.calendar.currentPage)
    }
}

extension CalendarVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleListResponse?.data.schedules.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleListTableViewCell", for: indexPath) as! ScheduleListTableViewCell
        
        let date = scheduleListResponse?.data.schedules[indexPath.row].reservationDate
        
        cell.scheduleDateLabel.text = DateFormatterUtils.formatTotalDate(date!)
        cell.scheduleNameLabel.text = scheduleListResponse?.data.schedules[indexPath.row].scheduleName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
