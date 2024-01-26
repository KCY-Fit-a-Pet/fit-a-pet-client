import UIKit
import SnapKit
import PanModal

class CalendarPanModalVC: UIViewController {

    private let titleLabel = UILabel()
    let scheduleView = CustomVerticalView(labelText: "일정 이름", placeholder: "일정 이름")
    let locationView = CustomVerticalView(labelText: "장소", placeholder: "장소")
    
    let dateView = UIView()
    let dateLabel = UILabel()
    let dateStackView = UIStackView()

    let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(scheduleView)
        view.addSubview(locationView)
        view.addSubview(dateView)
        
        dateView.addSubview(dateLabel)
        dateView.addSubview(dateStackView)
        
        dateStackView.addArrangedSubview(datePicker)

        dateStackView.axis = .vertical
        dateStackView.spacing = 8
        dateStackView.distribution = .fill

        dateLabel.text = "날짜"
        dateLabel.font = .boldSystemFont(ofSize: 18)

        titleLabel.text = "일정 등록하기"
        titleLabel.font = .boldSystemFont(ofSize: 18)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }

        scheduleView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(88)
        }

        locationView.snp.makeConstraints { make in
            make.top.equalTo(scheduleView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(88)
        }
        
        dateView.snp.makeConstraints { make in
            make.top.equalTo(locationView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(88)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        dateStackView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}


extension CalendarPanModalVC: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }

    var longFormHeight: PanModalHeight {
        return .maxHeight
    }

    var anchorModalToLongForm: Bool {
        return false
    }

    var panModalBackgroundColor: UIColor {
        return UIColor.white
    }
}

