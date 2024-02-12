

import UIKit
import SnapKit

class PetDetailCareListCollectionViewCell: UICollectionViewCell {

    let careName: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = UIColor(named: "Gray1")
        label.textColor = UIColor(named: "Gray3")
        label.font = .systemFont(ofSize: 14, weight: .medium)
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
        addSubview(careName)
        
        layer.cornerRadius = frame.width / 2
        layer.masksToBounds = true

        careName.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    func configure(_ newText: String) {
        careName.text = newText
    }
}
