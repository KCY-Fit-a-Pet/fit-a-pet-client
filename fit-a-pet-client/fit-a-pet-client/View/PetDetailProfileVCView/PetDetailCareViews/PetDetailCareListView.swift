import UIKit
import SnapKit

class PetDetailCareListView: UIView{

    let petDetailCareCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 7
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private let careHeaderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    var careCategories: [CareCategory] = [] {
        didSet {
            petDetailCareCollectionView.reloadData()
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
        setupStackView()
        setupCollectionView()
    }
    
    private func setupStackView() {
        let label = UILabel()
        label.text = "케어 현황"
        label.font = .boldSystemFont(ofSize: 18)
        careHeaderStackView.addArrangedSubview(label)

        let button = UIButton()
        button.setTitle("케어 관리", for: .normal)
        button.setTitleColor(UIColor(named: "Gray5"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        careHeaderStackView.addArrangedSubview(button)

        addSubview(careHeaderStackView)
        careHeaderStackView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(24)
        }
    }

    private func setupCollectionView() {
        addSubview(petDetailCareCollectionView)
        petDetailCareCollectionView.snp.makeConstraints { make in
            make.top.equalTo(careHeaderStackView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(400)
        }
        
        petDetailCareCollectionView.register(PetDetailCareCollectionViewCell.self, forCellWithReuseIdentifier: "PetDetailCareCollectionViewCell")
        
        petDetailCareCollectionView.delegate = self
        petDetailCareCollectionView.dataSource = self
        
    }
    
    func updateCareCategories(_ categories: [CareCategory]) {
        careCategories = categories
    }
}

extension PetDetailCareListView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return careCategories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetDetailCareCollectionViewCell", for: indexPath) as? PetDetailCareCollectionViewCell else {
            return UICollectionViewCell()
        }

        let careCategory = careCategories[indexPath.row]
        cell.configure(careCategory.categoryName)
        cell.updateCares(careCategory.cares)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = collectionView.bounds.width
        let cellWidth = viewWidth / 2 - 5
        
        return CGSize(width: cellWidth, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.layoutIfNeeded()

            let numberOfCells = CGFloat(collectionView.numberOfItems(inSection: 0))
            let cellsPerRow = 2 // 한 행에 배치되는 셀의 수
            let interItemSpacing: CGFloat = 7 // 셀 사이의 간격
            let cellHeight: CGFloat = 120 

            var totalHeight: CGFloat
            let numberOfCellsInt = Int(numberOfCells)

            if numberOfCellsInt % cellsPerRow == 0 { // 짝수 개수일 때
                totalHeight = (cellHeight + interItemSpacing) * numberOfCells / CGFloat(cellsPerRow)
            } else { // 홀수 개수일 때
                let rows = Int(ceil(numberOfCells / CGFloat(cellsPerRow)))
                totalHeight = (cellHeight + interItemSpacing) * CGFloat(rows)
            }

            collectionView.snp.updateConstraints { make in
                make.height.equalTo(totalHeight)
            }
        }
    }
}

