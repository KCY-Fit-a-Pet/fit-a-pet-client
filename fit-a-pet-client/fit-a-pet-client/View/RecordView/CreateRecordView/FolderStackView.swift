

import UIKit
import SnapKit

class FolderStackView: UIStackView {
    
    let folderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let selectedFolderLabel: UILabel = {
        let label = UILabel()
        label.text = "폴더를 선택해주세요"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    let folderButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "category"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .horizontal
        spacing = 8
        distribution = .equalSpacing
        layer.borderColor = UIColor(named: "Gray3")?.cgColor
        
        addArrangedSubview(folderImageView)
        addArrangedSubview(selectedFolderLabel)
        addArrangedSubview(folderButton)
        
        folderImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        
        selectedFolderLabel.snp.makeConstraints { make in
            make.leading.equalTo(folderImageView.snp.trailing).inset(16)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
