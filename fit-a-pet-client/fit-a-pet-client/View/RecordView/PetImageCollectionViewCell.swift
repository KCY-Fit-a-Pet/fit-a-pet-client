
import UIKit
import SnapKit

class PetImageCollectionViewCell: UICollectionViewCell {
    
    let petImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "profileImage")
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "delete"), for: .normal)
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
        
        addSubview(petImageView)
        petImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.width.height.equalTo(22)
            make.top.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().offset(-2)
        }
    }
    func updatePetImage(_ image: UIImage?){
        petImageView.image = image
    }
}
