

import UIKit

class MyInfoTableViewCell: UITableViewCell {
    
    let cellTitle = UILabel()
    let userData = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 셀 내의 contentView에 레이블 추가
        contentView.addSubview(cellTitle)
        contentView.addSubview(userData)
        
        cellTitle.font = .systemFont(ofSize: 14)
        userData.font = .systemFont(ofSize: 14)
        userData.textColor = UIColor(named: "Gray3")
        
        cellTitle.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(16)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
        
        userData.snp.makeConstraints{make in
            make.top.equalTo(contentView.snp.top).offset(18)
            make.trailing.equalTo(contentView.snp.trailing).offset(-12)
            make.bottom.equalTo(contentView.snp.bottom).offset(-18)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ title: String, _ data: String) {
        cellTitle.text = title
        userData.text = data
        
    }
}
