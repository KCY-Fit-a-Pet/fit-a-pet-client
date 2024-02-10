import UIKit
import SnapKit

class FolderTableViewCell: UITableViewCell {
  
    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "folder")
        return imageView
    }()
    
    let folderLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    let subFolderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(named: "Gray5")
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(iconImageView)
        addSubview(containerView)
        
        containerView.addSubview(folderLabel)
        containerView.addSubview(subFolderLabel)
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }

        containerView.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
            make.trailing.equalToSuperview()
        }
        
        folderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(folderLabel.intrinsicContentSize.width)
        }
        
        subFolderLabel.snp.makeConstraints { make in
            make.leading.equalTo(folderLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ folder: String, _ subFolder: String ) {
        folderLabel.text = folder
        subFolderLabel.text = subFolder
        folderLabel.sizeToFit()
        folderLabel.snp.updateConstraints { make in
            make.width.equalTo(folderLabel.intrinsicContentSize.width)
        }
    }
}

