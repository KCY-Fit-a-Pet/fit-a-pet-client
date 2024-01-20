import UIKit
import SnapKit

class MainVC: UIViewController {
    
    private let layoutScrollView = UIScrollView()
    private let petListView = MainPetListView()
    private let mainInitView = MainInitView()
    private let petDataMethod = PetDataCollectionViewMethod()
    private let petCareMethod = PetCareCollectionViewMethod()
    
    private let mainView = UIView()
    
    let petCareCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(MainPetCareCollectionViewCell.self, forCellWithReuseIdentifier: "MainPetCareCollectionViewCell")
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //petDataView.petCollectionView.delegate = self
        //petDataView.petCollectionView.dataSource = self
        petListView.petCollectionView.delegate = petDataMethod
        petListView.petCollectionView.dataSource = petDataMethod
        
        petCareCollectionView.delegate = petCareMethod
        petCareCollectionView.dataSource = petCareMethod
        
        layoutScrollView.delegate = self
        
        initView()

        fetchUserProfileInfo()

    }
    private func initView(){
        //petDataView.addSubview(mainInitView)
        mainView.addSubview(petListView)
        mainView.addSubview(petCareCollectionView)
        //mainInitViewConfigurations()
        
        layoutScrollView.addSubview(mainView)
        view.addSubview(layoutScrollView)
        
        mainView.backgroundColor = .white
        mainView.layer.cornerRadius = 20
        
        layoutScrollView.backgroundColor = UIColor(named: "PrimaryColor")
        
        layoutScrollView.snp.makeConstraints{ make in
            make.top.equalTo(view.snp.top)
            make.bottom.equalTo(view.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
//        mainInitView.snp.makeConstraints{ make in
//            make.centerX.equalToSuperview()
//            make.top.equalToSuperview().offset(250)
//        }
        
        petListView.snp.makeConstraints{make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(mainView.snp.top)
            make.height.equalTo(80)
        }
        
        petCareCollectionView.snp.makeConstraints{make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(petListView.snp.bottom).offset(40)
            make.bottom.equalToSuperview()
        }
        
        mainView.snp.makeConstraints{ make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(1000)
            make.bottom.equalTo(layoutScrollView.snp.bottom).offset(50)
            make.top.equalTo(layoutScrollView.snp.top).offset(130)
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
                        print("Response JSON Data: \(jsonObject)")
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

extension MainVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Hide the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        //keep the tab bar white
        tabBarController?.tabBar.barTintColor = .white
        
    }
}

