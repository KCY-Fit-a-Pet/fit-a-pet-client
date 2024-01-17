import UIKit
import SnapKit

class PetCareListCollectionViewCell: UICollectionViewCell {
    private let careName: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(careName)
        
        careName.text = "아침"
        careName.font = .systemFont(ofSize: 14)
        careName.textColor = UIColor(named: "Gray3")
        careName.backgroundColor = UIColor(named: "Gray1")

        careName.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                careName.textColor = UIColor(named: "PrimaryColor")
                careName.backgroundColor = UIColor(named: "Secondary")
                
            }else{
                careName.textColor = UIColor(named: "Gray3")
                careName.backgroundColor = UIColor(named: "Gray1")
            }
        }
    }
    
    func configure(_ newText: String) {
        careName.text = newText
    }
}

