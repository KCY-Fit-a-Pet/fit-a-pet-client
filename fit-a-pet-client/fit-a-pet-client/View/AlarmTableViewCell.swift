

import UIKit

class AlarmTableViewCell: UITableViewCell {
    
    let cellTitle = UILabel()
    let cellSubTitle = UILabel()
    
    let alarmSegmentControl = CustomSegmentedControl(items: [" ", " "])
    
    var cellIndex: Int = 0
    var type = ""

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 셀 내의 contentView에 레이블 추가
        contentView.addSubview(cellTitle)
        contentView.addSubview(cellSubTitle)
        contentView.addSubview(alarmSegmentControl)
        
        alarmSegmentControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        cellTitle.font = .systemFont(ofSize: 14)
        cellSubTitle.font = .systemFont(ofSize: 12)
        cellSubTitle.textColor = UIColor(named: "Gray5")
        
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
    
    func configure(_ title: String, _ subTitle: String, _ index: Int) {
        cellIndex = index
        cellTitle.text = title
        cellSubTitle.text = subTitle
    }
    
    func configureSegmentControl(_ selected: Bool) {
        alarmSegmentControl.selectedSegmentIndex = (selected == false ? 0 : 1)
        print(alarmSegmentControl.selectedSegmentIndex)
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        print("Cell Index: \(cellIndex), Selected Index: \(selectedIndex)")
        
        if cellIndex == 0{
            type = "care"
            UserDefaults.standard.set(selectedIndex, forKey: "isCare")
        }else if cellIndex == 1{
            type = "memo"
            UserDefaults.standard.set(selectedIndex, forKey: "isMemo")
        }else{
            type = "schedule"
            UserDefaults.standard.set(selectedIndex, forKey: "isSchedule")
        }
        
        AlamofireManager.shared.userNotifyType(type){
            result in
            switch result {
            case .success(let data):
                // Handle success
                if let responseData = data {
                    // Process the data
                    let object = try?JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary
                    guard let jsonObject = object else {return}
                    print("respose jsonData: \(jsonObject)")
                }
            case .failure(let error):
                // Handle failure
                print("Error: \(error)")
            }
        }
    }
}

class CustomSegmentedControl: UISegmentedControl {
    
    override init(items: [Any]?) {
           super.init(items: items)
           selectedSegmentIndex = 0
       }
       
   required init?(coder: NSCoder) {
       super.init(coder: coder)
   }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        backgroundColor = UIColor(named: "PrimaryColor")
        
        layer.cornerRadius = 15
        clipsToBounds = true
        layer.masksToBounds = true
        
        let selectedImageViewIndex = numberOfSegments
        if let selectedImageView = subviews[selectedImageViewIndex] as? UIImageView
        {
            selectedImageView.backgroundColor = .white
            selectedImageView.image = nil
            
            selectedImageView.bounds = selectedImageView.bounds.insetBy(dx: 6, dy: 7)
                
            selectedImageView.layer.masksToBounds = true
            selectedImageView.layer.cornerRadius = selectedImageView.bounds.width / 2.0
            
            selectedImageView.layer.removeAnimation(forKey: "SelectionBounds")//animation 제거
        }
        
    }
}
