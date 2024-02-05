
import UIKit
import SnapKit

class PetDetailProfileVC: UIViewController{
    
    let petProfileView = PetProfileView()
    let scrollView = UIScrollView()
    let petDetailDataView = UIView()
    let careProfileView = PetDetailCareListView()
    var petData: Pet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        setpetProfileView()
        setNavigationBar()
    }
    
    func initView(){
        
        view.backgroundColor = .white
        
        scrollView.addSubview(petProfileView)
        petDetailDataView.addSubview(careProfileView)
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
            make.height.equalTo(500)
            make.leading.trailing.equalTo(view)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
        careProfileView.snp.makeConstraints{make in
            make.top.equalTo(petDetailDataView.snp.top).offset(24)
            make.leading.trailing.equalTo(petDetailDataView).inset(16)
            make.height.equalTo(340)
        }
    }
    func setpetProfileView(){
        for data in PetDataManager.pets{
            if data.id == SelectedPetId.petId{
                petData = data
                PetProfileUtils.configurePetInfoSubview(petProfileView, petName: petData!.petName, gender: petData!.gender, age: String(petData!.age) + "세", feed: petData!.feed)
            }
        }
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
}
