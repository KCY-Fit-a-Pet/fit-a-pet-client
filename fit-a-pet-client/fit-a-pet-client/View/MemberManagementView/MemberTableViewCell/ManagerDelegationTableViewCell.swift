
import UIKit
import SnapKit

class ManagerDelegationTableViewCell: UITableViewCell {
    
    let userDataView = UserDataView()
    let radioButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(userDataView)
        contentView.addSubview(radioButton)

        userDataView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(76)
        }
        
        radioButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        radioButton.layer.cornerRadius = 0.5 * 24
        radioButton.clipsToBounds = true
        radioButton.layer.borderWidth = 1
        radioButton.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        radioButton.isEnabled = false
    }
    
    func updateButtonAppearance() {
        if radioButton.isSelected {
            radioButton.backgroundColor = UIColor.red // Change to desired selected color
        } else {
            radioButton.backgroundColor = UIColor.clear // Change to original color
        }
    }
    
}
