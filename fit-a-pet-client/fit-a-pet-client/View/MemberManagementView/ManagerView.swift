
import UIKit
import SnapKit

class ManagerView: UIView {
    
    let managerTitle = UILabel()
    let userDataView = UserDataView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(managerTitle)
        addSubview(userDataView)
        backgroundColor = .white
        
        managerTitle.text = "관리자"
        managerTitle.font = .boldSystemFont(ofSize: 16)
        
        managerTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(24)
        }
        userDataView.snp.makeConstraints{make in
            make.height.equalTo(76)
            make.top.equalTo(managerTitle.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
