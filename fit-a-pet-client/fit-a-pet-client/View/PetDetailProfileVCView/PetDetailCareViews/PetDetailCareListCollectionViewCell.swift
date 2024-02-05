

import UIKit
import SnapKit

class PetDetailCareListCollectionViewCell: UICollectionViewCell {

    let careNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = UIColor(named: "Gray1")
        label.textColor = UIColor(named: "Gray3")
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        addSubview(careNameLabel)
        
        layer.cornerRadius = frame.width / 2
        layer.masksToBounds = true

        careNameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
