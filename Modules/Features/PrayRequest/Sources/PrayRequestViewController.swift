//
//  PrayRequestViewController.swift
//  Features
//
//  Created by 김영훈 on 3/20/25.
//

import UIKit
import Shared

final public class PrayRequestViewController: UIViewController {
    
    private let plusBarButtonItem = UIBarButtonItem()
    private let deleteBarButtonItem = UIBarButtonItem()
    private let completeBarButtonItem = UIBarButtonItem()
    private let praySearchBar = CustomSearchBar()
    private let prayRequestCollectionView = PrayRequestCollectionView(prayRequests: PrayRequest.dummyDatas)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupUI()
        setupButtonActions()
        setupDelegate()
        setupTapGesture()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarTapGesture()
        //TODO: firestore snapshot을 쓴다면 안해도 될지도. 테스트
        prayRequestCollectionView.reloadData()
    }
    
    // MARK: Setups
    private func setupNavigationBar() {
        setupPlusBarButtonItem()
        setupDeleteBarButtonItem()
        setupCompleteBarButtonItem()
        
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
            deleteBarButtonItem,
            plusBarButtonItem
        ]
    }
    
    private func setupPlusBarButtonItem() {
        let button = UIButton()
        let image = UIImage(systemName: "plus")?
            .withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
        button.setImage(image, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 28),
            button.heightAnchor.constraint(equalToConstant: 28)
        ])
        plusBarButtonItem.customView = button
    }
    
    private func setupDeleteBarButtonItem() {
        let button = UIButton()
        let image = UIImage(systemName: "trash")?
            .withConfiguration(UIImage.SymbolConfiguration(weight: .regular))
        button.setImage(image, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 28),
            button.heightAnchor.constraint(equalToConstant: 28)
        ])
        deleteBarButtonItem.customView = button
    }
    
    private func setupCompleteBarButtonItem() {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        completeBarButtonItem.customView = button
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        view.addSubview(praySearchBar)
        view.addSubview(prayRequestCollectionView)
        
        let sidePadding = Constants.sidePadding
        let safeArea = view.safeAreaLayoutGuide
        
        praySearchBar.translatesAutoresizingMaskIntoConstraints = false
        prayRequestCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
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
        // Plus Button
        if let button = plusBarButtonItem.customView as? UIButton {
            button.addAction(UIAction { [weak self] _ in
                self?.plusButtonTapped()
            }, for: .touchUpInside)
        }
        
        // DeleteButton
        if let button = deleteBarButtonItem.customView as? UIButton {
            button.addAction(UIAction { [weak self] _ in
                self?.deleteButtonTapped()
            }, for: .touchUpInside)
        }
        
        // CompleteButton
        if let button = completeBarButtonItem.customView as? UIButton {
            button.addAction(UIAction { [weak self] _ in
                self?.completeButtonTapped()
            }, for: .touchUpInside)
        }
    }
    
    private func setupDelegate() {
        prayRequestCollectionView.pushViewControllerDelegate = self
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
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
    
    // MARK: Button Actions
    private func plusButtonTapped() {
        let addPrayRequestViewController = AddPrayRequestViewController()
        self.navigationController?.pushViewController(addPrayRequestViewController, animated: true)
    }
    
    private func deleteButtonTapped() {
        prayRequestCollectionView.enableDeleteMode()
        prayRequestCollectionView.isDeleteMode = true
        navigationItem.rightBarButtonItems = [
            completeBarButtonItem
        ]
    }
    
    private func completeButtonTapped() {
        prayRequestCollectionView.deletePrayRequests()
        prayRequestCollectionView.isDeleteMode = false
        prayRequestCollectionView.reloadData()
        navigationItem.rightBarButtonItems = [
            deleteBarButtonItem,
            plusBarButtonItem
        ]
    }
    
    // MARK: Gesture Actions
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: Extensions
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

extension PrayRequestViewController: PushViewControllerDelegate {
    func pushViewController(with viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
