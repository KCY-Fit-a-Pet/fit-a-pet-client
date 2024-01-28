import UIKit
import SnapKit
import FSCalendar

class CalendarView: UIView, FSCalendarDelegateAppearance {
    let calendar = FSCalendar()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        addSubview(calendar)

        calendar.backgroundColor = UIColor(named: "Secondary")
        calendar.headerHeight = 0
        calendar.weekdayHeight = 40
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.weekdayTextColor = UIColor(named: "Gray5")
        calendar.appearance.selectionColor = UIColor(named: "PrimaryColor")
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerTitleFont = .boldSystemFont(ofSize: 18)

        calendar.locale = Locale(identifier: "ko_KR")

        calendar.appearance.titleTodayColor = UIColor(named: "PrimaryColor")
        calendar.appearance.todayColor = UIColor(named: "Secondary")
        

        calendar.appearance.borderRadius = 0.5
        calendar.appearance.todaySelectionColor = UIColor(named: "PrimaryColor")

        calendar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

