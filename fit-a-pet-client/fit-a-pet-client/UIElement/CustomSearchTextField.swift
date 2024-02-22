
import UIKit
class CustomSearchTextField: UITextField {
    
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    let iconContainerView: UIView = UIView()
    
    var placeholderText: String? {
        didSet {
            self.placeholder = placeholderText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        imageView.image = UIImage(named: "search")
        iconContainerView.addSubview(imageView)
        
        self.font = .systemFont(ofSize: 14)
        self.layer.cornerRadius = 8
        self.backgroundColor = UIColor(named: "Gray1")
        self.leftView = iconContainerView
        self.leftViewMode = .always

        imageView.snp.makeConstraints { make in
            make.leading.equalTo(iconContainerView).offset(10)
            make.centerY.equalTo(iconContainerView)
        }
        
        iconContainerView.snp.makeConstraints { make in
            make.width.equalTo(38)
            make.height.equalTo(20)
        }
    }
}
