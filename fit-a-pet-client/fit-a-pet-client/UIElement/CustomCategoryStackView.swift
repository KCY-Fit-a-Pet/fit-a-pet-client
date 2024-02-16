import UIKit

class CustomStackView: UIStackView {
    let imageView = UIImageView()
    let selectedLabel = UILabel()
    
    init(label: String) {
       super.init(frame: .zero)
        selectedLabel.text = label
        setupView()
   }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        axis = .horizontal
        distribution = .equalSpacing
        spacing = 8
        layer.cornerRadius = 8
        layer.borderColor = UIColor(named: "Gray2")?.cgColor
        layer.borderWidth = 1
        
        snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "category")
        
        selectedLabel.font = .systemFont(ofSize: 14, weight: .regular)
        
        addArrangedSubview(selectedLabel)
        addArrangedSubview(imageView)
        
        selectedLabel.snp.makeConstraints{make in
            make.leading.equalToSuperview().inset(16)
        }
    }
}
