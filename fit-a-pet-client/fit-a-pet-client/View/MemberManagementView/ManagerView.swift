
import UIKit
import SnapKit

protocol ManagerViewDelegate: AnyObject {
    func didTapChangeName()
}

class ManagerView: UIView {
    
    let managerTitle = UILabel()
    let userDataView = UserDataView()
    private var menu: UIMenu?
    let menuButton = UIButton()
    weak var delegate: ManagerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        menuButton.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(managerTitle)
        addSubview(userDataView)
        addSubview(menuButton)
        backgroundColor = .white
        
        managerTitle.text = "관리자"
        managerTitle.font = .boldSystemFont(ofSize: 16)
        menuButton.isHidden = true
             
        managerTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(24)
        }
        userDataView.snp.makeConstraints{make in
            make.height.equalTo(76)
            make.top.equalTo(managerTitle.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
        }
        
        menuButton.setImage(UIImage(named: "icon_more"), for: .normal)
        
        menuButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(userDataView)
            make.width.height.equalTo(44)
        }
    }
    @objc private func showMenu() {
       
        menu = UIMenu(title: "", children: [
            UIAction(title: "이름 변경") { [weak self] action in
                self?.delegate?.didTapChangeName()
            }
        ])
        
        self.menuButton.menu = menu
        self.menuButton.showsMenuAsPrimaryAction = true
        self.menuButton.isUserInteractionEnabled = true
    }
}
