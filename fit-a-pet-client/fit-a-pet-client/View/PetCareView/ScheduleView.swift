// CategoryView.swift

import UIKit
import SnapKit

class ScheduleView: UIView {
    var scheduleLabel = UILabel()
    var scheduleTextField = UITextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        scheduleLabel.text = "일정 이름"
        scheduleLabel.font = .boldSystemFont(ofSize: 18)
        
        scheduleTextField.placeholder = "일정 카테고리 이름"
        scheduleTextField.font = .systemFont(ofSize: 14)
        scheduleTextField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        scheduleTextField.leftViewMode = .always
        
        scheduleTextField.layer.borderWidth = 1
        scheduleTextField.layer.cornerRadius = 8
        scheduleTextField.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        
        self.addSubview(scheduleLabel)
        self.addSubview(scheduleTextField)
        
        scheduleLabel.snp.makeConstraints { make in
            make.height.equalTo(25)
            make.top.equalTo(self.snp.top)
        }
        
        scheduleTextField.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.top.equalTo(scheduleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
    }
}



