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
    
    let viewModel: PrayRequestViewModelProtocol
    
    let prayRequest: PrayRequest
    
    let editBarButtonItem = UIBarButtonItem()
    let completeBarButtonItem = UIBarButtonItem()
    let prayContainerView = CellContainerView()
    private let categoryLabel = PaddedLabel()
    private let titleLabel = UILabel()
    let prayDetailTableView: UITableView = UITableView(frame: .zero, style: .plain)
    private let dateLabel = UILabel()
    let prayEditorContainerView = CellContainerView()
    let prayEditorView = PrayEditorView()
    
    init(with prayRequest: PrayRequest, viewModel: PrayRequestViewModelProtocol) {
        self.prayRequest = prayRequest
        self.viewModel = viewModel
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
        setupCategoryLabel()
        setupTitleLabel()
        setupDateLabel()
        setupPrayDetailTableView()
        setupPrayEditorContainerView()
        
        view.addSubview(prayContainerView)
        prayContainerView.addSubview(categoryLabel)
        prayContainerView.addSubview(titleLabel)
        prayContainerView.addSubview(dateLabel)
        prayContainerView.addSubview(prayDetailTableView)
        view.addSubview(prayEditorContainerView)
        prayEditorContainerView.addSubview(prayEditorView)
        
        let sidePadding = Constants.sidePadding
        
        prayContainerView.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
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
            
            categoryLabel.leadingAnchor.constraint(equalTo: prayContainerView.leadingAnchor, constant: innerPadding),
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 8),
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
    
    private func setupCategoryLabel() {
        categoryLabel.text = prayRequest.category.rawValue
        categoryLabel.font = Shared.AppFonts.categoryInDetail
        categoryLabel.textColor = .white
        categoryLabel.textInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        categoryLabel.backgroundColor = UIColor(named: prayRequest.category.colorIdentifier, in: .module, compatibleWith: nil)
        categoryLabel.layer.cornerRadius = 6
        categoryLabel.clipsToBounds = true
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
    func editButtonTapped() {
        navigationItem.rightBarButtonItems = [
            completeBarButtonItem
        ]
        prayEditorView.configure(with: prayRequest)
        prayContainerView.isHidden = true
        prayEditorContainerView.isHidden = false
    }
    
    func completeButtonTapped() {
        let editedPrayRequest = prayEditorView.getPrayRequest()
        
        // 변경 사항이 있을 때만 update
        if prayRequest.title != editedPrayRequest.title || prayRequest.items != editedPrayRequest.items || prayRequest.category != editedPrayRequest.category {
            let updatedPrayRequest = PrayRequest(date: prayRequest.date, title: editedPrayRequest.title, items: editedPrayRequest.items, category: editedPrayRequest.category, uuid: prayRequest.uuid)
            Task {
                do {
                    try await viewModel.updatePrayRequest(prayRequest: updatedPrayRequest)
                    prayRequest.updateData(title: editedPrayRequest.title, items: editedPrayRequest.items, category: editedPrayRequest.category)
                    updateUI()
                    self.viewModel.activeFetchStatus()
                } catch {
                    presentErrorAlert(for: error)
                }
            }
        }
        
        navigationItem.rightBarButtonItems = [
            editBarButtonItem
        ]
        prayContainerView.isHidden = false
        prayEditorContainerView.isHidden = true
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.categoryLabel.text = self.prayRequest.category.rawValue
            self.categoryLabel.backgroundColor = UIColor(named: self.prayRequest.category.colorIdentifier, in: .module, compatibleWith: nil)
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
    
    // MARK: Error Alert
    func presentErrorAlert(for error: Error) {
        let message = FirestoreErrorMapper.message(for: error)
        
        let alert = UIAlertController(
            title: nil,
            message: message,
            preferredStyle: .alert
        )
        
        let title = NSAttributedString(
            string: "수정 실패",
            attributes: [
                .foregroundColor: UIColor.red,
                .font: UIFont.boldSystemFont(ofSize: 17)
            ]
        )
        
        alert.setValue(title, forKey: "attributedTitle")
        alert.addAction(UIAlertAction(title: "닫기", style: .default))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

// MARK: Extensions
extension PrayRequestDetailViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayRequest.items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrayDetailCell") as! PrayDetailTableViewCell
        let prayItem = prayRequest.items[indexPath.row]
        cell.configure(with: prayItem)
        return cell
    }
}

extension PrayRequestDetailViewController: RightBarButtonStateDelegate {
    func updateRightBarButtonEnabled() {
        completeBarButtonItem.isEnabled = prayEditorView.isAllTextsValid
    }
}

