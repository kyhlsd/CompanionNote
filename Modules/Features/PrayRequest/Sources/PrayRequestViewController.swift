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
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(praySearchBar)
        view.addSubview(prayListBackgroundView)
        prayListBackgroundView.addSubview(prayRequestTableView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            praySearchBar.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 100),
            praySearchBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            praySearchBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            
            prayListBackgroundView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            prayListBackgroundView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            prayListBackgroundView.topAnchor.constraint(equalTo: praySearchBar.bottomAnchor, constant: 24),
            prayListBackgroundView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            // TableViewCell에 좌우 여백 8 존재 (그림자 공간)
            prayRequestTableView.leadingAnchor.constraint(equalTo: prayListBackgroundView.leadingAnchor, constant: 12),
            prayRequestTableView.trailingAnchor.constraint(equalTo: prayListBackgroundView.trailingAnchor, constant: -12),
            prayRequestTableView.topAnchor.constraint(equalTo: prayListBackgroundView.topAnchor, constant: 20),
            prayRequestTableView.bottomAnchor.constraint(equalTo: prayListBackgroundView.bottomAnchor, constant: -20),
        ])
    }
    
}
