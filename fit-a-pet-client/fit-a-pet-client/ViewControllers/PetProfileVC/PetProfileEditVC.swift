

import UIKit
import SnapKit
import SwiftUI

class PetProfileEditVC: CustomNavigationBar{
    
    private let imagePickerUtil = ImagePickerUtil()
    private let choosePhotoBtn = UIButton()
    private let scrollView = UIScrollView()
    private let basicSubTitleLabel = UILabel()
    private let nameInputView =  CustomVerticalView(labelText: "이름", placeholder: "이름")
    private let genderView = GenderView()
    private let birthdayView = BirthdayView()
    private let addInfoLabel = UILabel()
    private let feedInputView = CustomVerticalView(labelText: "사료", placeholder: "사료")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        setupActions()
    }
    
    func initView(){
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(basicSubTitleLabel)
        scrollView.addSubview(choosePhotoBtn)
        scrollView.addSubview(nameInputView)
        scrollView.addSubview(genderView)
        scrollView.addSubview(birthdayView)
        scrollView.addSubview(addInfoLabel)
        scrollView.addSubview(feedInputView)
        
        choosePhotoBtn.setImage(UIImage(named: "uploadPhoto"), for: .normal)
        basicSubTitleLabel.text = "기본 정보"
        basicSubTitleLabel.font = .boldSystemFont(ofSize: 16)
        
        addInfoLabel.text = "추가 정보"
        addInfoLabel.font = .boldSystemFont(ofSize: 16)
        
        scrollView.snp.makeConstraints{make in
            make.top.bottom.leading.trailing.equalTo(view)
        }
        
        choosePhotoBtn.snp.makeConstraints{ make in
            make.width.equalTo(120)
            make.height.equalTo(120)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.top).offset(85)
        }
        
        basicSubTitleLabel.snp.makeConstraints{make in
            make.leading.trailing.equalTo(view).inset(16)
            make.top.equalTo(choosePhotoBtn.snp.bottom).offset(16)
            make.height.equalTo(24)
        }
        
        nameInputView.snp.makeConstraints{make in
            make.leading.trailing.equalTo(view).inset(16)
            make.top.equalTo(basicSubTitleLabel.snp.bottom)
            make.height.equalTo(88)
        }
        
        genderView.snp.makeConstraints{make in
            make.leading.trailing.equalTo(view).inset(16)
            make.top.equalTo(nameInputView.snp.bottom).offset(16)
            make.height.equalTo(120)
        }
        
        birthdayView.snp.makeConstraints{make in
            make.leading.trailing.equalTo(view).inset(16)
            make.top.equalTo(genderView.snp.bottom).offset(18)
            make.height.equalTo(88)
        }
        
        addInfoLabel.snp.makeConstraints{make in
            make.leading.trailing.equalTo(view).inset(16)
            make.top.equalTo(birthdayView.snp.bottom).offset(18)
            make.height.equalTo(24)
        }
        
        feedInputView.snp.makeConstraints{make in
            make.leading.trailing.equalTo(view).inset(16)
            make.top.equalTo(addInfoLabel.snp.bottom)
            make.height.equalTo(88)
        }
      
    }
    
    private func setupActions() {
        choosePhotoBtn.addTarget(self, action: #selector(choosePhotoButtonTapped), for: .touchUpInside)
        genderView.genderChangeBtn.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        genderView.neuteringCheckboxButton.addTarget(self, action: #selector(checkboxButtonTapped), for: .touchUpInside)
    }
    
    @objc private func showMenu() {

        let maleMenuItem = UIAction(title: "수컷") { _ in
            self.genderView.selectedGenderLabel.text = "수컷"
        }
        
        let femaleMenuItem = UIAction(title: "암컷") { _ in
            self.genderView.selectedGenderLabel.text = "암컷"
        }
        
        let menu = UIMenu(
            title: "",
            children: [maleMenuItem, femaleMenuItem]
        )
        
        self.genderView.genderChangeBtn.menu = menu
        self.genderView.genderChangeBtn.showsMenuAsPrimaryAction = true
    }
    
    @objc func checkboxButtonTapped(_ sender: UIButton) {
        print("???")
        self.genderView.neuteringCheckboxButton.isSelected.toggle()
        print( self.genderView.neuteringCheckboxButton.isSelected)
        self.genderView.updateCheckboxColor()
    }
    
    @objc func choosePhotoButtonTapped(_ sender: UIButton) {
           imagePickerUtil.present(from: self) { image in
               if let selectedImage = image {
                   // 선택한 이미지 처리 코드
               } else {
                   //이미지 선택하지 않은 경우 처리 코드
               }
           }
       }
    
    
}


struct MainViewController_Previews: PreviewProvider {
  static var previews: some View {
    Container().edgesIgnoringSafeArea(.all)
  }
  
  struct Container: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
      let rootViewController = PetProfileEditVC(title: "반려동물 프로필") // ViewController name
      return UINavigationController(rootViewController: rootViewController)
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    typealias UIViewControllerType = UIViewController
  }
}
