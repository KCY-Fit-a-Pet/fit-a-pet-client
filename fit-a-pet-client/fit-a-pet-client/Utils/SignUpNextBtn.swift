//
//  SignUpNextBtn.swift
//  fit-a-pet-client
//
//  Created by 최희진 on 2023/09/05.
//

import Foundation
import UIKit



class SignUpNextBtn: UIButton {
    
    var GRAY2 = UIColor(named: "Gray2")
    var GRAY3 = UIColor(named: "Gray3")
    var PRIMARYCOLOR = UIColor(named: "PrimaryColor")

//    // 버튼 상태 종류
//    enum btnState {
//        case On
//        case Off
//    }

//    // 기본 값 = off 상태
//    var isOn: btnState = .Off {
//        didSet {
//            setting()
//        }
//    }

//      //.. 컬러변수 생략
//    // 2. 코드로 버튼을 구현시
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        // 기본 셋팅
//        setting()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    init(title: String) {
       super.init(frame: .zero)
       
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        setTitleColor(.white, for: .normal)
        backgroundColor = GRAY2
        layer.cornerRadius = 5
       
       // SnapKit을 사용하여 버튼의 레이아웃을 설정할 수 있습니다.
       // 예: 버튼의 높이를 고정하고 상위 뷰의 중앙에 배치하는 제약 조건을 추가합니다.
       snp.makeConstraints { make in
           make.height.equalTo(55)
          // make.centerX.centerY.equalToSuperview()
       }
   }
       
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
    
    func updateButtonColor(with text: String) {
        if text.isEmpty {
            backgroundColor = GRAY2
        } else {
            backgroundColor = PRIMARYCOLOR // 텍스트가 있는 경우 다른 색상으로 변경
        }
    }
}
