
import UIKit
import SnapKit

class MemberView: UIView {
    
    let memberStackView = UIStackView()
    let memberTableView = UITableView()
    let memberTitleLabel = UILabel()
    let memberInviteBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .white
        
        addSubview(memberStackView)
        addSubview(memberTableView)
        
        memberTableView.register(MemberTableViewCell.self, forCellReuseIdentifier: "MemberTableViewCell")
        memberTableView.isScrollEnabled = false
        
        memberTitleLabel.text = "멤버"
        memberTitleLabel.font = .boldSystemFont(ofSize: 16)

        memberInviteBtn.setTitle("초대하기", for: .normal)
        memberInviteBtn.setTitleColor(UIColor(named: "Primary"), for: .normal)
        memberInviteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        memberStackView.axis = .horizontal
        memberStackView.alignment = .center
        memberStackView.spacing = 8
        memberStackView.distribution = .equalSpacing
        
        memberStackView.addArrangedSubview(memberTitleLabel)
        memberStackView.addArrangedSubview(memberInviteBtn)
        
        memberStackView.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        memberTableView.snp.makeConstraints { make in
            make.top.equalTo(memberStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
}
