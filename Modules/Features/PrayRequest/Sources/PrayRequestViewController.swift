//
//  PrayRequestViewController.swift
//  Features
//
//  Created by 김영훈 on 3/20/25.
//

import UIKit
import Shared

public class PrayRequestViewController: UIViewController {
    
    private lazy var plusButton = {
        let button = UIButton()
        let image = UIImage(systemName: "plus")?
            .withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
        button.setImage(image, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 28),
            button.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        button.addAction(UIAction { [weak self] _ in
            self?.plusButtonTapped()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton = {
        let button = UIButton()
        let image = UIImage(systemName: "trash")?
            .withConfiguration(UIImage.SymbolConfiguration(weight: .regular))
        button.setImage(image, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 28),
            button.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        button.addAction(UIAction { [weak self] _ in
            self?.deleteButtonTapped()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var completeDeleteButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.addAction(UIAction() { [weak self] _ in
            self?.completeDeleteButtonTapped()
        }, for: .touchUpInside)
        return button
    }()
    
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
        
        setupNavigationBar()
        setupTapGesture()
        setupUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarTapGesture()
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

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: deleteButton),
            UIBarButtonItem(customView: plusButton)
        ]
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    
    private func setupUI() {
        view.addSubview(praySearchBar)
        view.addSubview(prayRequestCollectionView)
        
        let sidePadding = Constants.sidePadding
        
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
    
    private func setupNavBarTapGesture() {
        // 중복 추가 방지를 위해 먼저 제거
        if let recognizers = navigationController?.navigationBar.gestureRecognizers {
            recognizers
                .filter { $0.name == "NavBarKeyboardDismiss" }
                .forEach { navigationController?.navigationBar.removeGestureRecognizer($0) }
        }
        
        let navBarTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        navBarTapGesture.name = "NavBarKeyboardDismiss"
        navBarTapGesture.cancelsTouchesInView = false
        navigationController?.navigationBar.addGestureRecognizer(navBarTapGesture)
    }
    
    private func plusButtonTapped() {
        let addPrayRequestViewController = AddPrayRequestViewController()
        self.navigationController?.pushViewController(addPrayRequestViewController, animated: true)
    }
    
    private func deleteButtonTapped() {
        prayRequestCollectionView.enableDeleteMode()
        prayRequestCollectionView.isDeleteMode = true
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: completeDeleteButton)
        ]
    }
    
    private func completeDeleteButtonTapped() {
        prayRequestCollectionView.deletePrayRequests()
        prayRequestCollectionView.isDeleteMode = false
        prayRequestCollectionView.reloadData()
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: deleteButton),
            UIBarButtonItem(customView: plusButton)
        ]
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension PrayRequestViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // 터치된 뷰가 UISearchBar 또는 내부 구성 요소라면 동작하지 않도록
        if let touchedView = touch.view, touchedView.isDescendant(of: praySearchBar) {
            return false
        }
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // 터치 이벤트를 동시에 처리하도록 허용
    }
}
