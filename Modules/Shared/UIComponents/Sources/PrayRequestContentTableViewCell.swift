//
//  PrayRequestContentTableViewCell.swift
//  Shared
//
//  Created by 김영훈 on 3/28/25.
//

import UIKit

class PrayRequestContentTableViewCell: UITableViewCell {

    private let subjectLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .systemBlue
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        selectionStyle = .none
        
        contentView.addSubview(subjectLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            subjectLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            subjectLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subjectLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: subjectLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    func configure(with prayRequestContent: PrayRequestContent) {
        subjectLabel.text = prayRequestContent.subject
        descriptionLabel.text = prayRequestContent.description
    }
}
