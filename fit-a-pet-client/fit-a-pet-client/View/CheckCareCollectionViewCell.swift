
import UIKit

class CheckCareCollectionViewCell: UICollectionViewCell {
    
    let careName = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(careName)
        careName.font = UIFont.systemFont(ofSize: 14.0)
        careName.adjustsFontSizeToFitWidth = true // 텍스트 크기를 셀에 맞게 조절
        careName.textAlignment = .center // 가운데 정렬
        
        careName.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)) // 여백 없이 가득 채우도록 설정
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ name: String) {
        careName.text = name
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                contentView.backgroundColor = UIColor(named: "Secondary")
               
                careName.textColor = UIColor(named: "PrimaryColor")
            } else {
                contentView.backgroundColor = UIColor.clear
                careName.textColor = UIColor.black
            }
        }
    }
}
