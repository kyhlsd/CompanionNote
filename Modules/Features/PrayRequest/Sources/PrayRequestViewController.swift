//
//  PrayRequestViewController.swift
//  Features
//
//  Created by 김영훈 on 3/20/25.
//

import UIKit
import Shared

public class PrayRequestViewController: UIViewController {
    
    private lazy var prayListBackgroundView = {
        let prayListBackgroundView = PrayListBackgroundView()
        prayListBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        return prayListBackgroundView
    }()
    
    private lazy var prayRequestTableView = {
        let prayRequestTableView = PrayRequestTableView(prayRequests: PrayRequest.dummyDatas)
        prayRequestTableView.translatesAutoresizingMaskIntoConstraints = false
        return prayRequestTableView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(prayListBackgroundView)
        prayListBackgroundView.addSubview(prayRequestTableView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            prayListBackgroundView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            prayListBackgroundView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            prayListBackgroundView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 200),
            prayListBackgroundView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            prayRequestTableView.leadingAnchor.constraint(equalTo: prayListBackgroundView.leadingAnchor, constant: 24),
            prayRequestTableView.trailingAnchor.constraint(equalTo: prayListBackgroundView.trailingAnchor, constant: -24),
            prayRequestTableView.topAnchor.constraint(equalTo: prayListBackgroundView.topAnchor, constant: 24),
            prayRequestTableView.bottomAnchor.constraint(equalTo: prayListBackgroundView.bottomAnchor, constant: -24),
        ])
    }
    
}
