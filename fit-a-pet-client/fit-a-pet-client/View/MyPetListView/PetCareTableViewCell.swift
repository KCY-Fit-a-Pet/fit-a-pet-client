import UIKit
import SnapKit

class PetCareTableViewCell: UITableViewCell {
    
    private var hasAdjustedLayout = false

    private let careListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        
        categoryLabel.text = "밥밥밥"
        categoryLabel.font = .systemFont(ofSize: 14)

        contentView.addSubview(categoryLabel)
        contentView.addSubview(careListCollectionView)
        
        categoryLabel.snp.makeConstraints{make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(4)
        }
        
        careListCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.equalTo(categoryLabel.snp.trailing).offset(24)
            make.trailing.equalToSuperview()
        }
        
        careListCollectionView.delegate = self
        careListCollectionView.dataSource = self

        careListCollectionView.register(PetCareListCollectionViewCell.self, forCellWithReuseIdentifier: "PetCareListCollectionViewCell")
    }
    
    func configure(_ category: String) {
        categoryLabel.text = category
    }
}

extension PetCareTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetCareListCollectionViewCell", for: indexPath) as! PetCareListCollectionViewCell
        return cell
    }
}
