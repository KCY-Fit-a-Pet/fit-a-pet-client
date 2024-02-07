import UIKit
import SnapKit

//TODO: "오늘의 케어 현황" 추가

class PetVC: UIViewController{
    
    let petListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(PetCollectionViewCell.self, forCellWithReuseIdentifier: "PetCell")
        return collectionView
    }()
    
    private var tableViewHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        viewSetLayout()
        
        petListCollectionView.delegate = self
        petListCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        petInfoListAPI()
    }
    
    private func initView() {
        view.backgroundColor = .white
        
        configureNavigationBar()
        
    }
    private func viewSetLayout(){
        view.addSubview(petListCollectionView)
        
        petListCollectionView.snp.makeConstraints{ make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        let leftBarButtonItem = UIBarButtonItem(title: "나의 반려동물", style: .plain, target: nil, action: nil)
        leftBarButtonItem.tintColor = .black

        if let font = UIFont(name: "Helvetica-Bold", size: 18) {
            leftBarButtonItem.setTitleTextAttributes([.font: font], for: .normal)
        }
    
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    func petInfoListAPI(){
        
        AuthorizationAlamofire.shared.userPetInfoList { result in
            switch result {
            case .success(let data):
                if let responseData = data {
                    PetDataManager.updatePets(with: responseData)
           
                    self.petListCollectionView.reloadData()
            
                    for (index, pet) in PetDataManager.pets.enumerated() {
                        AuthorizationAlamofire.shared.userPetCareInfoList(pet.id) { careInfoResult in
                            
                            switch careInfoResult {
                            case .success(let careInfoData):
                                if let responseData = careInfoData {
                                    
                                    PetDataManager.updateCareInfo(with: responseData, petId: pet.id)
                                    
                                    if let cell = self.petListCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? PetCollectionViewCell {
                                        cell.petCareSubview.updateCareCategories(PetDataManager.careCategoriesByPetId[pet.id]!)

                                    }
                                }
                                
                            case .failure(let careInfoError):
                                print("Error fetching pet care info for pet \(pet.id): \(careInfoError)")
                            }
                        }
                    }
                    self.petListCollectionView.reloadData()
                }
                
            case .failure(let profileError):
                print("Error fetching user profile info: \(profileError)")
            }
        }
    }
}

extension PetVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPet = PetDataManager.pets[indexPath.item]
        print("Selected Pet Name: \(selectedPet.id)")
        SelectedPetId.petId = selectedPet.id
        let nextVC = PetDetailProfileVC()
        self.navigationController?.navigationBar.topItem?.title = selectedPet.petName
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
extension PetVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetCell", for: indexPath) as! PetCollectionViewCell
        
        let pet = PetDataManager.pets[indexPath.item]
        cell.petInfoSubviewConfigure(petName: pet.petName, gender: pet.gender, age: String(pet.age) + "세", feed: pet.feed)
 

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PetDataManager.pets.count
    }
}
extension PetVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewWidth = view.bounds.width
        let cellWidth = viewWidth - 36

        // 해당 indexPath에 해당하는 펫의 케어 카테고리 배열을 가져옴
        guard let categories = PetDataManager.careCategoriesByPetId[PetDataManager.pets[indexPath.item].id] else {
            return CGSize(width: cellWidth, height: 130) // 기본 높이
        }
        
        // 셀 높이를 구하기 위해 필요한 작업을 수행하고, 그 결과에 따라 높이를 계산
        let cellHeight = calculateCellHeight(for: categories)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func calculateCellHeight(for categories: [CareCategory]) -> CGFloat {
        // 각 카테고리마다 셀 높이를 계산하고 모두 더함
        var totalHeight: CGFloat = 130 // 기본 높이
        let cellHeight: CGFloat = 44 // 각 카테고리의 셀 높이
       
        totalHeight += CGFloat(categories.count) * cellHeight
    
        
        return totalHeight
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
