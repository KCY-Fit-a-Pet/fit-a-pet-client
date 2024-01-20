
import UIKit
import SnapKit

class PetProfileView: UIView {
    
    var petImageView = UIImageView()
    var petName = UILabel()
    var petGender = UILabel()
    var petAge = UILabel()
    var petFeed = UILabel()
    
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
        
        petGender.font = .systemFont(ofSize: 14)
        petAge.font = .systemFont(ofSize: 14)
        petFeed.font = .systemFont(ofSize: 14)
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

}
