import UIKit
import SnapKit
import PanModal

class PetPanModalVC: CustomEditNavigationBar {
    
    var petList: [PetList] = []

    let myInfoCellData: [MyInfo] = MyInfo.cellList
    private let petPanModalTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        print(petList)
        
        petPanModalTableView.register(PetPanModalTableViewCell.self, forCellReuseIdentifier: "PetCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AuthorizationAlamofire.shared.userPetsList{ result in
            switch result {
            case .success(let data):
                if let responseData = data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                           let dataObject = json["data"] as? [String: Any],
                           let petsArray = dataObject["pets"] as? [[String: Any]] {
                            
                            PetList.petsList.removeAll()
                            
                            print(petsArray)
                            
                            for petData in petsArray {
                                if let id = petData["id"] as? Int,
                                   let petName = petData["petName"] as? String {
                                    let petProfileImage = petData["petProfileImage"] as? String ?? "uploadImage"
                                    
                                    let pet = PetList(id: id, petName: petName, petProfileImage: petProfileImage)
                                    PetList.petsList.append(pet)
                                }
                            }
                            self.petList = PetList.petsList
                            self.petPanModalTableView.reloadData()
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    private func setupUI() {
        view.addSubview(petPanModalTableView)
        petPanModalTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        petPanModalTableView.dataSource = self
        petPanModalTableView.delegate = self
    }
}

// MARK: - PanModalPresentable
extension PetPanModalVC: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return petPanModalTableView
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(400)
    }

    var anchorModalToLongForm: Bool {
        return false
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PetPanModalVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell", for: indexPath) as! PetPanModalTableViewCell
        let pet = petList[indexPath.row]
        cell.configure(with: pet.petProfileImage, name: pet.petName)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72  // 원하는 높이로 설정
    }
}
