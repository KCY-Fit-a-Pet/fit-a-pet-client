import UIKit
import SnapKit

class PetCareListView: UIView {

    private let careCategoryListTableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        addSubview(careCategoryListTableView)
        
        careCategoryListTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-24)
        }

        careCategoryListTableView.register(PetCareTableViewCell.self, forCellReuseIdentifier: "PetCareTableViewCell")
        careCategoryListTableView.separatorStyle = .none

        careCategoryListTableView.delegate = self
        careCategoryListTableView.dataSource = self
    }
}
extension PetCareListView: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCareTableViewCell", for: indexPath) as! PetCareTableViewCell
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
}


