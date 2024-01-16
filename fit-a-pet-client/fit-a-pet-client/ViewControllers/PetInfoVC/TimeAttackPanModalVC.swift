
import UIKit
import SnapKit
import PanModal

class TimeAttackPanModalVC: CustomEditNavigationBar {
    
    var time = ["없음", "5분", "10분", "15분", "30분", "1시간"]
    var timeList = [0,5,10,15,30,60]
    var selectTime: Int = 0

    private let timePanModalTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        timePanModalTableView.register(TimeAttackPanModalTableViewCell.self, forCellReuseIdentifier: "TimeCell")
    }

    private func setupUI() {
        
        view.addSubview(timePanModalTableView)
        
        timePanModalTableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
        
        timePanModalTableView.dataSource = self
        timePanModalTableView.delegate = self
    }
}

// MARK: - PanModalPresentable
extension TimeAttackPanModalVC: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return timePanModalTableView
    }

    var longFormHeight: PanModalHeight {
        return .contentHeight(500)
    }

    var anchorModalToLongForm: Bool {
        return false
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TimeAttackPanModalVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return time.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as! TimeAttackPanModalTableViewCell
        let t = time[indexPath.row]
        cell.configure(with: t)
        
        if PetCareRegistrationManager.shared.limitTime == timeList[indexPath.row]{
            print("??????")
            cell.toggleSelectedState()
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell", for: indexPath) as! PetPanModalTableViewCell
//        let pet = petList[indexPath.row]
//        cell.configure(with: pet.petProfileImage, name: pet.petName)
//
//        if pet.selectPet {
//            cell.toggleSelectedState()
//        }
//
//        return cell
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56 
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? TimeAttackPanModalTableViewCell {
            cell.toggleSelectedState()
        }
        selectTime = timeList[indexPath.row]
        PetCareRegistrationManager.shared.addInput(limitTime: selectTime)

        print(PetCareRegistrationManager.shared.limitTime)
        print(PetCareRegistrationManager.shared.careName)
        
        tableView.deselectRow(at: indexPath, animated: true)
        print("selectTime: \(selectTime)")
    }

}
