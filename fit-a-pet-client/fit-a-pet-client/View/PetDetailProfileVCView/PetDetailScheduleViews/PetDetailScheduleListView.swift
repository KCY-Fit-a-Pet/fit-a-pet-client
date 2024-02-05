import UIKit
import SnapKit

class PetDetailScheduleListView: UIView{

    private let petDetailScheduleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private let scheduleHeaderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()

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
        label.text = "일정"
        label.font = .boldSystemFont(ofSize: 18)
        scheduleHeaderStackView.addArrangedSubview(label)

        let button = UIButton()
        button.setTitle("더 보기", for: .normal)
        button.setTitleColor(UIColor(named: "Gray5"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        scheduleHeaderStackView.addArrangedSubview(button)

        addSubview(scheduleHeaderStackView)
        scheduleHeaderStackView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(24)
        }
    }

    private func setupCollectionView() {
        addSubview(petDetailScheduleCollectionView)
        petDetailScheduleCollectionView.snp.makeConstraints { make in
            make.top.equalTo(scheduleHeaderStackView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(400)
        }
        
        petDetailScheduleCollectionView.register(ScheduleListCollectionViewCell.self, forCellWithReuseIdentifier: "ScheduleListCollectionViewCell")

        petDetailScheduleCollectionView.delegate = self
        petDetailScheduleCollectionView.dataSource = self

    }
   
}

extension PetDetailScheduleListView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleListCollectionViewCell", for: indexPath) as! ScheduleListCollectionViewCell

        cell.scheduleTimeLabel.text = "time"
        cell.scheduleNameLabel.text = "name"
        cell.scheduleLocationLabel.text = "위치"
        
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 130)
    }

}

