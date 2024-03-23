import UIKit
import SnapKit

class PetPanModalTableViewCell: UITableViewCell {
    
    private var hasAdjustedLayout = false
    private var isSelectedState = false

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

    private func setupUI() {
        
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        
        contentView.addSubview(petImageView)
        contentView.addSubview(nameLabel)

        petImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
            make.top.bottom.equalToSuperview().inset(4)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(petImageView.snp.trailing).offset(16)
            make.top.bottom.equalToSuperview().inset(4)
        }
    }
    private func updateCellState() {
        if isSelectedState {
            contentView.layer.borderColor = UIColor(named: "Primary")?.cgColor
            contentView.backgroundColor = UIColor(named: "Secondary")
        } else {
            contentView.layer.borderColor = UIColor(named: "Gray3")?.cgColor
            contentView.backgroundColor = .white
        }
    }
    
    func toggleSelectedState() {
        isSelectedState.toggle()
        updateCellState()
    }

    func configure(with image: String, name: String) {
        //petImageView.image = UIImage(named: image)
        petImageView.image = UIImage(named: "uploadPhoto")
        nameLabel.text = name
        updateCellState()
    }
}

