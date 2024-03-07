//
//  BasicUserInfoView.swift
//  fit-a-pet-client
//
//  Created by 최희진 on 3/4/24.
//

import UIKit

class BasicUserInfoView: UIView{
    let basicSubTitleLabel = UILabel()
    let nameInputView =  CustomVerticalView(labelText: "이름", placeholder: "이름")
    let genderView = GenderView()
    let birthdayView = BirthdayView()
    let datePicker = UIDatePicker()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        
        addSubview(basicSubTitleLabel)
        addSubview(nameInputView)
        addSubview(genderView)
        addSubview(birthdayView)
        addSubview(datePicker)
        
        basicSubTitleLabel.text = "기본 정보"
        basicSubTitleLabel.font = .boldSystemFont(ofSize: 16)
        
        datePicker.isHidden = true
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        
        nameInputView.textInputField.text = PetDataManager.petEditData.petName
        
        basicSubTitleLabel.snp.makeConstraints{make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(24)
        }
        
        nameInputView.snp.makeConstraints{make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(basicSubTitleLabel.snp.bottom)
            make.height.equalTo(88)
        }
        
        genderView.snp.makeConstraints{make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(nameInputView.snp.bottom).offset(16)
            make.height.equalTo(120)
        }
        
        birthdayView.snp.makeConstraints{make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(genderView.snp.bottom).offset(16)
            make.height.equalTo(120)
        }
        
        datePicker.snp.makeConstraints{make in
            make.top.equalTo(birthdayView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(0)
        }
    } 
}
