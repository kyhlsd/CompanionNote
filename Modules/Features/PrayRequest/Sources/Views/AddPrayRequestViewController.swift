//
//  AddPrayRequestViewController.swift
//  Features
//
//  Created by 김영훈 on 4/18/25.
//

import UIKit
import Core
import Shared

final class AddPrayRequestViewController: UIViewController {
    
    private let viewModel: PrayRequestViewModel
    
    let prayContainerView = CellContainerView()
    let prayEditorView = PrayEditorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupUI()
        setupDelegate()
        setupTapGesture()
        setupNotificationCenter()
    }
    
    init(viewModel: PrayRequestViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Setups
    private func setupNavigationBar() {
        let label = UILabel()
        
        label.attributedText = NSAttributedString(
            string: "기도 제목 추가",
            attributes: Shared.FontTextAttributes.navBarTextAttributes
        )
        
        label.font = Shared.AppFonts.navBarTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .disabled)
        button.titleLabel?.font = Shared.AppFonts.navBarButtonText
        button.addAction(UIAction() { [weak self] _ in
            guard let self = self else { return }
            let prayRequest = prayEditorView.getPrayRequest()
            Task {
                await self.viewModel.addPrayRequest(prayRequest: prayRequest)
                self.navigationController?.popViewController(animated: true)
            }
        }, for: .touchUpInside)
        
        navigationItem.titleView = label
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor")

        view.addSubview(prayContainerView)
        prayContainerView.addSubview(prayEditorView)
        
        prayContainerView.translatesAutoresizingMaskIntoConstraints = false
        prayEditorView.translatesAutoresizingMaskIntoConstraints = false
        
        let sidePadding = Constants.sidePadding
        let topPadding = Constants.topPadding
        let innerPadding = Constants.innerPadding
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            prayContainerView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: topPadding),
            prayContainerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -innerPadding),
            prayContainerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: sidePadding),
            prayContainerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -sidePadding),
            
            prayEditorView.leadingAnchor.constraint(equalTo: prayContainerView.leadingAnchor, constant: innerPadding),
            prayEditorView.trailingAnchor.constraint(equalTo: prayContainerView.trailingAnchor, constant: -innerPadding),
            prayEditorView.topAnchor.constraint(equalTo: prayContainerView.topAnchor, constant: innerPadding),
            prayEditorView.bottomAnchor.constraint(equalTo: prayContainerView.bottomAnchor, constant: -innerPadding)
        ])
    }
    
    private func setupDelegate() {
        prayEditorView.rightBarButtonStateDelegate = self
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        let navBarTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        navBarTapGesture.cancelsTouchesInView = false
        navigationController?.navigationBar.addGestureRecognizer(navBarTapGesture)
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Gesture Actions
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: Notification Handlers
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

        let keyboardHeight = keyboardFrame.height
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        let safeOffset = keyboardHeight - tabBarHeight
        
        let textViewHeight = prayEditorView.getTextViewHeight()
        if textViewHeight > 160 {
            prayEditorView.updateBottomConstraint(with: safeOffset, animationDuration: animationDuration)
        } else if prayEditorView.isTextViewFirstResponder {
            prayEditorView.moveView(up: true, animationDuration: animationDuration)
        }
    }

    @objc func handleKeyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

        prayEditorView.updateBottomConstraint(animationDuration: animationDuration)
        prayEditorView.moveView(up: false, animationDuration: animationDuration)
    }
}

// MARK: Extensions
extension AddPrayRequestViewController: RightBarButtonStateDelegate {
    func updateRightBarButtonEnabled() {
        navigationItem.rightBarButtonItem?.isEnabled = prayEditorView.isAllTextsValid
    }
}
