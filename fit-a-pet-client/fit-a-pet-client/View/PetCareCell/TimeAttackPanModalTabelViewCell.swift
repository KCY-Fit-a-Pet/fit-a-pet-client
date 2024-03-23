import UIKit
import SnapKit

class TimeAttackPanModalTableViewCell: UITableViewCell {
    
    private var isSelectedState = false

    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
 
        contentView.addSubview(timeLabel)

        timeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
    }
    
    private func updateCellState() {
        if isSelectedState {
            timeLabel.textColor = UIColor(named: "Primary")
        } else {
            timeLabel.textColor = .black
        }
    }
    
    func toggleSelectedState() {
        isSelectedState.toggle()
        updateCellState()
    }

    func configure(with time: String) {
        timeLabel.text = time
        updateCellState()
    }
}


