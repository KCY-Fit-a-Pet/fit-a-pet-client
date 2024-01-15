import UIKit
import SnapKit

class CareDateTableViewCell: UITableViewCell {

    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .automatic
        return datePicker
    }()
    
    private var currentWeek: String = ""

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupUI()
    }

    private func setupUI() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(datePicker)

        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView).inset(16)
        }

        datePicker.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(16)
        }
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
    }

    func configure(withDate date: String, selectedDate: Date) {
        currentWeek = date
        dateLabel.text = date
        datePicker.date = selectedDate
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Formatted Date: \(formattedDate), Cell Label: \(currentWeek)")
    
        if let existingIndex = CareDate.eachData.firstIndex(where: { $0.week == currentWeek }) {
            CareDate.eachData[existingIndex].time = formattedDate
        } else {
            CareDate.eachData.append(CareDate(week: currentWeek, time: formattedDate))
        }
        print("each Data : \(CareDate.eachData)")
    }
}

