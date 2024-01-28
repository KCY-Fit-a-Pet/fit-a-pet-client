import UIKit
import SnapKit

class PanModalDateView: UIView {

    private let dateLabel = UILabel()
    let labelStackView = UIStackView()
    let datePickerBtn = UIButton()
    let timePickerBtn = UIButton()
    var isDatePickerSelected = false
    var isTimePickerSelected = false
    
    private var selectedButton: UIButton?
    weak var delegate: PanModalDateViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupActions()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupActions()
    }

    private func setupViews() {
        
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDateAsString = dateFormatter.string(from: currentDate)

        if let formattedTime = DateFormatterUtils.formatTime(currentDateAsString, from: "yyyy-MM-dd HH:mm:ss", to: "a h:mm") {
            timePickerBtn.setTitle(formattedTime, for: .normal)
        }
        if let formattedFullDate = DateFormatterUtils.formatFullDate(currentDateAsString, from: "yyyy-MM-dd HH:mm:ss", to: "yyyy.MM.dd (E)") {
            datePickerBtn.setTitle(formattedFullDate, for: .normal)
        }

        
        labelStackView.addArrangedSubview(datePickerBtn)
        labelStackView.addArrangedSubview(timePickerBtn)
        
        addSubview(dateLabel)
        addSubview(labelStackView)
        
        labelStackView.axis = .horizontal
        labelStackView.alignment = .leading
        labelStackView.distribution = .fill
        labelStackView.spacing = 8

        dateLabel.text = "날짜"
        dateLabel.font = .boldSystemFont(ofSize: 18)
        
        datePickerBtn.layer.borderWidth = 1
        datePickerBtn.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        datePickerBtn.layer.cornerRadius = 8
        datePickerBtn.setTitleColor(.black, for: .normal)
        datePickerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        timePickerBtn.layer.borderWidth = 1
        timePickerBtn.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        timePickerBtn.layer.cornerRadius = 8
        timePickerBtn.setTitleColor(.black, for: .normal)
        timePickerBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(25)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.height.equalTo(56) 
        }

        datePickerBtn.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.width.equalTo(130)
        }
        
        timePickerBtn.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.width.equalTo(90)
        }
    }
    
    private func setupActions() {

        datePickerBtn.addTarget(self, action: #selector(datePickerTapped), for: .touchUpInside)
        timePickerBtn.addTarget(self, action: #selector(timePickerTapped), for: .touchUpInside)
    }
    
    @objc private func datePickerTapped() {
        if !isTimePickerSelected{
            isDatePickerSelected.toggle()
            deselectOtherButton()
            selectedButton = datePickerBtn
            datePickerBtn.setTitleColor(isDatePickerSelected ? UIColor(named: "PrimaryColor") : .black, for: .normal)
            delegate?.datePickerButtonTapped()
        }
    }
    
    @objc private func timePickerTapped() {
        if !isDatePickerSelected{
            isTimePickerSelected.toggle()
            deselectOtherButton()
            selectedButton = timePickerBtn
            timePickerBtn.setTitleColor(isTimePickerSelected ? UIColor(named: "PrimaryColor") : .black, for: .normal)
            delegate?.timePickerButtonTapped()
        }
       
    }
    
    private func deselectOtherButton() {
        let otherButton = selectedButton
        if otherButton == datePickerBtn {
            datePickerBtn.setTitleColor(.black, for: .normal)
        }else{
            timePickerBtn.setTitleColor(.black, for: .normal)
        }
    }
}

protocol PanModalDateViewDelegate: AnyObject {
    func datePickerButtonTapped()
    func timePickerButtonTapped()
}
