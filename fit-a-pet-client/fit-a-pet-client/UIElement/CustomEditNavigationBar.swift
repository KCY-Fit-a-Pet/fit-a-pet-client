import UIKit

class CustomEditNavigationBar: UIViewController {
    
    private var titleLabel: UILabel!
    private var cancleButton: UIBarButtonItem!
    var saveButton: UIBarButtonItem!
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
        cancleButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
        
        cancleButton.tintColor = UIColor(named: "PrimaryColor")
        saveButton.tintColor = UIColor(named: "Gray3")

        if let font = UIFont(name: "Helvetica-Bold", size: 16) {
            cancleButton.setTitleTextAttributes([.font: font], for: .normal)
            saveButton.setTitleTextAttributes([.font: font], for: .normal)
        }
    
        
        self.navigationItem.leftBarButtonItem = cancleButton
        self.navigationItem.rightBarButtonItem = saveButton

        
        // TitleView
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        titleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: titleLabel.frame.width, height: titleLabel.frame.height))
        titleView.addSubview(titleLabel)
        
        self.navigationItem.titleView = titleView
    }
    
    @objc func cancelButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }

    @objc func saveButtonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}


