import UIKit
import SnapKit

protocol CalendarStackViewDelegate: AnyObject {
    func didTapPrevButton()
    func didTapNextButton()
}

class CalendarStackView: UIStackView {
    
    weak var delegate: CalendarStackViewDelegate?
    let prevButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_arrow_left"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()

    let nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_arrow_right"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        axis = .horizontal
        alignment = .center
        distribution = .equalSpacing
        spacing = 8
        backgroundColor = UIColor(named: "Secondary")

        addArrangedSubview(prevButton)
        addArrangedSubview(titleLabel)
        addArrangedSubview(nextButton)

        prevButton.addTarget(self, action: #selector(didTapPrevButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }
    
    @objc private func didTapPrevButton() {
        delegate?.didTapPrevButton()
    }
    
    @objc private func didTapNextButton() {
        delegate?.didTapNextButton()
    }
    
}

