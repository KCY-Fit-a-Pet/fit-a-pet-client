
import UIKit
import SnapKit

protocol MemberTableViewCellDelegate: AnyObject {
    func didTapChangeName()
}

class MemberTableViewCell: UITableViewCell {
    
    let userDataView = UserDataView()
    let menuButton = UIButton()
    weak var delegate: MemberTableViewCellDelegate?
    private var menu: UIMenu?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        
        menuButton.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
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
    
    
    @objc private func showMenu() {
        
        if petManagersManager.masterManager?.uid == UserDefaults.standard.string(forKey: "uid") {
            menu = UIMenu(title: "", children: [
                UIAction(title: "이름 변경") { [weak self] action in
                    self?.delegate?.didTapChangeName()
                },
                UIAction(title: "관리자 위임") { [weak self] action in
             
                },
                UIAction(title: "강제 퇴장", attributes: .destructive) { [weak self] action in
                }
            ])
        } else {
            menu = UIMenu(title: "", children: [
                UIAction(title: "이름 변경") { [weak self] action in
                    self?.delegate?.didTapChangeName()
                }
            ])
        }
        
        self.menuButton.menu = menu
        self.menuButton.showsMenuAsPrimaryAction = true
        self.menuButton.isUserInteractionEnabled = true
    }
}
