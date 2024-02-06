
import UIKit
import SnapKit

class PetDetailCareCollectionViewCell: UICollectionViewCell {

    let careCategoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()

    let careListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    var caresList: [Care] = [] {
        didSet {
            careListCollectionView.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        addSubview(careCategoryLabel)
        careCategoryLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(30)
        }

        addSubview(careListCollectionView)
        careListCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(careCategoryLabel.snp.bottom).offset(22)
            make.bottom.equalToSuperview().offset(-12)
        }

        careListCollectionView.delegate = self
        careListCollectionView.dataSource = self
        careListCollectionView.register(PetDetailCareListCollectionViewCell.self, forCellWithReuseIdentifier: "PetDetailCareListCollectionViewCell")
    }
    
    func updateCares(_ cares: [Care]) {
        caresList = cares
        careListCollectionView.reloadData()
    }
    func configure(_ category: String) {
        careCategoryLabel.text = category
    }
}
extension PetDetailCareCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return caresList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetDetailCareListCollectionViewCell", for: indexPath) as? PetDetailCareListCollectionViewCell else {
            return UICollectionViewCell()
        }

        let care = caresList[indexPath.row]
        cell.configure(care.careName)
        
        if care.isClear {
            cell.configure(care.careName)
            cell.careName.textColor = UIColor(named: "Gray3")
            cell.careName.backgroundColor = UIColor(named: "Gray1")
        } else {
            cell.configure(care.careName)
            cell.careName.textColor = UIColor(named: "PrimaryColor")
            cell.careName.backgroundColor = UIColor(named: "Secondary")
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 40, height: 40)
    }

}

