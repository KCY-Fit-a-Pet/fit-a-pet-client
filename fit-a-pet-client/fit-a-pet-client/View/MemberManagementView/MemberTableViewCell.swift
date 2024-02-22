
import UIKit
import SnapKit

class MemberTableViewCell: UITableViewCell {
    
    let userDataView = UserDataView()
    let menuButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(userDataView)
        contentView.addSubview(menuButton)
        userDataView.layer.borderWidth = 2
        userDataView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(76)
        }
        
        menuButton.setImage(UIImage(named: "detail_icon"), for: .normal)
        
        menuButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(44)
        }
    }
}
