import UIKit
import SnapKit

class FolderTableViewCell: UITableViewCell {

    let folderLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    let totalRecordLabel: UILabel = {
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
        
        addSubview(containerView)
        
        containerView.addSubview(folderLabel)
        containerView.addSubview(totalRecordLabel)
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
        }
        
        folderLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.width.equalTo(folderLabel.intrinsicContentSize.width)
        }
        
        totalRecordLabel.snp.makeConstraints { make in
            make.leading.equalTo(folderLabel.snp.trailing).offset(4)
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ folder: String, _ count: String ) {
        folderLabel.text = folder
        totalRecordLabel.text = count
        folderLabel.sizeToFit()
        folderLabel.snp.updateConstraints { make in
            make.width.equalTo(folderLabel.intrinsicContentSize.width)
        }
    }
}

