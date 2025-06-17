//
//  PrayItemTableViewCell.swift
//  Shared
//
//  Created by 김영훈 on 3/28/25.
//

import UIKit
import Core
import Shared

final class PrayItemTableViewCell: UITableViewCell {

    let nameLabel = UILabel()
    let contentLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setups
    private func setupUI() {
        setupNameLabel()
        setupContentLabel()
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(contentLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    private func setupNameLabel() {
        nameLabel.font = Shared.AppFonts.micro
        nameLabel.numberOfLines = 1
    }
    
    private func setupContentLabel() {
        contentLabel.font = Shared.AppFonts.micro
        contentLabel.numberOfLines = 2
        contentLabel.lineBreakMode = .byTruncatingTail
        contentLabel.lineBreakStrategy = .pushOut
    }
    
    func configure(with prayItem: PrayItem) {
        nameLabel.attributedText = NSAttributedString(
            string: prayItem.name,
            attributes: Shared.FontTextAttributes.detailTextAttributes
        )
        contentLabel.text = prayItem.content
    }
}
