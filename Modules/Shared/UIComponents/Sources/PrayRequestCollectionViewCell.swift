//
//  PrayRequestTableViewCell.swift
//  Shared
//
//  Created by 김영훈 on 3/20/25.
//

import UIKit

class PrayRequestCollectionViewCell: UICollectionViewCell {
    
    private var prayRequestUUID: UUID?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IropkeBatangM", size: 16)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var prayRequestContentTableView: PrayRequestContentTableView = {
        let tableView = PrayRequestContentTableView()
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IropkeBatangM", size: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var checkBox: CheckBox = {
        let checkBox = CheckBox()
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.isHidden = true
        return checkBox
    }()
    
    private var dateLabelTrailingConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {

        backgroundColor = UIColor(named: "PrayCellColor", in: Bundle.module, compatibleWith: nil)
        layer.cornerRadius = 8
        
        selectedBackgroundView = UIView()
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(checkBox)
        contentView.addSubview(prayRequestContentTableView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),

            dateLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            
            checkBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            checkBox.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            checkBox.heightAnchor.constraint(equalToConstant: 24),
            checkBox.widthAnchor.constraint(equalToConstant: 24),

            prayRequestContentTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            prayRequestContentTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            prayRequestContentTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            prayRequestContentTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        dateLabelTrailingConstraint = dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        dateLabelTrailingConstraint.isActive = true
    }
    
    func configure(with prayRequest: PrayRequest) {
        let titleStrokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.systemBlue,
            .foregroundColor: UIColor.systemBlue,
            .strokeWidth: -4.0
        ]
        titleLabel.attributedText = NSAttributedString(
            string: prayRequest.title,
            attributes: titleStrokeTextAttributes
        )
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateLabel.text = dateFormatter.string(from: prayRequest.date)
        prayRequestContentTableView.prayRequestContents = prayRequest.contents
        DispatchQueue.main.async {
            self.prayRequestContentTableView.reloadData()
        }
        
        self.prayRequestUUID = prayRequest.uuid
    }
    
    func enableDeleteMode() {
        checkBox.isHidden = false
        dateLabelTrailingConstraint.isActive = false
        dateLabelTrailingConstraint = dateLabel.trailingAnchor.constraint(equalTo: checkBox.leadingAnchor, constant: -12)
        dateLabelTrailingConstraint.isActive = true
    }
    
    func disableDeleteMode() {
        checkBox.isHidden = true
        checkBox.isChecked = false
        dateLabelTrailingConstraint.isActive = false
        dateLabelTrailingConstraint = dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        dateLabelTrailingConstraint.isActive = true
    }
    
    func toggleCheckBoxState() {
        checkBox.isChecked.toggle()
    }
    
    func getCheckedState() -> Bool {
        return checkBox.isChecked
    }
    
    func getPrayRequestUUID() -> UUID? {
        return self.prayRequestUUID
    }
}
