
import UIKit
import SnapKit
import Alamofire

class CheckCareVC : CustomNavigationBar {
    
    private let nextUploadPetPhotoBtn = CustomNextBtn(title: "다음")
    private let progressBar = CustomProgressBar.shared
    private let customLabel = ConstomLabel()
    
    private let checkCareCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
       
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(CheckCareCollectionViewCell.self, forCellWithReuseIdentifier: "CheckCareCollectionViewCell") // Cell 등록
        return cv
    }()
    
    let careList = ["밥", "목욕", "산책", "간식","약 복용"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        collectionViewInit()
        
        nextUploadPetPhotoBtn.addTarget(self, action: #selector(changeUploadPetPhotoVC(_:)), for: .touchUpInside)

    }
    private func initView(){
        
        self.view.addSubview(nextUploadPetPhotoBtn)
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

        //customLabel.setAttributedText(attributedText)
        
        customLabel.snp.makeConstraints{make in
            make.top.equalTo(view.snp.top).offset(164)
            make.left.equalTo(view.snp.left).offset(16)
        }

        nextUploadPetPhotoBtn.snp.makeConstraints{make in
            make.bottom.equalTo(view.snp.bottom).offset(-65)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
        }
        
    }
    
    private func collectionViewInit(){
        checkCareCollectionView.allowsMultipleSelection = true//여러개 선택 가능
        
        checkCareCollectionView.delegate = self
        checkCareCollectionView.dataSource = self
        
        self.view.addSubview(checkCareCollectionView)
        
        checkCareCollectionView.snp.makeConstraints{make in
            make.top.equalTo(customLabel.snp.bottom).offset(30)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
            make.bottom.equalTo(nextUploadPetPhotoBtn.snp.top).offset(-10)
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
    
    @objc func changeUploadPetPhotoVC(_ sender: UIButton){
        let nextVC = UploadPetPhotoVC(title: "반려동물 등록하기")
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
    

}

extension CheckCareVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return careList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CheckCareCollectionViewCell", for: indexPath) as! CheckCareCollectionViewCell
        let data = careList[indexPath.item]
        cell.configure(data)
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(named: "Gray3")?.cgColor
        cell.layer.cornerRadius = 5
        
        return cell
    }
}

extension CheckCareVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CheckCareCollectionViewCell
        cell?.isSelected = true
        cell!.layer.borderColor = UIColor(named: "PrimaryColor")?.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CheckCareCollectionViewCell
        cell?.isSelected = false
        cell!.layer.borderColor = UIColor(named: "Gray3")?.cgColor
    }
}

extension CheckCareVC: UICollectionViewDelegateFlowLayout {
    
    //텍스트의 크기에 따라 셀의 크기 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 165, height: 55) // 원하는 높이로 설정
    }
}





