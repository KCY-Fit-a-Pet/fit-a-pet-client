
import UIKit
import SnapKit

class UserDataView: UIView {
    
    let profileImageView = UIImageView()
    let profileUserName = UILabel()
    let profileUserId = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(profileImageView)
        addSubview(profileUserName)
        addSubview(profileUserId)
        
        profileImageView.image = UIImage(named: "profileImage")
        
        profileUserName.text = "name"
        profileUserName.font = .systemFont(ofSize: 14, weight: .medium)
        profileUserId.font = .systemFont(ofSize: 12, weight: .regular)
        profileUserId.textColor = UIColor(named: "Gray5")
        profileUserId.text = "idddddd"
        

        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(60)
        }

        profileUserName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }

        profileUserId.snp.makeConstraints { make in
            make.top.equalTo(profileUserName.snp.bottom).offset(2)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
    }
}
