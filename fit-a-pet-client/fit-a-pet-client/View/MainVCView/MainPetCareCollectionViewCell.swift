
import UIKit

class MainPetCareCollectionViewCell: UICollectionViewCell {
    
    let careNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    let careTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    let careInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 2
        return stackView
    }()
    
    let detailBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "detail_icon"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.tintColor = .black
        return button
    }()
    
    var petImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "profileImage")
        return image
    }()
    
    let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
 
        setupUI()
        setUpStackView()
        
        detailBtn.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        careNameLabel.font = .boldSystemFont(ofSize: 16)
        careTimeLabel.font = .systemFont(ofSize: 14, weight: .medium)
        careInfoStackView.addArrangedSubview(careNameLabel)
        careInfoStackView.addArrangedSubview(careTimeLabel)
        
    }
    func setUpStackView(){

        containerStackView.addArrangedSubview(careInfoStackView)
        containerStackView.addArrangedSubview(detailBtn)
        
        contentView.addSubview(containerStackView)
        contentView.addSubview(petImageView)
        
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = false
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 1, height: 2)
        contentView.layer.shadowRadius = 2
        
        containerStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        petImageView.snp.makeConstraints{make in
            make.top.equalTo(containerStackView.snp.bottom).offset(26)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }

    }
    
    func configure(_ careName: String, _ careTime: String) {
        careNameLabel.text = careName
        careTimeLabel.text = careTime
    }

    @objc private func showMenu() {
        let menu = UIMenu(title: "", children: [
            UIAction(title: "케어 수정") { action in
            },
        ])
        
        self.detailBtn.menu = menu
        self.detailBtn.showsMenuAsPrimaryAction = true
        self.detailBtn.isUserInteractionEnabled = true
    }
}
