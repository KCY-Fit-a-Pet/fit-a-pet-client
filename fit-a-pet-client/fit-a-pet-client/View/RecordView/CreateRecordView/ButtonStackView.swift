
import UIKit

class ButtonStackView: UIStackView {
    
    let imageAddButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addPhoto"), for: .normal)
        return button
    }()
    
    let keyboardHideButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .horizontal
        spacing = 8
        distribution = .equalSpacing
        
        addArrangedSubview(imageAddButton)
        addArrangedSubview(keyboardHideButton)
        
        imageAddButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
        }
        
        keyboardHideButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
