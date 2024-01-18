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
        addSubview(petInfoSubview)
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 18
        contentView.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        addSubview(petCareSubview)

        petInfoSubview.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
        }

        petCareSubview.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(petInfoSubview.snp.bottom).offset(16)
        }
    }
    
    func petInfoSubviewConfigure(petName: String, gender: String, age: String, feed: String) {
        petInfoSubview.petName.text = petName
        if gender == "FEMALE"{
            petInfoSubview.petGender.attributedText = createAttributedString(withTopic: "성별", data: "암컷")
        }else{
            petInfoSubview.petGender.attributedText = createAttributedString(withTopic: "성별", data: "수컷")
        }
        petInfoSubview.petAge.attributedText = createAttributedString(withTopic: "나이", data: age)
        petInfoSubview.petFeed.attributedText = createAttributedString(withTopic: "사료", data: feed)
    }
    
    func createAttributedString(withTopic topic: String, data: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: topic + " ")
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length: 2))

        let dataAttributedString = NSAttributedString(string: data)
        attributedString.append(dataAttributedString)

        return attributedString
    }
}
