
import UIKit
import PanModal

class SelectGenderPanModalVC: UIViewController {
    
    private lazy var customPanModalView = CustomPanModalView()
    private let genderTableView = CustomTableView()

    let heightForRow: CGFloat = 56
    let genderList = ["암컷", "수컷"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        genderTableView.tableView.delegate = self
        genderTableView.tableView.dataSource = self
        
        customPanModalView.closeButtonAction = {
            self.closeButtonTapped()
        }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatefolderViewHeight()
    }
    
    func initView(){
        view.addSubview(customPanModalView)
        
        customPanModalView.titleText = "성별 선택"
        customPanModalView.leftTitleText = ""
        
        customPanModalView.closeButtonAction = {
            self.dismiss(animated: true, completion: nil)
        }
        
        customPanModalView.snp.makeConstraints{make in
            make.edges.equalToSuperview()
        }
        
        customPanModalView.contentView.addSubview(genderTableView)
        genderTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    @objc func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updatefolderViewHeight() {
        let totalCellHeight = CGFloat(genderTableView.tableView.numberOfRows(inSection: 0)) * heightForRow
        
        genderTableView.snp.updateConstraints { make in
            make.height.equalTo(totalCellHeight)
        }
    }


}

extension SelectGenderPanModalVC: PanModalPresentable{
    var panScrollable: UIScrollView? {
        return nil
    }

    var shortFormHeight: PanModalHeight {
        return .contentHeight(222)
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(222)
    }
}

// MARK: - UITableViewDataSource

extension SelectGenderPanModalVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        cell.customLabel.text = genderList[indexPath.row]
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SelectGenderPanModalVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let gender = (genderList[indexPath.row] == "암컷" ? "FEMALE" : "MALE")
        PetDataManager.petEditData.gender = gender
        NotificationCenter.default.post(name: .cellSelectedFromGenderPanModal, object: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
}
