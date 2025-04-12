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
        label.font = UIFont(name: "IropkeBatangM", size: 12)
        label.textColor = .black
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IropkeBatangM", size: 12)
        label.textColor = .black
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.lineBreakStrategy = .pushOut
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
            
            descriptionLabel.topAnchor.constraint(equalTo: subjectLabel.bottomAnchor, constant: 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with prayRequestContent: PrayRequestContent) {
        let subjectStrokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.black,
            .strokeWidth: -2.0
        ]
        subjectLabel.attributedText = NSAttributedString(
            string: prayRequestContent.subject,
            attributes: subjectStrokeTextAttributes
        )
        descriptionLabel.text = prayRequestContent.description
    }
}
