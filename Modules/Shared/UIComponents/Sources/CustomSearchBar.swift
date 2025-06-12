//
//  PraySearchBar.swift
//  Shared
//
//  Created by 김영훈 on 3/22/25.
//

import UIKit

public class CustomSearchBar: UISearchBar {
    
    override public init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        placeholder = "검색어를 입력하세요"
        searchBarStyle = .minimal
        backgroundColor = UIColor(named: "SearchBarColor", in: Bundle.module, compatibleWith: nil)
        layer.cornerRadius = 8
        layer.borderColor = UIColor.systemGray.cgColor
        layer.borderWidth = 0.2
        translatesAutoresizingMaskIntoConstraints = false
        
        let textField = searchTextField
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
