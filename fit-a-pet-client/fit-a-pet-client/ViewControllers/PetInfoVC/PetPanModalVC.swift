import UIKit
import SnapKit
import PanModal

struct Pet {
    let imageName: String
    let name: String
}

class PetPanModalVC: CustomEditNavigationBar {

    private let petPanModalTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private let pets: [Pet] = [
        Pet(imageName: "uploadPhoto", name: "Dog 1"),
        Pet(imageName: "uploadPhoto", name: "Cat 2"),
        // 나머지 더미 데이터 추가
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        petPanModalTableView.register(PetPanModalTableViewCell.self, forCellReuseIdentifier: "PetCell")
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
        return .contentHeight(350)
    }

    var anchorModalToLongForm: Bool {
        return false
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PetPanModalVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell", for: indexPath) as! PetPanModalTableViewCell
        let pet = pets[indexPath.row]
        cell.configure(with: pet.imageName, name: pet.name)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64  // 원하는 높이로 설정
    }
}
