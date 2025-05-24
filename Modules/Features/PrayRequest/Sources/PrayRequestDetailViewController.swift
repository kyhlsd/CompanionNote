//
//  PrayRequestDetailViewController.swift
//  Features
//
//  Created by 김영훈 on 5/22/25.
//

import UIKit
import Core
import Shared

protocol PushViewControllerDelegate: AnyObject {
    func pushViewController(with viewController: UIViewController)
}

class PrayRequestDetailViewController: UIViewController {

    private let prayRequest: PrayRequest
    
    private lazy var editBarButtonItem: UIBarButtonItem = {
        let button = UIButton()
        button.setTitle("수정", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.addAction(UIAction() { [weak self] _ in
            guard let self = self else { return }
            self.editButtonTapped()
        }, for: .touchUpInside)
        let buttonItem = UIBarButtonItem(customView: button)
        return buttonItem
    }()
    
    private lazy var completeBarButtonItem: UIBarButtonItem = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.addAction(UIAction() { [weak self] _ in
            guard let self = self else { return }
            self.completeButtonTapped()
        }, for: .touchUpInside)
        let buttonItem = UIBarButtonItem(customView: button)
        buttonItem.isEnabled = false
        return buttonItem
    }()
    
    private lazy var prayContainerView = {
        let prayContainerView = CellContainerView()
        prayContainerView.translatesAutoresizingMaskIntoConstraints = false
        return prayContainerView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IropkeBatangM", size: 20)
        let titleStrokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.systemBlue,
            .foregroundColor: UIColor.systemBlue,
            .strokeWidth: -4.0
        ]
        label.attributedText = NSAttributedString(
            string: prayRequest.title,
            attributes: titleStrokeTextAttributes
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var prayDetailTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PrayDetailTableViewCell.self, forCellReuseIdentifier: "PrayDetailCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IropkeBatangM", size: 16)
        label.textColor = .gray
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        label.text = dateFormatter.string(from: prayRequest.date)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var prayEditorContainerView: CellContainerView = {
        let prayContainerView = CellContainerView()
        prayContainerView.translatesAutoresizingMaskIntoConstraints = false
        prayContainerView.isHidden = true
        return prayContainerView
    }()
    
    private lazy var prayEditorView: PrayEditorView = {
        let prayEditorView = PrayEditorView()
        prayEditorView.translatesAutoresizingMaskIntoConstraints = false
        prayEditorView.delegate = self
        return prayEditorView
    }()
    
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
        setupTapGesture()
        setupUI()
        setupNotificationCenter()
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
        
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = editBarButtonItem
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
        prayContainerView.addSubview(titleLabel)
        prayContainerView.addSubview(dateLabel)
        prayContainerView.addSubview(prayDetailTableView)
        view.addSubview(prayEditorContainerView)
        prayEditorContainerView.addSubview(prayEditorView)
        
        let sidePadding = Constants.sidePadding
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            prayContainerView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 4),
            prayContainerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -12),
            prayContainerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: sidePadding),
            prayContainerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -sidePadding),

            titleLabel.leadingAnchor.constraint(equalTo: prayContainerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: prayContainerView.trailingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: prayContainerView.topAnchor, constant: 12),

            dateLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: prayContainerView.trailingAnchor, constant: -12),
            
            prayDetailTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            prayDetailTableView.leadingAnchor.constraint(equalTo: prayContainerView.leadingAnchor, constant: 12),
            prayDetailTableView.trailingAnchor.constraint(equalTo: prayContainerView.trailingAnchor, constant: -12),
            prayDetailTableView.bottomAnchor.constraint(equalTo: prayContainerView.bottomAnchor, constant: -5),
            
            prayEditorContainerView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 4),
            prayEditorContainerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -12),
            prayEditorContainerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: sidePadding),
            prayEditorContainerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -sidePadding),
            
            prayEditorView.leadingAnchor.constraint(equalTo: prayEditorContainerView.leadingAnchor, constant: 12),
            prayEditorView.trailingAnchor.constraint(equalTo: prayEditorContainerView.trailingAnchor, constant: -12),
            prayEditorView.topAnchor.constraint(equalTo: prayEditorContainerView.topAnchor, constant: 12),
            prayEditorView.bottomAnchor.constraint(equalTo: prayEditorContainerView.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func editButtonTapped() {
        navigationItem.rightBarButtonItems = [
            completeBarButtonItem
        ]
        prayEditorView.configure(with: prayRequest)
        prayContainerView.isHidden = true
        prayEditorContainerView.isHidden = false
        
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    
    private func completeButtonTapped() {
        let editedPrayRequest = prayEditorView.getEditedPrayRequest()
        prayRequest.updateData(title: editedPrayRequest.title, contents: editedPrayRequest.contents)
        print("수정")
        
        updateUI()
        
        navigationItem.rightBarButtonItems = [
            editBarButtonItem
        ]
        prayContainerView.isHidden = false
        prayEditorContainerView.isHidden = true
    }
    
    private func updateUI() {
        let titleStrokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.systemBlue,
            .foregroundColor: UIColor.systemBlue,
            .strokeWidth: -4.0
        ]

        DispatchQueue.main.async {
            self.titleLabel.attributedText = NSAttributedString(
                string: self.prayRequest.title,
                attributes: titleStrokeTextAttributes
            )
            self.prayDetailTableView.reloadData()
        }
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
        let editedPrayRequest =  prayEditorView.getEditedPrayRequest()
        // 변경 사항이 없으면 disable 처리
        if prayRequest.title == editedPrayRequest.title, prayRequest.contents == editedPrayRequest.contents {
            completeBarButtonItem.isEnabled = false
        } else { // 변경 사항이 있을 때 text valid 검사
            completeBarButtonItem.isEnabled = prayEditorView.isAllTextsValid
        }
    }
}

