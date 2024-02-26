
import UIKit
import SnapKit

class InviteMemberTableViewCell: UITableViewCell {
    
    let userDataView = UserDataView()
    let cancleBtn = UIButton()
  
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(userDataView)
        contentView.addSubview(cancleBtn)
 
        userDataView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(76)
        }
        
        cancleBtn.setTitle("초대 취소", for: .normal)
        cancleBtn.setTitleColor(UIColor(named: "Danger"), for: .normal)
        cancleBtn.layer.borderWidth = 1
        cancleBtn.layer.borderColor = UIColor(named: "Danger")?.cgColor
        cancleBtn.layer.cornerRadius = 8
        cancleBtn.backgroundColor = .white
        cancleBtn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        cancleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        cancleBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(84)
        }
    }
}
