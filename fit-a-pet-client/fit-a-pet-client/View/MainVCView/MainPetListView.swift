import UIKit
import SnapKit

class MainPetListView: UIView {

    let dataTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 반려동물 케어"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

    let petCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(MainPetCollectionViewCell.self, forCellWithReuseIdentifier: "MainPetCollectionViewCell")
        return cv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .white
        addSubview(dataTitleLabel)
        addSubview(petCollectionView)

        dataTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }

        petCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dataTitleLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }

    }
}
