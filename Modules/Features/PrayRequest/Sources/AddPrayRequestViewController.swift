//
//  AddPrayRequestViewController.swift
//  Features
//
//  Created by 김영훈 on 4/18/25.
//

import UIKit
import Shared

class AddPrayRequestViewController: UIViewController {
    
    private lazy var prayContainerView = {
        let prayContainerView = PrayContainerView()
        prayContainerView.translatesAutoresizingMaskIntoConstraints = false
        return prayContainerView
    }()
    
    private lazy var prayEditorView = {
        let prayEditorView = PrayEditorView()
        prayEditorView.translatesAutoresizingMaskIntoConstraints = false
        prayEditorView.delegate = self
        return prayEditorView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        setupNavigationBar()
        setupTapGesture()
        setupUI()
        setupNotificationCenter()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: -2.5
        ]
        titleLabel.attributedText = NSAttributedString(
            string: "기도 제목 추가",
            attributes: strokeTextAttributes
        )
        
        titleLabel.font = UIFont(name: "IropkeBatangM", size: 22)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let saveButton = UIButton()
        saveButton.setTitle("저장", for: .normal)
        saveButton.setTitleColor(UIColor.systemBlue, for: .normal)
        saveButton.setTitleColor(UIColor.lightGray, for: .disabled)
        saveButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        saveButton.addAction(UIAction() { [weak self] _ in
            guard let self = self else { return }
            self.prayEditorView.convertToPrayRequestContent(with: self.prayEditorView.getPrayContentText())
        }, for: .touchUpInside)
        
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        let navBarTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        navBarTapGesture.cancelsTouchesInView = false
        navigationController?.navigationBar.addGestureRecognizer(navBarTapGesture)
    }
    
    private func setupUI() {
        view.addSubview(prayContainerView)
        prayContainerView.addSubview(prayEditorView)
        
        let sidePadding = Constants.sidePadding
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            prayContainerView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 4),
            prayContainerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -12),
            prayContainerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: sidePadding),
            prayContainerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -sidePadding),
            
            prayEditorView.leadingAnchor.constraint(equalTo: prayContainerView.leadingAnchor, constant: 12),
            prayEditorView.trailingAnchor.constraint(equalTo: prayContainerView.trailingAnchor, constant: -12),
            prayEditorView.topAnchor.constraint(equalTo: prayContainerView.topAnchor, constant: 12),
            prayEditorView.bottomAnchor.constraint(equalTo: prayContainerView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func handleKeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

        let keyboardHeight = keyboardFrame.height
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        let safeOffset = keyboardHeight - tabBarHeight
        
        prayEditorView.updateBottomConstraint(with: safeOffset, animationDuration: animationDuration)
    }

    @objc private func handleKeyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

        prayEditorView.updateBottomConstraint(animationDuration: animationDuration)
    }
}

extension AddPrayRequestViewController: RightBarButtonStateDelegate {
    func updateRightBarButtonEnabled() {
        navigationItem.rightBarButtonItem?.isEnabled = prayEditorView.isAllTextsValid
    }
}
