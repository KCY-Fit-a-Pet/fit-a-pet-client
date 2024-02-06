
import UIKit
import SnapKit

class PetDetailProfileVC: UIViewController{
    
    let petProfileView = PetProfileView()
    let scrollView = UIScrollView()
    let petDetailDataView = UIView()
    let careProfileView = PetDetailCareListView()
    let scheduleProfileView = PetDetailScheduleListView()
    var petData: Pet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        setpetProfileView()
        setNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        petInfoListAPI()
    }
    
    func initView(){
        
        view.backgroundColor = .white
        
        scrollView.addSubview(petProfileView)
        petDetailDataView.addSubview(careProfileView)
        petDetailDataView.addSubview(scheduleProfileView)
        scrollView.addSubview(petDetailDataView)
        petDetailDataView.backgroundColor = UIColor(named: "Gray1")
        view.addSubview(scrollView)
       
        scrollView.snp.makeConstraints{ make in
            make.top.bottom.leading.trailing.equalTo(view)
        }
        
        petProfileView.snp.makeConstraints{make in
            make.top.equalTo(scrollView.snp.top)
            make.height.equalTo(140)
            make.leading.trailing.equalTo(scrollView)
        }
        
        petDetailDataView.snp.makeConstraints{make in
            make.top.equalTo(petProfileView.snp.bottom)
            make.height.equalTo(1000)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
        careProfileView.snp.makeConstraints{make in
            make.top.equalTo(petDetailDataView.snp.top).offset(24)
            make.leading.trailing.equalTo(petDetailDataView).inset(16)
            make.height.equalTo(440)
        }
        scheduleProfileView.snp.makeConstraints{make in
            make.top.equalTo(careProfileView.snp.bottom).offset(24)
            make.leading.trailing.equalTo(petDetailDataView).inset(16)
            make.height.equalTo(440)
        }
    }
    func setpetProfileView(){
    
        petProfileView.petImageView.snp.updateConstraints { make in
            make.width.height.equalTo(110)
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        petProfileView.petName.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(30)
        }
    }
    func setNavigationBar() {

        navigationController?.navigationBar.topItem?.title = petData?.petName
        navigationController?.navigationBar.tintColor = .black
        
        let editProfileButton = UIBarButtonItem(title: "프로필 수정", style: .plain, target: self, action: #selector(editProfileButtonTapped))
        let manageMembersButton = UIBarButtonItem(title: "관리 멤버", style: .plain, target: self, action: #selector(manageMembersButtonTapped))
        let buttonFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        editProfileButton.setTitleTextAttributes([NSAttributedString.Key.font: buttonFont], for: .normal)
        manageMembersButton.setTitleTextAttributes([NSAttributedString.Key.font: buttonFont], for: .normal)
        navigationItem.rightBarButtonItems = [manageMembersButton, editProfileButton]
    }
    
    @objc func editProfileButtonTapped() {
        print("프로필 수정 button tapped")
    }
    
    @objc func manageMembersButtonTapped() {
        print("관리 멤버 button tapped")
    }
    
    func petInfoListAPI(){
        
        AuthorizationAlamofire.shared.userPetInfoList { result in
            switch result {
            case .success(let data):
                if let responseData = data {
                    PetDataManager.updatePets(with: responseData)
           
                    self.careProfileView.petDetailCareCollectionView.reloadData()
                    
                    for (index, pet) in PetDataManager.pets.enumerated() {
                        
                        if pet.id == SelectedPetId.petId{
                            self.petData = pet
                            PetProfileUtils.configurePetInfoSubview(self.petProfileView, petName: self.petData!.petName, gender: self.petData!.gender, age: String(self.petData!.age) + "세", feed: self.petData!.feed)
                        }
                        
                        AuthorizationAlamofire.shared.userPetCareInfoList(pet.id) { careInfoResult in
                            
                            switch careInfoResult {
                            case .success(let careInfoData):
                                if let responseData = careInfoData {
                                    
                                    PetDataManager.updateCareInfo(with: responseData, petId: pet.id)
                                    self.careProfileView.updateCareCategories(PetDataManager.careCategoriesByPetId[pet.id]!)
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
