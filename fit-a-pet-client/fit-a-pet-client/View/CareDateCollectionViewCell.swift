
import UIKit
import SnapKit

class CareDateCollectionViewCell: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)

        contentView.backgroundColor = UIColor(named: "Gray1")
        contentView.layer.cornerRadius = contentView.bounds.width / 2
        contentView.layer.masksToBounds = true
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                label.textColor = .white
                contentView.backgroundColor = UIColor(named: "PrimaryColor")
                
            }else{
                label.textColor = .black
                contentView.backgroundColor = UIColor(named: "Gray1")
            }
        }
    }

}
