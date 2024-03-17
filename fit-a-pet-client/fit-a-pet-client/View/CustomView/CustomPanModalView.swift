import UIKit
import PanModal
import SnapKit

class CustomPanModalView: UIView {
    
    var closeButtonAction: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    private let leftLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_close"), for: .normal)
        return button
    }()
    
    private let navigationBar = UINavigationBar()
    private let navigationItem = UINavigationItem()
    
    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    var leftTitleText: String? {
        didSet {
            leftLabel.text = leftTitleText
        }
    }
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(navigationBar)
        addSubview(contentView)
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        backgroundColor = .white
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.trailing.equalToSuperview().inset(2)
            make.height.equalTo(44)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        navigationBar.items = [navigationItem]
         
        let leftItem = UIBarButtonItem(customView: leftLabel)
        navigationItem.leftBarButtonItem = leftItem
        
        navigationBar.barTintColor = .white
        navigationBar.shadowImage = UIImage()
        navigationItem.titleView = titleLabel
        
        let closeButtonBarItem = UIBarButtonItem(customView: closeButton)
        navigationItem.rightBarButtonItem = closeButtonBarItem
    
    }
    
    func setHeight(_ height: CGFloat) {
        frame.size.height = height
    }
    
    @objc private func closeButtonTapped() {
        closeButtonAction?()
    }
}

