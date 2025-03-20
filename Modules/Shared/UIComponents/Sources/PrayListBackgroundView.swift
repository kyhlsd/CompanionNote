//
//  PrayListBackgroundView.swift
//  Shared
//
//  Created by 김영훈 on 3/20/25.
//

import UIKit

public class PrayListBackgroundView: UIView {

    let imageView = UIImageView()
    
    override public init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        imageView.image = UIImage(named: "PrayListBackgroundDark", in: Bundle.module, with: nil)
        imageView.contentMode = .scaleToFill
        
        imageView.layer.cornerRadius = 12
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.layer.masksToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowRadius = 6
        
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
