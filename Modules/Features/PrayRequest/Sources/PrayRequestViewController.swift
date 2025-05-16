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
            .strokeWidth: -2.5
        ]
        titleLabel.attributedText = NSAttributedString(
            string: "기도 제목",
            attributes: strokeTextAttributes
        )
        titleLabel.font = UIFont(name: "IropkeBatangM", size: 22)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let plusButton = UIButton()
        let plusImage = UIImage(systemName: "plus")?
            .withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
        plusButton.setImage(plusImage, for: .normal)
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.addAction(UIAction{ [weak self] _ in
            self?.plusButtonTapped()
        }, for: .touchUpInside)

        let deleteButton = UIButton()
        let deleteImage = UIImage(systemName: "trash")?
            .withConfiguration(UIImage.SymbolConfiguration(weight: .regular))
        deleteButton.setImage(deleteImage, for: .normal)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        let containerView = UIView()
        containerView.isUserInteractionEnabled = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        containerView.addSubview(plusButton)
        containerView.addSubview(deleteButton)
        
        var height: CGFloat = 44
        if let navigationController = self.navigationController {
            height = navigationController.navigationBar.frame.height + view.safeAreaInsets.top
        }
        let sidePadding = UIScreen.main.bounds.width * (1 - 0.88) / 2
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - sidePadding * 2),
            containerView.heightAnchor.constraint(equalToConstant: height),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),

            deleteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 28),
            deleteButton.heightAnchor.constraint(equalToConstant: 28),

            plusButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -4),
            plusButton.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 28),
            plusButton.heightAnchor.constraint(equalToConstant: 28)
        ])

        navigationItem.titleView = containerView
    }

    
    private func setupUI() {
        view.addSubview(praySearchBar)
        view.addSubview(prayRequestCollectionView)
        
        let sidePadding = UIScreen.main.bounds.width * (1 - 0.88) / 2
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
            praySearchBar.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 4),
            praySearchBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: sidePadding),
            praySearchBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -sidePadding),
            
            prayRequestCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: sidePadding),
            prayRequestCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -sidePadding),
            prayRequestCollectionView.topAnchor.constraint(equalTo: praySearchBar.bottomAnchor, constant: 12),
            prayRequestCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    
    private func setupButtonActions() {
        
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // 터치 이벤트를 동시에 처리하도록 허용
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func plusButtonTapped() {
        let addPrayRequestViewController = AddPrayRequestViewController()
        self.navigationController?.pushViewController(addPrayRequestViewController, animated: true)
    }
}
