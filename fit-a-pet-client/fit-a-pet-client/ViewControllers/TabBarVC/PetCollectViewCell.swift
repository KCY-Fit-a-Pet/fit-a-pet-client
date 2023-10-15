
import UIKit

class PetCollectViewCell: UICollectionViewCell {
    
    let petName = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 셀 내의 contentView에 레이블 추가
        contentView.addSubview(petName)

        petName.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(5)
            make.leading.equalTo(contentView.snp.leading).offset(5)
            make.trailing.equalTo(contentView.snp.trailing).offset(-5) // 우측 여백
            make.bottom.equalTo(contentView.snp.bottom).offset(-5) // 하단 여백
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ name: String) {
        petName.text = name
    }
}
