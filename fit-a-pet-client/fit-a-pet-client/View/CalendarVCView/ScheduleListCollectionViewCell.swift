import UIKit
import SnapKit

class ScheduleListCollectionViewCell: UICollectionViewCell {
    
    let scheduleTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(named: "Primary")
        return label
    }()
    
    let scheduleNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    let scheduleLocationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    let detailBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icon_more"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    
    private let scheduleInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    var schedulesList: [PetScheduleInfo] = []  {
        didSet {
            petImagecollectionView.reloadData()
            petImagecollectionView.snp.updateConstraints { make in
                make.width.equalTo(schedulesList.count * 27)
            }
        }
    }
    
    let petImagecollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SchedulePetImageCollectionViewCell.self, forCellWithReuseIdentifier: "SchedulePetImageCollectionViewCell")
        return collectionView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        contentView.addSubview(detailBtn)
        contentView.addSubview(petImagecollectionView)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = false
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 1, height: 2)
        contentView.layer.shadowRadius = 2
        
        scheduleInfoStackView.addArrangedSubview(scheduleTimeLabel)
        scheduleInfoStackView.addArrangedSubview(scheduleNameLabel)
        scheduleInfoStackView.addArrangedSubview(scheduleLocationLabel)
        
        scheduleInfoStackView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
        }
        
        detailBtn.snp.makeConstraints{ make in
            make.top.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(20)
        }
        
        petImagecollectionView.snp.makeConstraints { make in
            make.top.equalTo(scheduleInfoStackView.snp.bottom)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(25)
            make.width.equalTo(27)
        }
        
    }
    
    func updatePetImage(_ schedules: [PetScheduleInfo]) {
        schedulesList = schedules
    }
}

extension ScheduleListCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return schedulesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SchedulePetImageCollectionViewCell", for: indexPath) as! SchedulePetImageCollectionViewCell
        
        cell.configure(with: UIImage(named: "profileImage"))
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 25, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}
