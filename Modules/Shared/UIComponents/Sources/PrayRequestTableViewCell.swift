//
//  PrayRequestTableViewCell.swift
//  Shared
//
//  Created by 김영훈 on 3/20/25.
//

import UIKit

class PrayRequestTableViewCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
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
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            detailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            dateLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func configure(with prayRequest: PrayRequest) {
        titleLabel.text = prayRequest.title
        detailLabel.text = prayRequest.text
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateLabel.text = dateFormatter.string(from: prayRequest.date)
    }
}
