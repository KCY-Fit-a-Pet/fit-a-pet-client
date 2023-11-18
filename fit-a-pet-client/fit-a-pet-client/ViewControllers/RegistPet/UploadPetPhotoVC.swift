
import UIKit
import SnapKit
import Alamofire

class UploadPetPhotoVC : CustomNavigationBar {
    
    let registCompleteBtn = CustomNextBtn(title: "반려동물 등록하기")
    let progressBar = CustomProgressBar.shared
    let customLabel = ConstomLabel()
    let choosePhotoBtn = UIButton()
    
    let petImagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        petImagePicker.delegate = self
        
        choosePhotoBtn.addTarget(self, action: #selector(choosePhoto), for: .touchUpInside)
        
        initView()
    }
    
    private func initView(){
        
        self.view.addSubview(registCompleteBtn)
        self.view.addSubview(customLabel)
        self.view.addSubview(choosePhotoBtn)
        
        view.backgroundColor = .white
        
        let text = "반려동물의\n프로필사진을 올려주세요."
        let attributedText = NSMutableAttributedString(string: text)
        
        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        let range = (text as NSString).range(of: "프로필사진")
        
        attributedText.addAttribute(.font, value: boldFont, range: range)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineSpacing = 8
        
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
        
        choosePhotoBtn.setImage(UIImage(named: "uploadPhoto"), for: .normal)
        
        customLabel.setAttributedText(attributedText)
        
        customLabel.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(164)
            make.left.equalTo(view.snp.left).offset(16)
        }
        
        choosePhotoBtn.snp.makeConstraints{make in
            make.top.equalTo(customLabel.snp.bottom).offset(35)
            make.centerX.equalToSuperview()
            make.height.equalTo(150)
            make.width.equalTo(150)
        }
        
        registCompleteBtn.snp.makeConstraints{make in
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
        
        
        //presignedURL 발급 받기
        AlamofireManager.shared.presignedURL("profile", "jpeg") { result in
            switch result {
            case .success(let data):
                // Handle success
                if let responseData = data {
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]

                        if let payloadValue = jsonObject?["payload"] as? String,
                           let payloadURL = URL(string: payloadValue),
                           let components = URLComponents(url: payloadURL, resolvingAgainstBaseURL: false),
                           let queryItems = components.queryItems {

                            //'?'전까지 payload 설정
                            if let range = payloadValue.range(of: "?") {
                                PAYLOADURL.PAYLOAD = String(payloadValue[..<range.lowerBound])
                            } else {
                                PAYLOADURL.PAYLOAD = payloadValue
                            }

                            // query item을 PATLOADURL에 저장
                            PAYLOADURL.algorithm = queryItems[0].value ?? ""
                            PAYLOADURL.credential = queryItems[1].value ?? ""
                            PAYLOADURL.date = queryItems[2].value ?? ""
                            PAYLOADURL.expires = queryItems[3].value ?? ""
                            PAYLOADURL.signature = queryItems[4].value ?? ""
                            PAYLOADURL.signedHeaders = queryItems[5].value ?? ""
                            PAYLOADURL.acl = queryItems[6].value ?? ""

                            print("JSON Object: \(jsonObject ?? [:])")
                            print(PAYLOADURL.PAYLOAD)
                        } else {
                            print("Payload key not found in the JSON response.")
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            case .failure(let error):
                // Handle failure
                print("Error: \(error)")
            }
        }

        
        progressBarInit()
        UIView.animate(withDuration: 0.5) {
            self.progressBar.setProgress(1.0)
        }
    }
    @objc func choosePhoto() {
           presentImagePicker()
       }

    func presentImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            petImagePicker.sourceType = .photoLibrary
            present(petImagePicker, animated: true, completion: nil)
        } else {
            print("Photo library not available")
        }
    }
    
}


extension UploadPetPhotoVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.originalImage] as? UIImage,
            let imageURL = info[.imageURL] as? URL {
            let fileExtension = imageURL.pathExtension
            print("File Extension: \(fileExtension)")
            
            choosePhotoBtn.setImage(pickedImage, for: .normal)
            
            //objectStorage Image 저장
            AlamofireManager.shared.uploadImage(pickedImage) { result in
               switch result {
               case .success(let data):
                   // Handle success
                   if let unwrappedData = data,
                      let resultString = String(data: unwrappedData, encoding: .utf8) {
                       print("Success: \(resultString)")
                   } else {
                       print("Success with nil or non-text data")
                   }

               case .failure(let error):
                   // Handle failure
                   print("Error: \(error)")
               }
           }
           }
           dismiss(animated: true, completion: nil)
       }

   func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       dismiss(animated: true, completion: nil)
   }
    
}





