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
    
    private lazy var prayRequestCollectionView = {
        let prayRequestCollectionView = PrayRequestCollectionView(prayRequests: PrayRequest.dummyDatas)
        prayRequestCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return prayRequestCollectionView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        setupNavigationBar()
        setupUI()
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.white,
            .foregroundColor: UIColor.white,
            .strokeWidth: -2.0
        ]
        titleLabel.attributedText = NSAttributedString(
            string: "기도 제목",
            attributes: strokeTextAttributes
        )
        titleLabel.font = UIFont(name: "NanumDongHwaDdoBag", size: 28)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let plusButton = UIButton()
        let plusImage = UIImage(systemName: "plus")?
            .withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
        plusButton.setImage(plusImage, for: .normal)
        plusButton.tintColor = .white
        plusButton.translatesAutoresizingMaskIntoConstraints = false

        let deleteButton = UIButton()
        let deleteImage = UIImage(systemName: "trash")?
            .withConfiguration(UIImage.SymbolConfiguration(weight: .regular))
        deleteButton.setImage(deleteImage, for: .normal)
        deleteButton.tintColor = .white
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        containerView.addSubview(plusButton)
        containerView.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 60),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            deleteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),

            plusButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -12),
            plusButton.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])

        navigationItem.titleView = containerView
    }

    
    private func setupUI() {
        view.addSubview(praySearchBar)
        view.addSubview(prayRequestCollectionView)
        
        let sidePadding = UIScreen.main.bounds.width * (1 - 0.88) / 2
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
            praySearchBar.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 12),
            praySearchBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: sidePadding),
            praySearchBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -sidePadding),
            
            prayRequestCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: sidePadding),
            prayRequestCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -sidePadding),
            prayRequestCollectionView.topAnchor.constraint(equalTo: praySearchBar.bottomAnchor, constant: 20),
            prayRequestCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // 터치 이벤트를 동시에 처리하도록 허용
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
