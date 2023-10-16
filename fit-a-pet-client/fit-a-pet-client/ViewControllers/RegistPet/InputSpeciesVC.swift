import UIKit
import SnapKit
import Alamofire

class InputSpeciesVC : UIViewController {
    
    let nextPetNameBtn = CustomNextBtn(title: "다음")
    let inputPetSpecies = UITextField()
    let progressBar = CustomProgressBar.shared
    let customLabel = ConstomLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()

        nextPetNameBtn.addTarget(self, action: #selector(changeInputPetNameVC(_:)), for: .touchUpInside)
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
        
        self.view.addSubview(nextPetNameBtn)
        self.view.addSubview(inputPetSpecies)
        self.view.addSubview(customLabel)
        
        view.backgroundColor = .white
        
        let text = "반려동물의\n종을 알려주세요."
        let attributedText = NSMutableAttributedString(string: text)

        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        let range = (text as NSString).range(of: "종")

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
        
        inputPetSpecies.delegate = self
        inputPetSpecies.layer.borderWidth = 1
        inputPetSpecies.layer.cornerRadius = 5
        inputPetSpecies.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        inputPetSpecies.placeholder = "개, 고양이, 햄스터 등"
        inputPetSpecies.font = .systemFont(ofSize:14)
        
        inputPetSpecies.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        inputPetSpecies.leftViewMode = .always
        
        inputPetSpecies.snp.makeConstraints{make in
            make.height.equalTo(55)
            make.top.equalTo(view.snp.top).offset(255)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }

        nextPetNameBtn.snp.makeConstraints{make in
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
            self.progressBar.setProgress(0.2)
        }
    }
    
    @objc func changeInputPetNameVC(_ sender: UIButton){
        let nextVC = InputPetNameVC()
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    
}

extension InputSpeciesVC: UITextFieldDelegate{
    // 입력값이 변경되면 버튼의 색상을 업데이트
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let updatedText = (inputPetSpecies.text! as NSString).replacingCharacters(in: range, with: string)
        nextPetNameBtn.updateButtonColor(updatedText, false)
    
        if updatedText.isEmpty{
            inputPetSpecies.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        }else{
            inputPetSpecies.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        }

        return true
    }
}
