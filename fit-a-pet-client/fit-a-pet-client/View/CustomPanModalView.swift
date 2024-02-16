import UIKit
import PanModal
import SnapKit

class CustomPanModalView: UIView {
    
    var closeButtonAction: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let navigationBar = UINavigationBar()
    private let navigationItem = UINavigationItem()
    
    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    var buttonText: String? {
        didSet {
            closeButton.setTitle(buttonText, for: .normal)
        }
    }
    
    private let contentView: UIView = {
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
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        navigationBar.items = [navigationItem] 
        navigationItem.titleView = titleLabel
        
        let closeButtonBarItem = UIBarButtonItem(customView: closeButton)
        navigationItem.rightBarButtonItem = closeButtonBarItem
    }
    
    func setHeight(_ height: CGFloat) {
        snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        layoutIfNeeded()
    }
    
    @objc private func closeButtonTapped() {
           closeButtonAction?()
       }
}

