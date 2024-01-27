import UIKit
import SnapKit
import PanModal

class CalendarPanModalVC: UIViewController, PanModalDateViewDelegate {

    private let scrollView = UIScrollView()
    private let titleLabel = UILabel()
    let scheduleView = CustomVerticalView(labelText: "일정 이름", placeholder: "일정 이름")
    let locationView = CustomVerticalView(labelText: "장소", placeholder: "장소")
    let otherSettingView = OtherSettingsView()
    
    let dateView = PanModalDateView()
    let dateTimePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupActions()
    }

    private func setupViews() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dateView.delegate = self
        
        dateTimePicker.isHidden = true

        dateTimePicker.datePickerMode = .date
        dateTimePicker.preferredDatePickerStyle = .inline
        
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(scheduleView)
        scrollView.addSubview(locationView)
        scrollView.addSubview(dateView)
        scrollView.addSubview(dateTimePicker)
        scrollView.addSubview(otherSettingView)

        titleLabel.text = "일정 등록하기"
        titleLabel.font = .boldSystemFont(ofSize: 18)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(16)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }

        scheduleView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
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
    }
    
    private func setupActions() {
        otherSettingView.carePetButton.addTarget(self, action: #selector(carePetButtonTapped), for: .touchUpInside)
        otherSettingView.timeAttackButton.addTarget(self, action: #selector(timeAttackButtonTapped), for: .touchUpInside)
    }
    @objc private func carePetButtonTapped() {
        let petPanModalVC = PetPanModalVC(title: "반려동물을 선택하세요")
        
        self.presentPanModal(petPanModalVC)
    }
    @objc private func timeAttackButtonTapped() {
        let timePanModalVC = TimeAttackPanModalVC(title: "시간 제한")

        self.presentPanModal(timePanModalVC)
    }
    
    func datePickerButtonTapped() {
        dateTimePicker.datePickerMode = .date
        dateTimePicker.preferredDatePickerStyle = .inline
        if dateTimePicker.isHidden {
            
            dateTimePicker.isHidden = false
            
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

    func timePickerButtonTapped() {
        dateTimePicker.datePickerMode = .time
        dateTimePicker.preferredDatePickerStyle = .wheels
        if dateTimePicker.isHidden {
            
            dateTimePicker.isHidden = false
            
            dateTimePicker.snp.updateConstraints { make in
                make.height.equalTo(250)
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

extension CalendarPanModalVC: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return scrollView
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

