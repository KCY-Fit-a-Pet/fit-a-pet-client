import UIKit
import SnapKit

class AlarmContentView: UIView {
    
    let markAsReadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전체 읽음", for: .normal)
        button.setTitleColor(UIColor(named: "Primary"), for: .normal)
        return button
    }()
    
    let acceptPendingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    let acceptPendingLabel: UILabel = {
        let label = UILabel()
        label.text = "초대 수락 대기중"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    let acceptPendingNavigationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    let acceptPendingStatus: UILabel = {
        let label = UILabel()
        label.text = "12" // 예시
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(named: "Gray5")
        return label
    }()
    
    let acceptPendingArrowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icon_arrow_small_right"), for: .normal)
        return button
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(markAsReadButton)
        addSubview(acceptPendingStackView)
        addSubview(tableView)
        
        acceptPendingStackView.addArrangedSubview(acceptPendingLabel)
        acceptPendingNavigationStackView.addArrangedSubview(acceptPendingStatus)
        acceptPendingNavigationStackView.addArrangedSubview(acceptPendingArrowButton)
        acceptPendingStackView.addArrangedSubview(acceptPendingNavigationStackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        markAsReadButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.height.equalTo(40)
        }
        
        acceptPendingStackView.snp.makeConstraints { make in
            make.top.equalTo(markAsReadButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        acceptPendingLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
        }
        acceptPendingNavigationStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(acceptPendingStackView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
            make.bottom.equalToSuperview()
        }
    }
}

