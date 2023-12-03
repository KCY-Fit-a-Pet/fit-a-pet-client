import UIKit
import SnapKit

class FindInputPhoneNum: CustomNavigationBar{
    
    private let nextInputNumBtn = CustomNextBtn(title: "다음")
    private let inputPhoneNum = UITextField()
    private let textView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.view.backgroundColor = .white
        initView()
    }
    
    private func initView(){
        
        
        self.view.addSubview(inputPhoneNum)
        self.view.addSubview(nextInputNumBtn)
        
        
    
        inputPhoneNum.layer.borderWidth = 1
        inputPhoneNum.layer.cornerRadius = 5
        inputPhoneNum.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        inputPhoneNum.placeholder = "010-1234-1234"
        inputPhoneNum.font = .systemFont(ofSize:14)
        
        inputPhoneNum.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        inputPhoneNum.leftViewMode = .always
        
        inputPhoneNum.snp.makeConstraints{make in
            make.height.equalTo(55)
            make.top.equalTo(view.snp.top).offset(255)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
        nextInputNumBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
    }
    
}
