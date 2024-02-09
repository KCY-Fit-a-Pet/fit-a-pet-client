import UIKit
import SnapKit

class BirthdayView: UIView {

    let totalBirthdayStackView = UIStackView()
    let totalAgeStackView = UIStackView()
    let birthdayStackView = UIStackView()
    let birthdayChangeBtn = UIButton()
    
    let ageStackView = UIStackView()
    
    let birthdayLabel = UILabel()
    let selectedBirthdayLabel = UILabel()
    let ageLabel = UILabel()
    let ageCheckLabel = UILabel()
    let textLabel = UILabel()
    
    let dateFormatterUtils = DateFormatterUtils()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
       
        birthdayLabel.text = "생일"
        birthdayLabel.font = .boldSystemFont(ofSize: 18)
        
        ageLabel.text = "나이"
        ageLabel.font = .boldSystemFont(ofSize: 18)
        
        ageCheckLabel.text = "0"
        ageCheckLabel.textAlignment = .center
        ageCheckLabel.backgroundColor = UIColor(named: "Gray1")
        
        textLabel.text = "살"
        textLabel.font = .systemFont(ofSize: 14, weight: .regular)
        
        ageCheckLabel.layer.borderWidth = 1
        ageCheckLabel.layer.cornerRadius = 8
        ageCheckLabel.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        
        birthdayStackView.axis = .horizontal
        birthdayStackView.spacing = 8
        birthdayStackView.distribution = .equalSpacing
        birthdayStackView.layer.borderWidth = 1
        birthdayStackView.layer.cornerRadius = 8
        birthdayStackView.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        birthdayStackView.addArrangedSubview(selectedBirthdayLabel)
        birthdayStackView.addArrangedSubview(birthdayChangeBtn)
        
        ageStackView.axis = .horizontal
        ageStackView.spacing = 8
        ageStackView.distribution = .equalSpacing
        ageStackView.addArrangedSubview(ageCheckLabel)
        ageStackView.addArrangedSubview(textLabel)

        selectedBirthdayLabel.font = .systemFont(ofSize: 14)
        
        let formattedDate = dateFormatterUtils.formatDateString(dateFormatterUtils.dateFormatter.string(from: Date()))
        
        selectedBirthdayLabel.text =  DateFormatterUtils.formatFullDate(formattedDate!, from: "yyyy-MM-dd HH:mm:ss", to: "yyyy.MM.dd (E)")

        birthdayChangeBtn.setImage(UIImage(named: "calendar"), for: .normal)
        
        totalBirthdayStackView.axis = .vertical
        totalBirthdayStackView.addArrangedSubview(birthdayLabel)
        totalBirthdayStackView.addArrangedSubview(birthdayStackView)

        totalAgeStackView.axis = .vertical
        totalAgeStackView.addArrangedSubview(ageLabel)
        totalAgeStackView.addArrangedSubview(ageStackView)

        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.addArrangedSubview(totalBirthdayStackView)
        horizontalStackView.addArrangedSubview(totalAgeStackView)
        horizontalStackView.spacing = 10

    
        addSubview(horizontalStackView)

        birthdayStackView.snp.makeConstraints{make in
            make.height.equalTo(56)
        }
        
        selectedBirthdayLabel.snp.makeConstraints{make in
            make.leading.equalToSuperview().inset(16)
        }
        
        birthdayChangeBtn.snp.makeConstraints{make in
            make.width.equalTo(50)
        }
        
        ageStackView.snp.makeConstraints{make in
            make.height.equalTo(56)
        }
        ageCheckLabel.snp.makeConstraints{make in
            make.width.height.equalTo(56)
        }

        horizontalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

