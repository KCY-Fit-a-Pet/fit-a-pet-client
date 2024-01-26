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
        let nextVC = PetCareRegistVC(title: "케어 등록하기")
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
extension PetVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 343, height: 296)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
