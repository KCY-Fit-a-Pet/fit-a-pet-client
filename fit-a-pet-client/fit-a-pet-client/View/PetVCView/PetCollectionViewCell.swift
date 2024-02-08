import UIKit
import SnapKit

class PetCollectionViewCell: UICollectionViewCell {
    
    let topic = ["성별", "나이", "사료"]
    let petInfoSubview = PetProfileView()
    let petCareSubview = PetCareListView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(petInfoSubview)
        contentView.addSubview(petCareSubview)
        contentView.layer.cornerRadius = 18
        contentView.layer.masksToBounds = false
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
 
        petInfoSubview.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(90)
        }

        petCareSubview.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(petInfoSubview.snp.bottom).offset(16)
        }
    }
    
    func petInfoSubviewConfigure(petName: String, gender: String, age: String, feed: String) {
        PetProfileUtils.configurePetInfoSubview(petInfoSubview, petName: petName, gender: gender, age: age, feed: feed)
    }
}
