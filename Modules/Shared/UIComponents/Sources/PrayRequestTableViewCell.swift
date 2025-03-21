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
    
    private let circleView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = false
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.6
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.shadowRadius = 6
        
        let gradientLayer = CAGradientLayer()
        let circleLightPink = UIColor(named: "CircleLightPink", in: Bundle.module, compatibleWith: nil) ?? UIColor.systemBlue
        let circleDeepPink = UIColor(named: "CircleDeepPink", in: Bundle.module, compatibleWith: nil) ?? UIColor.systemGray
        
        gradientLayer.colors = [
            UIColor.white.cgColor,
            circleLightPink.cgColor,
            circleDeepPink.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        gradientLayer.cornerRadius = 12
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    private let rectangleView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let shadowView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 4, height: 4)
        view.layer.shadowRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        
        contentView.addSubview(shadowView)
        shadowView.addSubview(rectangleView)
        shadowView.addSubview(circleView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            circleView.centerXAnchor.constraint(equalTo: shadowView.centerXAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 24),
            circleView.heightAnchor.constraint(equalToConstant: 24),
            circleView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            
            rectangleView.topAnchor.constraint(equalTo: circleView.centerYAnchor),
            rectangleView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            rectangleView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            rectangleView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: rectangleView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: rectangleView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: rectangleView.trailingAnchor, constant: -15),
            
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            detailLabel.leadingAnchor.constraint(equalTo: rectangleView.leadingAnchor, constant: 15),
            detailLabel.trailingAnchor.constraint(equalTo: rectangleView.trailingAnchor, constant: -15),
            
            dateLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: rectangleView.leadingAnchor, constant: 15),
            dateLabel.trailingAnchor.constraint(equalTo: rectangleView.trailingAnchor, constant: -15),
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
