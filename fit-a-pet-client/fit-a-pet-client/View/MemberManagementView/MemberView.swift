
import UIKit
import SnapKit

class MemberView: UIView {
    
    let memberStackView = UIStackView()
    let memberTableView = UITableView()
    
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
        
        let label = UILabel()
        label.text = "멤버"
        label.font = .boldSystemFont(ofSize: 16)
        
        let button = UIButton()
        button.setTitle("초대하기", for: .normal)
        button.setTitleColor(UIColor(named: "PrimaryColor"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        memberStackView.axis = .horizontal
        memberStackView.alignment = .center
        memberStackView.spacing = 8
        memberStackView.distribution = .equalSpacing
        
        memberStackView.addArrangedSubview(label)
        memberStackView.addArrangedSubview(button)
        
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
