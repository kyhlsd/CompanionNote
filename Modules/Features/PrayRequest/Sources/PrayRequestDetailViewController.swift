//
//  PrayRequestDetailViewController.swift
//  Features
//
//  Created by 김영훈 on 5/22/25.
//

import UIKit
import Core
import Shared

final class PrayRequestDetailViewController: UIViewController {

    private let prayRequest: PrayRequest
    
    private let editBarButtonItem = UIBarButtonItem()
    private let completeBarButtonItem = UIBarButtonItem()
    private let prayContainerView = CellContainerView()
    private let titleLabel = UILabel()
    private let prayDetailTableView: UITableView = UITableView(frame: .zero, style: .plain)
    private let dateLabel = UILabel()
    private let prayEditorContainerView = CellContainerView()
    private let prayEditorView = PrayEditorView()
    
    init(with prayRequest: PrayRequest) {
        self.prayRequest = prayRequest
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        setupNavigationBar()
        setupUI()
        setupButtonActions()
        setupDelegate()
        setupTapGesture()
        setupNotificationCenter()
    }
    
    // MARK: Setups
    private func setupNavigationBar() {
        setupEditBarButtonItem()
        setupCompleteBarButtonItem()
        
        let titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedString(
            string: "기도 제목",
            attributes: Shared.FontTextAttributes.navBarTextAttributes
        )
        
        titleLabel.font = Shared.AppFonts.navBarTitle
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    private func setupEditBarButtonItem() {
        let button = UIButton()
        button.setTitle("수정", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = Shared.AppFonts.navBarButtonText
        editBarButtonItem.customView = button
    }
    
    private func setupCompleteBarButtonItem() {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .disabled)
        button.titleLabel?.font = Shared.AppFonts.navBarButtonText
        completeBarButtonItem.customView = button
    }

    private func setupUI() {
        setupTitleLabel()
        setupDateLabel()
        setupPrayDetailTableView()
        setupPrayEditorContainerView()
        
        view.addSubview(prayContainerView)
        prayContainerView.addSubview(titleLabel)
        prayContainerView.addSubview(dateLabel)
        prayContainerView.addSubview(prayDetailTableView)
        view.addSubview(prayEditorContainerView)
        prayEditorContainerView.addSubview(prayEditorView)
        
        let sidePadding = Constants.sidePadding
        
        prayContainerView.translatesAutoresizingMaskIntoConstraints = false
        prayDetailTableView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        prayEditorContainerView.translatesAutoresizingMaskIntoConstraints = false
        prayEditorView.translatesAutoresizingMaskIntoConstraints = false

        let topPadding = Constants.topPadding
        let innerPadding = Constants.innerPadding
        let safeArea = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            prayContainerView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: topPadding),
            prayContainerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -innerPadding),
            prayContainerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: sidePadding),
            prayContainerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -sidePadding),

            titleLabel.leadingAnchor.constraint(equalTo: prayContainerView.leadingAnchor, constant: innerPadding),
            titleLabel.trailingAnchor.constraint(equalTo: prayContainerView.trailingAnchor, constant: -innerPadding),
            titleLabel.topAnchor.constraint(equalTo: prayContainerView.topAnchor, constant: innerPadding),

            dateLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: prayContainerView.trailingAnchor, constant: -innerPadding),
            
            prayDetailTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            prayDetailTableView.leadingAnchor.constraint(equalTo: prayContainerView.leadingAnchor, constant: innerPadding),
            prayDetailTableView.trailingAnchor.constraint(equalTo: prayContainerView.trailingAnchor, constant: -innerPadding),
            prayDetailTableView.bottomAnchor.constraint(equalTo: prayContainerView.bottomAnchor, constant: -4),
            
            prayEditorContainerView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: topPadding),
            prayEditorContainerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -innerPadding),
            prayEditorContainerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: sidePadding),
            prayEditorContainerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -sidePadding),
            
            prayEditorView.leadingAnchor.constraint(equalTo: prayEditorContainerView.leadingAnchor, constant: innerPadding),
            prayEditorView.trailingAnchor.constraint(equalTo: prayEditorContainerView.trailingAnchor, constant: -innerPadding),
            prayEditorView.topAnchor.constraint(equalTo: prayEditorContainerView.topAnchor, constant: innerPadding),
            prayEditorView.bottomAnchor.constraint(equalTo: prayEditorContainerView.bottomAnchor, constant: -innerPadding)
        ])
    }
    
    private func setupTitleLabel() {
        titleLabel.font = Shared.AppFonts.title
        titleLabel.attributedText = NSAttributedString(
            string: prayRequest.title,
            attributes: Shared.FontTextAttributes.titleTextAttributes
        )
    }
    
    private func setupPrayDetailTableView() {
        prayDetailTableView.backgroundColor = .clear
        prayDetailTableView.separatorStyle = .none
        prayDetailTableView.register(PrayDetailTableViewCell.self, forCellReuseIdentifier: "PrayDetailCell")
    }
    
    private func setupDateLabel() {
        dateLabel.font = Shared.AppFonts.body
        dateLabel.textColor = .gray
        dateLabel.text = DateFormatUtil.shortWithDayFormatter.string(from: prayRequest.date)
    }
    
    private func setupPrayEditorContainerView() {
        prayEditorContainerView.isHidden = true
    }
    
    private func setupButtonActions() {
        // Edit Button
        if let button = editBarButtonItem.customView as? UIButton {
            button.addAction(UIAction { [weak self] _ in
                self?.editButtonTapped()
            }, for: .touchUpInside)
        }
        
        // Complete Button
        if let button = completeBarButtonItem.customView as? UIButton {
            button.addAction(UIAction { [weak self] _ in
                self?.completeButtonTapped()
            }, for: .touchUpInside)
        }
    }
    
    private func setupDelegate() {
        prayDetailTableView.dataSource = self
        prayDetailTableView.delegate = self
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
    
    //MARK: ButtonActions
    private func editButtonTapped() {
        navigationItem.rightBarButtonItems = [
            completeBarButtonItem
        ]
        prayEditorView.configure(with: prayRequest)
        prayContainerView.isHidden = true
        prayEditorContainerView.isHidden = false
    }
    
    private func completeButtonTapped() {
        let editedPrayRequest = prayEditorView.getEditedPrayRequest()
        
        // 변경 사항이 있을 때만 update
        if prayRequest.title != editedPrayRequest.title || prayRequest.contents != editedPrayRequest.contents {
            prayRequest.updateData(title: editedPrayRequest.title, contents: editedPrayRequest.contents)
            print("수정")
            
            updateUI()
        }
        
        navigationItem.rightBarButtonItems = [
            editBarButtonItem
        ]
        prayContainerView.isHidden = false
        prayEditorContainerView.isHidden = true
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.titleLabel.attributedText = NSAttributedString(
                string: self.prayRequest.title,
                attributes: Shared.FontTextAttributes.titleTextAttributes
            )
            self.prayDetailTableView.reloadData()
        }
    }
    
    // MARK: Gesture Actions
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: Notification Handlers
    @objc private func handleKeyboardWillShow(_ notification: Notification) {
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

    @objc private func handleKeyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

        prayEditorView.updateBottomConstraint(animationDuration: animationDuration)
        prayEditorView.moveView(up: false, animationDuration: animationDuration)
    }
}

// MARK: Extensions
extension PrayRequestDetailViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayRequest.contents.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrayDetailCell") as! PrayDetailTableViewCell
        let prayRequestContent = prayRequest.contents[indexPath.row]
        cell.configure(with: prayRequestContent)
        return cell
    }
}

extension PrayRequestDetailViewController: RightBarButtonStateDelegate {
    func updateRightBarButtonEnabled() {
        completeBarButtonItem.isEnabled = prayEditorView.isAllTextsValid
    }
}

