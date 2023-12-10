import UIKit
import SnapKit
import Alamofire

class InputSpeciesVC: CustomNavigationBar {
    
    private let nextPetNameBtn = CustomNextBtn(title: "다음")
    private let inputPetSpecies = UITextField()
    private let progressBar = CustomProgressBar.shared
    private let customLabel = ConstomLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        nextPetNameBtn.addTarget(self, action: #selector(changeInputPetNameVC(_:)), for: .touchUpInside)
        navigationController?.setNavigationBarHidden(false, animated: false)

    }

    private func initView(){
        
        self.view.addSubview(nextPetNameBtn)
        self.view.addSubview(inputPetSpecies)
        self.view.addSubview(customLabel)
        
        view.backgroundColor = .white
        
        let text = "반려동물의\n종을 알려주세요."
        let range = "종"

        customLabel.setAttributedText(text, range)
        
        customLabel.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(164)
            make.left.equalTo(view.snp.left).offset(16)

        }
        
        inputPetSpecies.delegate = self
        inputPetSpecies.layer.borderWidth = 1
        inputPetSpecies.layer.cornerRadius = 5
        inputPetSpecies.layer.borderColor = UIColor(named: "Gray3")?.cgColor
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
        let nextVC = InputPetNameVC(title: "반려동물 등록하기")
        if let species = inputPetSpecies.text {
            PetRegistrationManager.shared.addInput(species: species)
        }
        
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    
}

extension InputSpeciesVC: UITextFieldDelegate{
    // 입력값이 변경되면 버튼의 색상을 업데이트
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let updatedText = (inputPetSpecies.text! as NSString).replacingCharacters(in: range, with: string)
        nextPetNameBtn.updateButtonColor(updatedText, false)
    
        if updatedText.isEmpty{
            inputPetSpecies.layer.borderColor = UIColor(named: "Gray3www")?.cgColor
        }else{
            inputPetSpecies.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        }

        return true
    }
}
