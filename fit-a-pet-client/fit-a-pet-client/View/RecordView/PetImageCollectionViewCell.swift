
import UIKit
import SnapKit

class PetImageCollectionViewCell: UICollectionViewCell {
    
    // 이미지 표시를 위한 이미지 뷰
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "profileImage")
        return imageView
    }()
    
    // 삭제 버튼
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .red
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 이미지 뷰를 셀에 추가
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 삭제 버튼을 이미지 뷰에 추가
        addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.top.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
        }
    }
}
