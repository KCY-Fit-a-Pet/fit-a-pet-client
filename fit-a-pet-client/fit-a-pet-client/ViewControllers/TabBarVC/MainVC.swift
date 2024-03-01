import UIKit
import SnapKit

//TODO: pet 등록 ui 설정
class MainVC: UIViewController {
    
    private let layoutScrollView = UIScrollView()
    private let petListView = MainPetListView()
    private let mainInitView = MainInitView()
    private let petDataMethod = PetDataCollectionViewMethod()
    private let petCareMethod = PetCareCollectionViewMethod()
    
    private let mainView = UIView()
    private let petCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(MainPetCollectionViewCell.self, forCellWithReuseIdentifier: "MainPetCollectionViewCell")
        return cv
    }()
    
    let petCareCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(MainPetCareCollectionViewCell.self, forCellWithReuseIdentifier: "MainPetCareCollectionViewCell")
        cv.register(PetCareHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PetCareHeaderView")

        return cv
    }()
    
    
    private var petCareCollectionViewHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        petListView.petCollectionView.delegate = petDataMethod
        petListView.petCollectionView.dataSource = petDataMethod
        petCollectionView.dataSource = petDataMethod
        petCollectionView.delegate = petDataMethod
        
        navigationItem.titleView = petCollectionView
        
        petCareCollectionView.delegate = petCareMethod
        petCareCollectionView.dataSource = petCareMethod
        petCareCollectionView.isScrollEnabled = false
        
        petCareMethod.dataDidChange = { [weak self] in
            self?.updatePetCareCollectionViewHeight()
        }
        
        petCareCollectionViewHeightConstraint = petCareCollectionView.heightAnchor.constraint(equalToConstant: 0)
        petCareCollectionViewHeightConstraint.isActive = true
        reloadDataAndUpdateHeight()
        
        layoutScrollView.delegate = self
        
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserProfileInfo()
        fetchUserPetsList()
        
        petDataMethod.didSelectPetClosure = { selectedPet in
            self.petListView.petCollectionView.selectItem(at: selectedPet, animated: false, scrollPosition: .left)
            self.petCollectionView.selectItem(at: selectedPet, animated: false, scrollPosition: .left)
            let selectedPet = PetDataManager.summaryPets[selectedPet.item]
            self.petCareMethod.seletedPetId(selectedPet.id)
            careCompleteData.petId = selectedPet.id
            self.petCareCollectionView.reloadData()
        }
        
        petCareMethod.didSelectPetClosure = { [self] indexPath in
            if let careCategory = petCareMethod.petCareData[petCareMethod.selectedPet]?[indexPath.section] {
                let selectedCare = careCategory.cares[indexPath.item]
                print("Selected Pet Care ID: \(selectedCare.careId)")
                print("Selected Pet Care Date ID: \(selectedCare.careDateId)")
                careCompleteData.careId = selectedCare.careId
                careCompleteData.caredateId = selectedCare.careDateId
                
                let customPopupVC = CareCheckPopupVC()
                customPopupVC.modalPresentationStyle = .overFullScreen
                customPopupVC.updateText("\(selectedCare.careName) 케어를 완료할까요?", "케어 완료 알림을 케어 구성원에게 보내요.", "완료하기", "돌아가기")
                self.present(customPopupVC, animated: true, completion: nil)
                
                customPopupVC.dismissalCompletion = {
                    self.fetchUserPetCaresList()
                }
            }
        }
    }
    
    private func initView(){
        
//        mainView.addSubview(mainInitView)
        mainView.addSubview(petListView)
        mainView.addSubview(petCareCollectionView)
        mainView.addSubview(petCollectionView)
        mainInitViewConfigurations()
        
        layoutScrollView.addSubview(mainView)
        view.addSubview(layoutScrollView)
        
        mainView.backgroundColor = .white
        mainView.layer.cornerRadius = 20
        mainView.clipsToBounds = true
        
        petCareCollectionView.backgroundColor = .white
        
        layoutScrollView.backgroundColor = UIColor(named: "PrimaryColor")
        
        layoutScrollView.snp.makeConstraints{ make in
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
//
//        mainInitView.snp.makeConstraints{ make in
//            make.leading.equalTo(view.snp.leading)
//            make.trailing.equalTo(view.snp.trailing)
//            make.top.equalTo(mainView.snp.top).offset(250)
//            make.height.equalTo(150)
//        }
        
        petListView.snp.makeConstraints{make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(mainView.snp.top)
            make.height.equalTo(80)
        }

        petCollectionView.snp.makeConstraints{make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }

        petCareCollectionView.snp.makeConstraints{make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(petListView.snp.bottom).offset(20)
        }

        mainView.snp.makeConstraints{ make in
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(layoutScrollView.snp.bottom)
            make.top.equalTo(layoutScrollView.snp.top).offset(150)
        }
        
    }

    
    private func mainInitViewConfigurations() {
        mainInitView.commentLabel.text = "아직 등록된 반려동물이 없어요"
        mainInitView.registerButton.setTitle("반려동물 등록하기", for: .normal)
        mainInitView.registerButton.addTarget(self, action: #selector(changeInputSpeciesVC(_:)), for: .touchUpInside)
    }
    
    @objc func changeInputSpeciesVC(_ sender: UIButton){
        self.navigationController?.navigationBar.topItem?.title = ""
        
        let nextVC = InputSpeciesVC(title: "반려동물 등록하기")
        nextVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    
    func fetchUserProfileInfo() {
        AuthorizationAlamofire.shared.userProfileInfo { userProfileResult in
            DispatchQueue.main.async {
                switch userProfileResult {
                case .success(let data):
                    if let responseData = data {
                        do {
                            let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] ?? [:]

                            if let dataDict = jsonObject["data"] as? [String: Any],
                                let memberDict = dataDict["member"] as? [String: Any] {

                                for (key, value) in memberDict {
                                    UserDefaults.standard.set(value, forKey: key)
                                }

                                UserDefaults.standard.synchronize()
                            }
                            print("Response JSON Data (User Profile): \(jsonObject)")
                        } catch {
                            print("Error parsing user profile JSON: \(error)")
                        }
                    }

                case .failure(let profileError):
                    print("Error fetching user profile info: \(profileError)")
                }
            }
        }
    }

    func fetchUserPetsList() {
        AuthorizationAlamofire.shared.userPetsList { result in
            switch result {
            case .success(let data):
                if let responseData = data {
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] ?? [:]
                        
                        var pets: [SummaryPet] = []
                        
                        if let dataDict = jsonObject["data"] as? [String: Any],
                           let petsArray = dataDict["pets"] as? [[String: Any]] {
                            
                            for petDict in petsArray {
                                if let petId = petDict["id"] as? Int,
                                   let petName = petDict["petName"] as? String {
                                    let pet = SummaryPet(id: petId, petName: petName)
                                    pets.append(pet)
                                }
                            }
                        }
                        PetDataManager.summaryPets = pets
                        print("User Pets List: \(PetDataManager.summaryPets)")
                        self.petCareMethod.seletedPetId(pets[0].id)
                        careCompleteData.petId = PetDataManager.summaryPets[0].id

                        self.updateUIWithFetchedData()
                        self.fetchUserPetCaresList()

                        print("Response JSON Data (User Pets List): \(jsonObject)")
                    } catch {
                        print("Error parsing user pets list JSON: \(error)")
                    }
                }
                
            case .failure(let profileError):
                print("Error fetching user pets list: \(profileError)")
            }
        }
        
    }
    
    func fetchUserPetCaresList(){
        for (_, pet) in PetDataManager.summaryPets.enumerated() {
            AuthorizationAlamofire.shared.userPetCareInfoList(pet.id) { careInfoResult in
                switch careInfoResult {
                case .success(let careInfoData):
                    if let responseData = careInfoData {
                        PetDataManager.updateCareInfo(with: responseData, petId: pet.id)
                        DispatchQueue.main.async {
                            self.petCareMethod.updatePetCareCollectData(with: PetDataManager.careCategoriesByPetId)
                            self.petCareCollectionView.reloadData()
                        }
                    }
                    
                case .failure(let careInfoError):
                    print("Error fetching pet care info for pet \(pet.id): \(careInfoError)")
                }
            }
        }
    }
    
    func updateUIWithFetchedData() {
        self.petDataMethod.updatePetCollectData(with: PetDataManager.summaryPets)
        self.petListView.petCollectionView.reloadData()
        self.petCollectionView.reloadData()
        let defaultIndexPath = IndexPath(item: 0, section: 0)
        self.petListView.petCollectionView.selectItem(at: defaultIndexPath, animated: false, scrollPosition: .left)
        self.petCollectionView.selectItem(at: defaultIndexPath, animated: false, scrollPosition: .left)
    }
    
    private func updatePetCareCollectionViewHeight() {
        let cellHeight: CGFloat = 180
        let sectionHeaderHeight: CGFloat = 90
        var totalHeight: CGFloat = 0
        
        for section in 0..<petCareMethod.numberOfSections(in: petCareCollectionView) {
            let numberOfCellsInSection = petCareMethod.collectionView(petCareCollectionView, numberOfItemsInSection: section)
            let numberOfRows = numberOfCellsInSection / 2 + numberOfCellsInSection % 2 // 짝수 개수면 그대로, 홀수 개수면 1을 더한다
            totalHeight += sectionHeaderHeight + (cellHeight * CGFloat(numberOfRows))
        }

        if totalHeight < self.view.frame.height {
            petCareCollectionViewHeightConstraint.constant = self.view.frame.height
            mainView.snp.updateConstraints { make in
                make.height.equalTo(self.view.frame.height)
            }
        } else {
            petCareCollectionViewHeightConstraint.constant = totalHeight
            mainView.snp.updateConstraints { make in
                make.height.equalTo(totalHeight)
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    private func reloadDataAndUpdateHeight() {
        petCareCollectionView.reloadData()
        petCareMethod.notifyDataDidChange()
    }
}

extension MainVC: UIScrollViewDelegate{
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        tabBarController?.tabBar.barTintColor = .white

        let offsetY = scrollView.contentOffset.y
        let maxOffsetY = (mainView.frame.height + 200) - scrollView.frame.height

        if offsetY > maxOffsetY {
            scrollView.contentOffset.y = maxOffsetY
        }
        
        if offsetY > 150{
            navigationController?.navigationBar.barTintColor = .white
            navigationItem.titleView?.backgroundColor = .white
            navigationController?.setNavigationBarHidden(false, animated: true)
            
        }else{
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
}

