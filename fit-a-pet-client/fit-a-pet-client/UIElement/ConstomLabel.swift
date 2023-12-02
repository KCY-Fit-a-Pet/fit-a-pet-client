//
//  SignUpConstomLabel.swift
//  fit-a-pet-client
//
//  Created by 최희진 on 2023/09/06.
//

import UIKit

class ConstomLabel: UIView {
    private let label: UILabel = {
        let label = UILabel()
        //label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0 // 여러 줄 표시를 위해 설정
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()

        }
    }
    
    func setAttributedText(_ text: String,_ range: String ) {
        let attributedText = NSMutableAttributedString(string: text)
        
        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        let rangeText = (text as NSString).range(of: range)
        
        attributedText.addAttribute(.font, value: boldFont, range: rangeText)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.lineSpacing = 8
        
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
        
        label.attributedText = attributedText
    }
}
