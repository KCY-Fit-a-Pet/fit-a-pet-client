
import UIKit
import SnapKit

class NoRecordDataView: UIView{
    
    let textLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
      
        addSubview(textLabel)
        
        let attributedString = NSMutableAttributedString(string: "새로운 기록을\n남겨주세요")
        let range = NSRange(location: 8, length: 1)
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont.systemFont(ofSize: 14, weight: .medium)]
        attributedString.addAttributes(attributes, range: range)
        
        textLabel.attributedText = attributedString
        textLabel.numberOfLines = 2
        textLabel.textColor = UIColor(named: "Gray3")
        textLabel.font = .systemFont(ofSize: 14, weight: .medium)
        textLabel.textAlignment = .center
        
        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
