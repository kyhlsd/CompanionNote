//
//  PraySearchBar.swift
//  Shared
//
//  Created by 김영훈 on 3/22/25.
//

import UIKit

public class CustomSearchBar: UIView {
    
    override public init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        layer.cornerRadius = 12
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력하세요"
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = UIColor(named: "SearchBarColor", in: Bundle.module, compatibleWith: nil)
        searchBar.layer.cornerRadius = 8
        searchBar.layer.borderColor = UIColor.systemGray.cgColor
        searchBar.layer.borderWidth = 0.2
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        let textField = searchBar.searchTextField
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor),
            textField.topAnchor.constraint(equalTo: searchBar.topAnchor),
            textField.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor)
        ])
        
        addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
