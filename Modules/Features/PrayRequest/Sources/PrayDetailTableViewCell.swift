//
//  PrayDetailTableViewCell.swift
//  Shared
//
//  Created by 김영훈 on 5/23/25.
//

import UIKit
import Core
import Shared

final class PrayDetailTableViewCell: UITableViewCell {

    private let subjectLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setups
    private func setupUI() {
        setupSubjectLabel()
        setupDescriptionLabel()
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(subjectLabel)
        contentView.addSubview(descriptionLabel)
        
        subjectLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            subjectLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            subjectLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subjectLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: subjectLabel.bottomAnchor, constant: 2),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupSubjectLabel() {
        subjectLabel.font = UIFont(name: "IropkeBatangM", size: 16)
        subjectLabel.numberOfLines = 0
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.font = UIFont(name: "IropkeBatangM", size: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byTruncatingTail
        descriptionLabel.lineBreakStrategy = .pushOut
    }
    
    func configure(with prayRequestContent: PrayRequestContent) {
        let subjectStrokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: -3.0
        ]
        subjectLabel.attributedText = NSAttributedString(
            string: prayRequestContent.subject,
            attributes: subjectStrokeTextAttributes
        )
        descriptionLabel.text = prayRequestContent.description
    }
}
