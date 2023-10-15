
import UIKit
import SnapKit
import Alamofire

class InputPhoneNumVC : UIViewController {
    
    let nextAutnNumBtn = CustomNextBtn(title: "다음")
    let inputPhoneNum = UITextField()
    let progressBar = CustomProgressBar.shared
    let customLabel = ConstomLabel()
    
    var phone: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()

        nextAutnNumBtn.addTarget(self, action: #selector(changeInputAuthNumVC(_:)), for: .touchUpInside)
    }
    private func initView(){
        
        view.backgroundColor = .white
        
        self.view.addSubview(nextAutnNumBtn)
        self.view.addSubview(inputPhoneNum)
        self.view.addSubview(customLabel)
        
        let text = "인증을 위해\n전화번호를 입력해주세요."
        let attributedText = NSMutableAttributedString(string: text)

        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        let range = (text as NSString).range(of: "전화번호")

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
        
        inputPhoneNum.delegate = self
        inputPhoneNum.layer.borderWidth = 1
        inputPhoneNum.layer.cornerRadius = 5
        inputPhoneNum.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        inputPhoneNum.placeholder = "010-2345-6789"
        inputPhoneNum.font = .systemFont(ofSize:14)
        
        inputPhoneNum.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        inputPhoneNum.leftViewMode = .always
        
        inputPhoneNum.snp.makeConstraints{make in
            make.height.equalTo(55)
            make.top.equalTo(view.snp.top).offset(255)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }

        nextAutnNumBtn.snp.makeConstraints{make in
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
    
    @objc func changeInputAuthNumVC(_ sender: UIButton){
        let nextVC = InputAuthNumVC()
    
        RegistrationManager.shared.addInput(phone: phone)

        AlamofireManager.shared.sendSms(phone){
            result in
            switch result {
            case .success(let data):
                // Handle success
                if let responseData = data {
                    // Process the data
                    let object = try?JSONSerialization.jsonObject(with: responseData, options: []) as? NSDictionary
                    guard let jsonObject = object else {return}
                    print("respose jsonData: \(jsonObject)")
                   // print("Received data: \(responseData)")
                }
            case .failure(let error):
                // Handle failure
                print("Error: \(error)")
            }
        }
        
//        AF.request(url,
//                   method: .get,
//                   parameters: params)
//                   .response { response in
//
//        switch response.result{
//            case .success(let data):
//                print(data)
//                break
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        //if inputPhoneNum.text!.count>0{
            self.navigationController?.pushViewController(nextVC, animated: false)
        //}
        
        
    }
    
}

extension InputPhoneNumVC: UITextFieldDelegate{
    // 입력값이 변경되면 버튼의 색상을 업데이트
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let updatedText = (inputPhoneNum.text! as NSString).replacingCharacters(in: range, with: string)
        nextAutnNumBtn.updateButtonColor(updatedText, false)
    
        if updatedText.isEmpty{
            inputPhoneNum.layer.borderColor = UIColor(named: "Gray2")?.cgColor
        }else{
            inputPhoneNum.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
        }
        
        if let text = inputPhoneNum.text {
            print("[INFO] text : " + text)
            let strippedPhoneNumber = text.replacingOccurrences(of: "-", with: "")
            print("[INFO] strippedPhoneNumber : " + strippedPhoneNumber)
            var formattedText: String = ""
            let hippen: Character = "-"
            
            if strippedPhoneNumber.count == 11 {
                formattedText = String(strippedPhoneNumber.prefix(10))
                phone = Int(strippedPhoneNumber) ?? 0
                print("phone: \(phone)")
                return false
            } else {
                formattedText = strippedPhoneNumber
            }
            
            if strippedPhoneNumber.count >= 3 && text.count != 4 {
                formattedText.insert(hippen, at: formattedText.index(formattedText.startIndex, offsetBy: 3))
            }
            if strippedPhoneNumber.count >= 7 && text.count != 9 {
                formattedText.insert(hippen, at: formattedText.index(formattedText.startIndex, offsetBy: 8))
            }
            
            inputPhoneNum.text = formattedText
        }

        return true
    }
}
