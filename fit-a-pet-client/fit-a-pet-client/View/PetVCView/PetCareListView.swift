import UIKit
import SnapKit

class PetCareListView: UIView {

    let careCategoryListTableView = UITableView()
    
    var careCategories: [CareCategory] = [] {
        didSet {
            careCategoryListTableView.reloadData()
        }
    }

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
            make.top.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-24)
        }
        careCategoryListTableView.register(PetCareTableViewCell.self, forCellReuseIdentifier: "PetCareTableViewCell")
        careCategoryListTableView.separatorStyle = .none

        careCategoryListTableView.delegate = self
        careCategoryListTableView.dataSource = self
    }
    
    func updateCareCategories(_ categories: [CareCategory]) {
        careCategories = categories

    }
}

extension PetCareListView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return careCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCareTableViewCell", for: indexPath) as! PetCareTableViewCell
        
        let careCategory = careCategories[indexPath.row]
        cell.configure(careCategory.categoryName)
        cell.updateCares(careCategory.cares)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
}

