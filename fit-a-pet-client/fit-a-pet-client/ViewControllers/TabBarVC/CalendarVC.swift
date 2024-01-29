import UIKit
import SnapKit
import FSCalendar
import SwiftUI

class CalendarVC: UIViewController {
    let calendarStackView = CalendarStackView()
    let calendarView = CalendarView()
    let scheduleView = CalendarScheduleView()
    
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
        
        self.present(navigationController, animated: true)
      
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
        
        scheduleView.selectedDateLabel.text = self.selectedDataFormatter.string(from: date)
        
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleListTableViewCell", for: indexPath) as! ScheduleListTableViewCell
   
        cell.scheduleDateLabel.text = "First Label"
        cell.scheduleNameLabel.text = "Second Label"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}


struct MainViewController_Previews: PreviewProvider {
  static var previews: some View {
    Container().edgesIgnoringSafeArea(.all)
  }
  
  struct Container: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
      let rootViewController = CalendarVC()
      return UINavigationController(rootViewController: rootViewController)
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    typealias UIViewControllerType = UIViewController
  }
}
