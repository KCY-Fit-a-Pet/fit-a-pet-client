import UIKit
import SnapKit
import FSCalendar
import SwiftUI
import PanModal

class CalendarVC: UIViewController {
    let calendarStackView = CalendarStackView()
    let calendarView = CalendarView()
    
    private lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "yyyy년 M월"
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
        
        setCalendar()
    }

    func initView() {
        calendarStackView.delegate = self
        calendarView.calendar.delegate = self
        view.addSubview(calendarStackView)
        calendarStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }

        view.addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(calendarStackView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
            let height = view.safeAreaLayoutGuide.layoutFrame.height / 2 - navigationBarHeight - 40
            make.height.equalTo(height)
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
           
           print("Selected Date: \(date)")
       }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        print("[INFO] dateFormatter.string(from: date) : " + dateFormatter.string(from: date))
        
        switch dateFormatter.string(from: date) {
            case dateFormatter.string(from: Date()):
            return .blue
            default:
                return nil
        }
    }
    
    func setCalendar() {
        calendarView.calendar.scope = .month
        calendarStackView.titleLabel.text = self.dateFormatter.string(from: calendarView.calendar.currentPage)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendarStackView.titleLabel.text = self.dateFormatter.string(from: calendarView.calendar.currentPage)
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
