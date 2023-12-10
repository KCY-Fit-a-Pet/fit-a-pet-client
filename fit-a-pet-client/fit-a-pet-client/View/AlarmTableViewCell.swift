

import UIKit

class AlarmTableViewCell: UITableViewCell {
    
    let cellTitle = UILabel()
    let cellSubTitle = UILabel()
    
    let alarmSegmentControl = UISegmentedControl()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 셀 내의 contentView에 레이블 추가
        contentView.addSubview(cellTitle)
        contentView.addSubview(cellSubTitle)
        contentView.addSubview(alarmSegmentControl)
        
        cellTitle.font = .systemFont(ofSize: 14)
        cellSubTitle.font = .systemFont(ofSize: 12)
        cellSubTitle.textColor = UIColor(named: "Gray5")
        
        alarmSegmentControl.insertSegment(withTitle: " ", at: 0, animated: true)
        alarmSegmentControl.insertSegment(withTitle: " ", at: 1, animated: true)
        
        alarmSegmentControl.backgroundColor = UIColor(named: "PrimaryColor")
        
        alarmSegmentControl.layer.cornerRadius = 15
        alarmSegmentControl.clipsToBounds = true
        alarmSegmentControl.layer.masksToBounds = true
        
        cellTitle.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.bottom.equalTo(cellSubTitle.snp.top)
        }
        cellSubTitle.snp.makeConstraints{make in
            make.top.equalTo(cellTitle.snp.bottom)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
        alarmSegmentControl.snp.makeConstraints{make in
            make.top.equalTo(contentView.snp.top).offset(12)
            make.bottom.equalTo(contentView.snp.bottom).offset(-12)
            make.height.equalTo(32)
            make.width.equalTo(60)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ title: String, _ subTitle: String) {
        cellTitle.text = title
        cellSubTitle.text = subTitle
    }
    
    func configureSegmentControl(_ index: Int) {
        alarmSegmentControl.selectedSegmentIndex = index
    }
}

