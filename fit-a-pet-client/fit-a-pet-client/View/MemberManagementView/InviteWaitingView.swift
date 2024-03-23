

import UIKit
import SnapKit

class InviteWaitingView: UIView {
    
    let inviteMemberTableView = UITableView()
    let inviteWaitLabel = UILabel()
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
        
        addSubview(inviteWaitLabel)
        addSubview(inviteMemberTableView)
        
        inviteMemberTableView.register(InviteMemberTableViewCell.self, forCellReuseIdentifier: "InviteMemberTableViewCell")
        inviteMemberTableView.isScrollEnabled = false
        
        inviteWaitLabel.text = "초대 수락 대기 중"
        inviteWaitLabel.font = .boldSystemFont(ofSize: 14)

        memberInviteBtn.setTitle("초대하기", for: .normal)
        memberInviteBtn.setTitleColor(UIColor(named: "Primary"), for: .normal)
        memberInviteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        inviteWaitLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.top.equalToSuperview().offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        inviteMemberTableView.snp.makeConstraints { make in
            make.top.equalTo(inviteWaitLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
}
