import UIKit
import SnapKit
import PanModal

class MainVC: UIViewController {
    
    let layoutScrollView = UIScrollView()
    let petDataView = UIView()
    
    let petCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(PetCollectViewCell.self, forCellWithReuseIdentifier: "PetCollectViewCell") // Cell 등록
        return cv
        
    }()

    let petCollect = ["전체","동물11111", "동물222","동물33", "동물4","동물5555","동물6"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        petCollectionView.delegate = self
        petCollectionView.dataSource = self
        
        initView()
    }
    private func initView(){
        
        let dataTitleLabel = UILabel()
        
        petDataView.addSubview(dataTitleLabel)
        petDataView.addSubview(petCollectionView)
        layoutScrollView.addSubview(petDataView)
        view.addSubview(layoutScrollView)
        
        petDataView.backgroundColor = .white
        petDataView.layer.cornerRadius = 20
        
        dataTitleLabel.text = "나의 반려동물 케어"
        dataTitleLabel.font = .boldSystemFont(ofSize: 20)
        
        layoutScrollView.backgroundColor = UIColor(named: "PrimaryColor")
        
        layoutScrollView.snp.makeConstraints{ make in
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        petDataView.snp.makeConstraints{ make in
            make.bottom.equalTo(layoutScrollView.snp.bottom).offset(20)
            make.leading.equalTo(layoutScrollView.snp.leading)
            make.trailing.equalTo(layoutScrollView.snp.trailing)
            make.width.equalTo(375)
            make.height.equalTo(800)
            make.top.equalTo(layoutScrollView.snp.top).offset(100)
        }
        
        dataTitleLabel.snp.makeConstraints{make in
            make.top.equalTo(petDataView.snp.top).offset(20)
            make.leading.equalTo(petDataView.snp.leading).offset(20)
            
        }
        petCollectionView.snp.makeConstraints{make in
            make.top.equalTo(dataTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(petDataView.snp.leading).offset(20)
            make.trailing.equalTo(petDataView.snp.trailing).offset(-20)
            make.height.equalTo(50)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}
extension MainVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petCollect.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetCollectViewCell", for: indexPath) as! PetCollectViewCell
        let data = petCollect[indexPath.item]
        cell.configure(data)
        
        return cell
    }
}

extension MainVC: UICollectionViewDelegateFlowLayout {
    
    //텍스트의 크기에 따라 셀의 크기 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = petCollect[indexPath.item].size(withAttributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17) // 레이블 폰트에 맞게 조절
        ]).width + 15 // 텍스트 너비에 여분의 여백을 추가하여 잘리지 않도록 함
        return CGSize(width: cellWidth, height: 40) // 원하는 높이로 설정
    }
}

