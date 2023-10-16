
import UIKit
import SnapKit
import Alamofire

//TODO: CollectionView 추가
class CheckCareVC : UIViewController {
    
    let nextBirthBtn = CustomNextBtn(title: "반려동물 등록하기")
    let progressBar = CustomProgressBar.shared
    let customLabel = ConstomLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()

        //nextBirthBtn.addTarget(self, action: #selector(changeInputPetBirthVC(_:)), for: .touchUpInside)
    }
    private func initView(){
        
        //titleView 만들기
        let titleLabel = UILabel()
        titleLabel.text = "반려동물 등록하기"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        titleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: titleLabel.frame.width, height: titleLabel.frame.height))
        titleView.addSubview(titleLabel)
    
        self.navigationItem.titleView = titleView
        
        self.view.addSubview(nextBirthBtn)
        self.view.addSubview(customLabel)
        
        view.backgroundColor = .white
        
        let text = "반려동물의\n주요 케어 활동을 선택해주세요."
        let attributedText = NSMutableAttributedString(string: text)

        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        let range = (text as NSString).range(of: "주요 케어 활동")

        attributedText.addAttribute(.font, value: boldFont, range: range)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineSpacing = 8
        
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))

        customLabel.setAttributedText(attributedText)
        
        customLabel.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(164)
            make.left.equalTo(view.snp.left).offset(16)
        }

        nextBirthBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
    }
   
    
    private func progressBarInit(){
        self.view.addSubview(progressBar)
        progressBar.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(100)
            make.height.equalTo(5)
            make.left.equalTo(view.snp.left).offset(0)
            make.right.equalTo(view.snp.right).offset(0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = " "
        
        progressBarInit()
        UIView.animate(withDuration: 0.5) {
            self.progressBar.setProgress(1.0)
        }
    }
    
//    @objc func changeInputPetBirthVC(_ sender: UIButton){
//        let nextVC = InputPetBirthVC()
//        self.navigationController?.pushViewController(nextVC, animated: false)
//    }
    
}



