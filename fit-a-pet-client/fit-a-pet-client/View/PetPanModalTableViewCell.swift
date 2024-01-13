import UIKit
import SnapKit

class PetPanModalTableViewCell: UITableViewCell {

    private let petImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    override func layoutSubviews() {
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0))
    }
    private func setupUI() {
        
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8
        
        contentView.addSubview(petImageView)
        contentView.addSubview(nameLabel)

        petImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(petImageView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
    }

    func configure(with imageName: String, name: String) {
        petImageView.image = UIImage(named: imageName)
        nameLabel.text = name
    }
}

