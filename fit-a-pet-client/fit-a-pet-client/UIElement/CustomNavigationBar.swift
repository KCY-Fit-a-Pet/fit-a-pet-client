import UIKit

class CustomNavigationBar: UIViewController {
    
    private var titleLabel: UILabel!
    private var closeButton: UIButton!
    private var currentTitle = ""

    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        setupNavigationBar(title: title)
        currentTitle = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupNavigationBar(title: String) {
        // X button
        closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(named: "close_icon"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
        
        // TitleView
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        titleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: titleLabel.frame.width, height: titleLabel.frame.height))
        titleView.addSubview(titleLabel)
        
        self.navigationItem.titleView = titleView
    }
    
    @objc func closeButtonTapped() {
        if currentTitle == "반려동물 등록하기" {
            navigationController?.popToRootViewController(animated: true)
        } else {
            if let loginVC = navigationController?.viewControllers.first(where: { $0 is LoginVC }) {
                navigationController?.popToViewController(loginVC, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = .black
        
        if currentTitle == "반려동물 등록하기" {
            self.navigationItem.hidesBackButton = false
        } else {
            self.navigationItem.hidesBackButton = true
        }
        
        self.navigationController?.navigationBar.topItem?.title = " "
    }
}

