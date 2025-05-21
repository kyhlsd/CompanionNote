//
//  AddPrayContentButtonCell.swift
//  Shared
//
//  Created by 김영훈 on 5/21/25.
//

import UIKit

class AddPrayContentButtonCell: UITableViewCell {
    
    weak var delegate: AddPrayContentButtonCellDelegate?
    
    private let addContentButton = {
        let button = UIButton()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "IropkeBatangM", size: 16) ?? .systemFont(ofSize: 14),
            .foregroundColor: UIColor.white,
            .strokeWidth: -2.0
        ]
        let attributedTitle = NSAttributedString(string: "항목 추가", attributes: attributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        addContentButton.addAction(UIAction() { [weak self] _ in
            self?.delegate?.didTapAddPrayContentButton()
        }, for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        selectionStyle = .none
        
        contentView.addSubview(addContentButton)
        
        NSLayoutConstraint.activate([
            addContentButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            addContentButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            addContentButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            addContentButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
