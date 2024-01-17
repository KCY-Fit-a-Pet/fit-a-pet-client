import UIKit
import SnapKit

class PetCollectionViewCell: UICollectionViewCell {
    
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
}
