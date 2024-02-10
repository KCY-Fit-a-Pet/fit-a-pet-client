import UIKit
import SnapKit

class RecordListTableViewCell: UITableViewCell {
  
    var petImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "profileImage")
        return imageView
    }()
    
    let mainInfoContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let detailContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(named: "Gray5")
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(named: "Gray5")
        return label
    }()
    
    let folderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "listFolder")
        imageView.tintColor = UIColor(named: "Gray5")
        return imageView
    }()
    
    let parentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(named: "Gray5")
        return label
    }()
    
    let childLabel: UILabel = {
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
        
        addSubview(petImageView)
        addSubview(containerView)
        
        containerView.addSubview(mainInfoContainerView)
        containerView.addSubview(detailContainerView)
        
        mainInfoContainerView.addSubview(titleLabel)
        mainInfoContainerView.addSubview(contentLabel)
        mainInfoContainerView.addSubview(dateLabel)
        
        detailContainerView.addSubview(folderImageView)
        detailContainerView.addSubview(parentLabel)
        detailContainerView.addSubview(childLabel)
        
        petImageView.snp.makeConstraints { make in
            make.leading.equalTo(containerView.snp.trailing).offset(13)
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(72)
        }

        containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(56)
        }
        
        mainInfoContainerView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.height.equalTo(36)
        }
        
        detailContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(mainInfoContainerView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.width.equalTo(0)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
        }
        
        folderImageView.snp.makeConstraints{make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        parentLabel.snp.makeConstraints{make in
            make.leading.equalTo(folderImageView.snp.trailing).offset(4)
            make.top.equalToSuperview()
            make.width.equalTo(0)
        }
        
        childLabel.snp.makeConstraints{make in
            make.leading.equalTo(parentLabel.snp.trailing)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String, _ date: String, _ content: String, _ parent: String, _ child: String) {
        titleLabel.text = title
        contentLabel.text = content
        dateLabel.text = date
        parentLabel.text = parent
        childLabel.text = child
        
        dateLabel.sizeToFit()
        dateLabel.snp.updateConstraints { make in
            make.width.equalTo(dateLabel.intrinsicContentSize.width)
        }
        
        parentLabel.sizeToFit()
        parentLabel.snp.updateConstraints { make in
            make.width.equalTo(parentLabel.intrinsicContentSize.width)
        }
    }
}

