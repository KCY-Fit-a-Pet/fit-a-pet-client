import UIKit
import SnapKit

class PetCareTableViewCell: UITableViewCell {
    
    private let careListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        return collectionView
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    var caresList: [Care] = [] {
        didSet {
            careListCollectionView.reloadData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCares(_ cares: [Care]) {
        caresList = cares
        careListCollectionView.reloadData()
    }

    func setupViews() {
        categoryLabel.font = .systemFont(ofSize: 14)

        contentView.addSubview(categoryLabel)
        contentView.addSubview(careListCollectionView)
        
        categoryLabel.snp.makeConstraints{make in
            make.leading.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(4)
        }
        
        careListCollectionView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(3)
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

extension PetCareTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return caresList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetCareListCollectionViewCell", for: indexPath) as! PetCareListCollectionViewCell
        
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
        let care = caresList[indexPath.row]
        let labelWidth = (care.careName as NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]).width
        let cellWidth = labelWidth + 25
        let cellHeight: CGFloat = 36

        return CGSize(width: cellWidth, height: cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
}
