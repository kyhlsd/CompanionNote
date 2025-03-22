//
//  PraySearchBar.swift
//  Shared
//
//  Created by 김영훈 on 3/22/25.
//

import UIKit

public class PraySearchBar: UIView {
    
    override public init(frame: CGRect = .zero) {
        super.init(frame: frame)
        backgroundColor = .systemGreen
        layer.cornerRadius = 12
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력하세요"
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        let textField = searchBar.searchTextField
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor),
            textField.topAnchor.constraint(equalTo: searchBar.topAnchor),
            textField.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor)
        ])
        
        let searchButton = UIButton(type: .system)
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.systemGray, for: .normal)
        searchButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        searchButton.backgroundColor = .blue
        searchButton.layer.cornerRadius = 8
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(searchBar)
        addSubview(searchButton)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 32),
            
            searchButton.topAnchor.constraint(equalTo: searchBar.topAnchor),
            searchButton.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            searchButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
