//
//  SignUpProgressBar.swift
//  fit-a-pet-client
//
//  Created by 최희진 on 2023/09/06.
//

import UIKit


class SignUpProgressBar: UIView {
    
    private let progressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = UIColor(named: "Gray3")
        view.progressTintColor = UIColor(named: "PrimaryColor")
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.edges.equalToSuperview()//현재 뷰를 부모 뷰의 네 가장자리와 맞추도록
            make.height.equalTo(5)
        }
    }
    
    func setProgress(_ progress: Float, animated: Bool) {
        progressView.setProgress(progress, animated: animated)
    }
}
