

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
    
    let datePicker = UIDatePicker()
    let dateFormatterUtils = DateFormatterUtils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        setupActions()
    }
    
    func initView(){
        view.backgroundColor = .white

        scrollView.addSubview(basicSubTitleLabel)
        scrollView.addSubview(choosePhotoBtn)
        scrollView.addSubview(nameInputView)
        scrollView.addSubview(genderView)
        scrollView.addSubview(birthdayView)
        scrollView.addSubview(datePicker)
        scrollView.addSubview(addInfoLabel)
        scrollView.addSubview(feedInputView)
        view.addSubview(scrollView)
        
        choosePhotoBtn.setImage(UIImage(named: "uploadPhoto"), for: .normal)
        basicSubTitleLabel.text = "기본 정보"
        basicSubTitleLabel.font = .boldSystemFont(ofSize: 16)
        
        addInfoLabel.text = "추가 정보"
        addInfoLabel.font = .boldSystemFont(ofSize: 16)
        
        datePicker.isHidden = true
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        
        scrollView.snp.makeConstraints{make in
            make.top.bottom.leading.trailing.equalTo(view)
        }
        
        choosePhotoBtn.snp.makeConstraints{ make in
            make.width.equalTo(120)
            make.height.equalTo(120)
            make.centerX.equalToSuperview()
            make.top.equalTo(scrollView.snp.top).offset(16)
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
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(birthdayView.snp.bottom).offset(8)
            make.leading.trailing.equalTo(view).inset(16)
            make.height.equalTo(0)
        }
        
        addInfoLabel.snp.makeConstraints{make in
            make.leading.trailing.equalTo(view).inset(16)
            make.top.equalTo(datePicker.snp.bottom).offset(18)
            make.height.equalTo(24)
        }
        
        feedInputView.snp.makeConstraints{make in
            make.leading.trailing.equalTo(view).inset(16)
            make.top.equalTo(addInfoLabel.snp.bottom)
            make.height.equalTo(88)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
      
    }
    
    private func setupActions() {
        choosePhotoBtn.addTarget(self, action: #selector(choosePhotoButtonTapped), for: .touchUpInside)
        genderView.genderChangeBtn.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        genderView.neuteringCheckboxButton.addTarget(self, action: #selector(checkboxButtonTapped), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        birthdayView.birthdayChangeBtn.addTarget(self, action: #selector(datePickerButtonTapped), for: .touchUpInside)
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
    
    @objc func datePickerButtonTapped() {
        
        print("클릭")
         
        if datePicker.isHidden {
            datePicker.isHidden = false
           
            datePicker.snp.updateConstraints { make in
                make.height.equalTo(300)
            }
            
        } else {
            datePicker.isHidden = true
            
            datePicker.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }

    }
    
    @objc func datePickerValueChanged() {

        let formattedDate = dateFormatterUtils.formatDateString(dateFormatterUtils.dateFormatter.string(from: datePicker.date))
        
        birthdayView.selectedBirthdayLabel.text = DateFormatterUtils.formatFullDate(formattedDate!, from: "yyyy-MM-dd HH:mm:ss", to: "yyyy.MM.dd (E)")
        
        let calendar = Calendar.current
        
        let selectedComponents = calendar.dateComponents([.year], from: datePicker.date)
        let year = selectedComponents.year!
        print(year)
        
        let currentDate = Date()
        let currentComponents = calendar.dateComponents([.year], from: currentDate)
        let currentYear = currentComponents.year!
        
        let age = Int(currentYear) - Int(year)
        birthdayView.ageCheckLabel.text = "\(age)"
    }
    
    @objc func checkboxButtonTapped(_ sender: UIButton) {
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
