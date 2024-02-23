
import UIKit
import SnapKit
import PanModal

class TimeAttackPanModalVC: UIViewController {
    
    var time = ["없음", "5분 전", "10분 전", "15분 전", "30분 전", "1시간 전", "2시간 전"]
    var timeList = [0,5,10,15,30,60,120]
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
            cell.toggleSelectedState()
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56 
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) as? TimeAttackPanModalTableViewCell {
            cell.toggleSelectedState()
        }
        selectTime = timeList[indexPath.row]
        PetCareRegistrationManager.shared.addInput(limitTime: selectTime)
        ScheduleRegistrationManager.shared.addInput(notifyTime: selectTime)

        print(PetCareRegistrationManager.shared.limitTime as Any)
        
        tableView.deselectRow(at: indexPath, animated: true)
        print("selectTime: \(selectTime)")
    }

}
