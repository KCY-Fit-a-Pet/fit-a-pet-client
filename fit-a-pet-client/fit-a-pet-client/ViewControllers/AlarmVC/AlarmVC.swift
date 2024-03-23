import UIKit
import SnapKit

class AlarmVC: UIViewController {
    
    private let alarmContentView = AlarmContentView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.view.backgroundColor = UIColor(named: "White")
        setupNavigationBar()
        initView()
    }
    
    func setupNavigationBar(){
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        let backButton = UIBarButtonItem(image: UIImage(named: "icon_arrow_left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = UIColor(named: "Black")
        self.navigationItem.leftBarButtonItem = backButton
        
        let deleteButton = UIBarButtonItem(image: UIImage(named: "icon_close"), style: .plain, target: self, action: #selector(deleteButtonTapped))
        deleteButton.tintColor = UIColor(named: "Black")
        self.navigationItem.rightBarButtonItem = deleteButton
        
        let titleLabel = UILabel()
        titleLabel.text = "알람"
        titleLabel.textColor = UIColor(named: "Black")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.navigationItem.titleView = titleLabel
    }
    
    func initView(){
        view.addSubview(alarmContentView)
        
        alarmContentView.snp.makeConstraints{make in
            make.top.bottom.trailing.leading.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteButtonTapped() {
        // 삭제 버튼이 탭되었을 때 수행할 동작
    }
}
