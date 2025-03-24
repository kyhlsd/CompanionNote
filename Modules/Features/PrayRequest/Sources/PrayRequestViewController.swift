//
//  PrayRequestViewController.swift
//  Features
//
//  Created by 김영훈 on 3/20/25.
//

import UIKit
import Shared

public class PrayRequestViewController: UIViewController {
    
    private lazy var praySearchBar = {
        let praySearchBar = PraySearchBar()
        praySearchBar.translatesAutoresizingMaskIntoConstraints = false
        return praySearchBar
    }()
    
    private lazy var prayListBackgroundView = {
        let prayListBackgroundView = PrayListBackgroundView()
        prayListBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        return prayListBackgroundView
    }()
    
    private lazy var prayRequestTableView = {
        let prayRequestTableView = PrayRequestCollectionView(prayRequests: PrayRequest.dummyDatas)
        prayRequestTableView.translatesAutoresizingMaskIntoConstraints = false
        return prayRequestTableView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        setupNavigationTitle()
        setupUI()
    }
    
    private func setupNavigationTitle() {
        let titleLabel = UILabel()
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.black,
            .strokeWidth: -2.0
        ]
        titleLabel.attributedText = NSAttributedString(
            string: "기도 제목",
            attributes: strokeTextAttributes
        )
        titleLabel.font = UIFont(name: "NanumDongHwaDdoBag", size: 28)
        titleLabel.sizeToFit()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let containerView = UIView()
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        navigationItem.titleView = containerView
    }
    
    private func setupUI() {
        view.addSubview(prayListBackgroundView)
        prayListBackgroundView.addSubview(praySearchBar)
        prayListBackgroundView.addSubview(prayRequestTableView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            prayListBackgroundView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            prayListBackgroundView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            prayListBackgroundView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            prayListBackgroundView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            praySearchBar.topAnchor.constraint(equalTo: prayListBackgroundView.topAnchor, constant: 20),
            praySearchBar.leadingAnchor.constraint(equalTo: prayListBackgroundView.leadingAnchor, constant: 20),
            praySearchBar.trailingAnchor.constraint(equalTo: prayListBackgroundView.trailingAnchor, constant: -20),
            
            // TableViewCell에 좌우 여백 8 존재 (그림자 공간)
            prayRequestTableView.leadingAnchor.constraint(equalTo: prayListBackgroundView.leadingAnchor, constant: 12),
            prayRequestTableView.trailingAnchor.constraint(equalTo: prayListBackgroundView.trailingAnchor, constant: -12),
            prayRequestTableView.topAnchor.constraint(equalTo: praySearchBar.bottomAnchor, constant: 20),
            prayRequestTableView.bottomAnchor.constraint(equalTo: prayListBackgroundView.bottomAnchor, constant: -20),
        ])
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
