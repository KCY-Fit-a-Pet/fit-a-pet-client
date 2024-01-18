import UIKit
import SnapKit
import SwiftUI

struct PetInfoResponse: Codable {
    let status: String
    let data: PetData?
}

struct PetData: Codable {
    let pets: [Pet]?
}

struct Pet: Codable {
    let id: Int
    let petName: String
    let gender: String
    let petProfileImage: String
    let feed: String
    let careIds: [Int]
}

struct PetDataManager {
    static var pets: [Pet] = []

    static func updatePets(with data: Data) {
        do {
            let decoder = JSONDecoder()
            let petInfoResponse = try decoder.decode(PetInfoResponse.self, from: data)

            if let newPets = petInfoResponse.data?.pets {
                pets = newPets
                
                print("petsList: \(pets)")
            }
        } catch {
            print("Error updating pet data: \(error)")
        }
    }
}

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
        AuthorizationAlamofire.shared.userPetInfoList { result in
            switch result {
            case .success(let data):
                if let responseData = data {
                    PetDataManager.updatePets(with: responseData)
                    self.petListCollectionView.reloadData()
                }
                
                print(PetDataManager.pets.count)

            case .failure(let profileError):
                print("Error fetching user profile info: \(profileError)")
            }

        }
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
//    @objc func nextPetCareRegistVC() {
//        let nextVC = PetCareRegistVC(title: "케어 등록하기")
//        nextVC.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(nextVC, animated: true)
//    }
}

extension PetVC: UICollectionViewDelegate{
    
}
extension PetVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetCell", for: indexPath) as! PetCollectionViewCell
        
        let pet = PetDataManager.pets[indexPath.item]
        cell.petInfoSubviewConfigure(petName: pet.petName, gender: pet.gender, age: "6세", feed: pet.feed)
        
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
        return 9
    }
}

// MARK: - Preview

struct MainViewController_Previews: PreviewProvider {
  static var previews: some View {
    Container().edgesIgnoringSafeArea(.all)
  }
  
  struct Container: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
      let rootViewController = PetVC()
      return UINavigationController(rootViewController: rootViewController)
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    typealias UIViewControllerType = UIViewController
  }
}
