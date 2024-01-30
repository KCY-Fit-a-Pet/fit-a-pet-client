import UIKit
import SnapKit
import PanModal

class PetPanModalVC: CustomEditNavigationBar {
    
    var petList: [PetList] = PetList.petsList

    private let petPanModalTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        petPanModalTableView.register(PetPanModalTableViewCell.self, forCellReuseIdentifier: "PetCell")
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

        if pet.selectPet {
            cell.toggleSelectedState()
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72  // 원하는 높이로 설정
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? PetPanModalTableViewCell {
            cell.toggleSelectedState()
        }
        tableView.deselectRow(at: indexPath, animated: true)
        PetList.petsList[indexPath.row].selectPet.toggle()
        print(petList)
    }
    
}
