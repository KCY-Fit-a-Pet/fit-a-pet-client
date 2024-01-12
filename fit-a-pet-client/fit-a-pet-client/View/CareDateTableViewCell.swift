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
            make.top.equalTo(contentView).offset(8)
            make.leading.equalTo(contentView).inset(16)
        }

        datePicker.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).inset(16)
        }
    }

    func configure(withDate date: String, selectedDate: Date) {
        dateLabel.text = date
        datePicker.date = selectedDate
    }
}

