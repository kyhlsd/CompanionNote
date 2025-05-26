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
            subjectLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            subjectLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subjectLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: subjectLabel.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupSubjectLabel() {
        subjectLabel.font = Shared.AppFonts.body
        subjectLabel.numberOfLines = 0
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.font = Shared.AppFonts.body
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byTruncatingTail
        descriptionLabel.lineBreakStrategy = .pushOut
    }
    
    func configure(with prayRequestContent: PrayRequestContent) {
        subjectLabel.attributedText = NSAttributedString(
            string: prayRequestContent.subject,
            attributes: Shared.FontTextAttributes.bodyTextAttributes
        )
        descriptionLabel.text = prayRequestContent.description
    }
}
