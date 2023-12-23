import UIKit

class CustomProgressBar: UIView {
    static let shared = CustomProgressBar()
    
    let progressView: UIProgressView = {
        let view = UIProgressView()
        view.trackTintColor = UIColor(named: "Gray0")
        view.progressTintColor = UIColor(named: "PrimaryColor")
        return view
    }()
    
    private init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(5)
        }
    }
    
    func setProgress(_ progress: Float) {
        progressView.setProgress(progress, animated: true)
    }
}

