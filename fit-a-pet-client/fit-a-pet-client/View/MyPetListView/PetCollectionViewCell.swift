import UIKit
import SnapKit

class PetCollectionViewCell: UICollectionViewCell {
    
    let firstSubview = PetProfileView()
    
//    let secondSubview: UIView = {
//        let view = UIView()
//        view.backgroundColor = .green
//        return view
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(firstSubview)
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 18
        contentView.layer.borderColor = UIColor(named: "Gray3")?.cgColor
//        addSubview(secondSubview)
        
        firstSubview.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
//
//        secondSubview.snp.makeConstraints { make in
//            make.top.right.bottom.equalToSuperview()
//            make.width.equalToSuperview().dividedBy(2)
//        }
    }
}
