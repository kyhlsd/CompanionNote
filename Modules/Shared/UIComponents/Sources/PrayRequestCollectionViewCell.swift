//
//  PrayRequestTableViewCell.swift
//  Shared
//
//  Created by 김영훈 on 3/20/25.
//

import UIKit

class PrayRequestCollectionViewCell: UICollectionViewCell {
    
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
        
        view.layer.cornerRadius = 10
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
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        gradientLayer.cornerRadius = 10
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    private let noteHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "PrayRequestDark", in: Bundle.module, compatibleWith: nil)
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let noteFooterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "PrayRequestLight", in: Bundle.module, compatibleWith: nil)
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
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
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        selectedBackgroundView = UIView()
        
        contentView.addSubview(shadowView)
        shadowView.addSubview(noteHeaderView)
        shadowView.addSubview(noteFooterView)
        shadowView.addSubview(circleView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            circleView.centerXAnchor.constraint(equalTo: shadowView.centerXAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 20),
            circleView.heightAnchor.constraint(equalToConstant: 20),
            circleView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            
            noteHeaderView.topAnchor.constraint(equalTo: circleView.centerYAnchor),
            noteHeaderView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            noteHeaderView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            noteHeaderView.heightAnchor.constraint(equalToConstant: 32),
            
            noteFooterView.topAnchor.constraint(equalTo: noteHeaderView.bottomAnchor),
            noteFooterView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            noteFooterView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            noteFooterView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor),
            
            titleLabel.centerYAnchor.constraint(equalTo: noteHeaderView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: noteHeaderView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: noteHeaderView.trailingAnchor, constant: -12),
            
            detailLabel.topAnchor.constraint(equalTo: noteFooterView.topAnchor, constant: 5),
            detailLabel.leadingAnchor.constraint(equalTo: noteFooterView.leadingAnchor, constant: 12),
            detailLabel.trailingAnchor.constraint(equalTo: noteFooterView.trailingAnchor, constant: -12),
            
            dateLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: noteFooterView.leadingAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: noteFooterView.trailingAnchor, constant: -12),
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
