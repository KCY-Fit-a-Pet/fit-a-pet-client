
import UIKit

class MainPetCollectionViewCell: UICollectionViewCell {
    
    let petName = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                petName.textColor = .black

            }else{
                petName.textColor = UIColor(named: "Gray3")
            }
        }
    }
    
    func setupUI(){
        contentView.addSubview(petName)
        
        petName.font = .boldSystemFont(ofSize: 16)
        petName.textColor = UIColor(named: "Gray3")

        petName.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(5)
            make.leading.equalTo(contentView.snp.leading).offset(5)
            make.trailing.equalTo(contentView.snp.trailing).offset(-5)
            make.bottom.equalTo(contentView.snp.bottom).offset(-5)
        }
    }
    
    func configure(_ name: String) {
        petName.text = name
    }
}
