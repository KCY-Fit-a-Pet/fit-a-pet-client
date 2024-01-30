import UIKit
import SnapKit

class ScheduleListTableViewCell: UITableViewCell {

    let scheduleDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(named: "Gray5")
        return label
    }()

    let scheduleNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    private let scheduleInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    let petImagecollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SchedulePetImageCollectionViewCell.self, forCellWithReuseIdentifier: "SchedulePetImageCollectionViewCell")
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        petImagecollectionView.delegate = self
        petImagecollectionView.dataSource = self
        
        contentView.addSubview(scheduleInfoStackView)
        contentView.addSubview(petImagecollectionView)

        scheduleInfoStackView.addArrangedSubview(scheduleDateLabel)
        scheduleInfoStackView.addArrangedSubview(scheduleNameLabel)

        scheduleInfoStackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }

        petImagecollectionView.snp.makeConstraints { make in
            make.top.equalTo(scheduleInfoStackView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
    }
}

extension ScheduleListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchedulePetImageCollectionViewCell", for: indexPath) as! SchedulePetImageCollectionViewCell

        cell.configure(with: UIImage(named: "profileImage"))

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 20, height: 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 2
       }

}
