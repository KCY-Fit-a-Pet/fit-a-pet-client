
import UIKit
import SnapKit

class PetProfileView: UIView {
    
    let petImageView = UIImageView()
    let petName = UILabel()
    let petGender = UILabel()
    let petAge = UILabel()
    let petFeed = UILabel()
    
    let topic = ["성별", "나이", "사료"]
    let date = ["암컷", "6세", "사료사료사료"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        
        stackView.addArrangedSubview(petGender)
        stackView.addArrangedSubview(petAge)
        
        for i in 0..<3 {
            switch i {
            case 0:
                petGender.attributedText = createAttributedString(withTopic: topic[i], date: date[i])
                petGender.font = .systemFont(ofSize: 14)
            case 1:
                petAge.attributedText = createAttributedString(withTopic: topic[i], date: date[i])
                petAge.font = .systemFont(ofSize: 14)
            case 2:
                petFeed.attributedText = createAttributedString(withTopic: topic[i], date: date[i])
                petFeed.font = .systemFont(ofSize: 14)
            default:
                break
            }
        }
        
        petName.text = "하루"
        petName.font = .systemFont(ofSize: 14)
        petImageView.image = UIImage(named: "profileImage")
        
        addSubview(petImageView)
        addSubview(petName)
        addSubview(stackView)
        addSubview(petFeed)
        
        petImageView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(24)
            make.leading.equalTo(self.snp.leading).offset(24)
            make.width.height.equalTo(80)
        }
        
        petName.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(24)
            make.leading.equalTo(petImageView.snp.trailing).offset(16)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(petName.snp.bottom).offset(8)
            make.leading.equalTo(petImageView.snp.trailing).offset(16)
        }
    
        petFeed.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.leading.equalTo(petImageView.snp.trailing).offset(16)
        }
    }
    func createAttributedString(withTopic topic: String, date: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: topic + " ")
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length: 2))

        let dataAttributedString = NSAttributedString(string: date)
        attributedString.append(dataAttributedString)

        return attributedString
    }
}
