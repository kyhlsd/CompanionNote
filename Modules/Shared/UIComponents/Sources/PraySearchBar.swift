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
        
        overrideUserInterfaceStyle = .light
        
        layer.cornerRadius = 12
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력하세요"
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = UIColor(named: "SearchBarColor", in: Bundle.module, compatibleWith: nil)
        searchBar.layer.cornerRadius = 8
        searchBar.layer.borderColor = UIColor.systemGray.cgColor
        searchBar.layer.borderWidth = 0.5
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
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        searchButton.backgroundColor = UIColor(named: "SearchButtonColor", in: Bundle.module, compatibleWith: nil)
        searchButton.layer.cornerRadius = 8
        searchButton.layer.borderColor = UIColor.systemGray.cgColor
        searchButton.layer.borderWidth = 0.5
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(searchBar)
        addSubview(searchButton)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 32),
            
            searchButton.topAnchor.constraint(equalTo: searchBar.topAnchor),
            searchButton.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
