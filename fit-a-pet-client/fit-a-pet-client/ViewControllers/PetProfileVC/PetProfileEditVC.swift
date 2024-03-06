

import UIKit
import SnapKit

class PetProfileEditVC: CustomNavigationBar{
    
    private let imagePickerUtil = ImagePickerUtil()
    private let choosePhotoBtn = UIButton()
    private let scrollView = UIScrollView()
    private let basicUserInofoView = BasicUserInfoView()
    private let addInfoLabel = UILabel()
    private let feedInputView = CustomVerticalView(labelText: "사료", placeholder: "사료")
    
    private let deleteButton = UIButton()
    private let editButton = CustomNextBtn(title: "수정하기")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        setupActions()
    }
    
    func initView(){
        view.backgroundColor = .white

        scrollView.addSubview(choosePhotoBtn)
        scrollView.addSubview(basicUserInofoView)
        scrollView.addSubview(addInfoLabel)
        scrollView.addSubview(feedInputView)
        scrollView.addSubview(deleteButton)
        scrollView.addSubview(editButton)
        view.addSubview(scrollView)
        
        choosePhotoBtn.setImage(UIImage(named: "uploadPhoto"), for: .normal)
        
        addInfoLabel.text = "추가 정보"
        addInfoLabel.font = .boldSystemFont(ofSize: 16)
        
        deleteButton.setTitle("삭제하기", for: .normal)
        deleteButton.setTitleColor(UIColor(named: "Danger"), for: .normal)
        deleteButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        
        scrollView.snp.makeConstraints{make in
            make.top.bottom.leading.trailing.equalTo(view)
        }
        
        choosePhotoBtn.snp.makeConstraints{ make in
            make.width.equalTo(120)
            make.height.equalTo(120)
            make.centerX.equalToSuperview()
            make.top.equalTo(scrollView.snp.top).offset(16)
        }
        
        basicUserInofoView.snp.makeConstraints{make in
            make.top.equalTo(choosePhotoBtn.snp.bottom).offset(16)
            make.leading.trailing.equalTo(view)
            make.height.equalTo(370)
        }
        
        addInfoLabel.snp.makeConstraints{make in
            make.leading.trailing.equalTo(view).inset(16)
            make.top.equalTo(basicUserInofoView.snp.bottom).offset(16)
            make.height.equalTo(24)
        }
        
        feedInputView.snp.makeConstraints{make in
            make.leading.trailing.equalTo(view).inset(16)
            make.top.equalTo(addInfoLabel.snp.bottom)
            make.height.equalTo(88)
        }
        
        deleteButton.snp.makeConstraints{make in
            make.height.equalTo(44)
            make.width.equalTo(50)
            make.centerX.equalTo(view)
            make.top.equalTo(feedInputView.snp.bottom).offset(58)
        }
        
        editButton.snp.makeConstraints{make in
            make.top.equalTo(deleteButton.snp.bottom).offset(40)
            make.leading.trailing.equalTo(view).inset(16)
            make.height.equalTo(56)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
      
    }
    
    private func setupActions() {
        choosePhotoBtn.addTarget(self, action: #selector(choosePhotoButtonTapped), for: .touchUpInside)
        basicUserInofoView.genderView.genderChangeBtn.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        basicUserInofoView.genderView.neuteringCheckboxButton.addTarget(self, action: #selector(checkboxButtonTapped), for: .touchUpInside)
        basicUserInofoView.datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        basicUserInofoView.birthdayView.birthdayChangeBtn.addTarget(self, action: #selector(datePickerButtonTapped), for: .touchUpInside)
    }
    
    @objc private func showMenu() {

        let maleMenuItem = UIAction(title: "수컷") { _ in
            self.basicUserInofoView.genderView.selectedGenderLabel.text = "수컷"
        }
        
        let femaleMenuItem = UIAction(title: "암컷") { _ in
            self.basicUserInofoView.genderView.selectedGenderLabel.text = "암컷"
        }
        
        let menu = UIMenu(
            title: "",
            children: [maleMenuItem, femaleMenuItem]
        )
        
        self.basicUserInofoView.genderView.genderChangeBtn.menu = menu
        self.basicUserInofoView.genderView.genderChangeBtn.showsMenuAsPrimaryAction = true
    }
    
    @objc func datePickerButtonTapped() {

        if basicUserInofoView.datePicker.isHidden {
            basicUserInofoView.datePicker.isHidden = false
           
            basicUserInofoView.datePicker.snp.updateConstraints { make in
                make.height.equalTo(300)
            }
            
            basicUserInofoView.snp.updateConstraints { make in
                make.height.equalTo(700)
            }
            
            
        } else {
            basicUserInofoView.datePicker.isHidden = true
            
            basicUserInofoView.datePicker.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            basicUserInofoView.snp.updateConstraints { make in
                make.height.equalTo(370)
            }
            
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }

    }
    
    @objc func datePickerValueChanged() {

        let formattedDate = DateFormatterUtils.formatDateString(DateFormatterUtils.dateFormatter.string(from: basicUserInofoView.datePicker.date))
        
        basicUserInofoView.birthdayView.selectedBirthdayLabel.text = DateFormatterUtils.formatFullDate(formattedDate!, from: "yyyy-MM-dd HH:mm:ss", to: "yyyy.MM.dd (E)")
        
        let calendar = Calendar.current
        
        let selectedComponents = calendar.dateComponents([.year], from: basicUserInofoView.datePicker.date)
        let year = selectedComponents.year!
        print(year)
        
        let currentDate = Date()
        let currentComponents = calendar.dateComponents([.year], from: currentDate)
        let currentYear = currentComponents.year!
        
        let age = Int(currentYear) - Int(year)
        basicUserInofoView.birthdayView.ageCheckLabel.text = "\(age)"
    }
    
    @objc func checkboxButtonTapped(_ sender: UIButton) {
        self.basicUserInofoView.genderView.neuteringCheckboxButton.isSelected.toggle()
        print( self.basicUserInofoView.genderView.neuteringCheckboxButton.isSelected)
        self.basicUserInofoView.genderView.updateCheckboxColor()
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
