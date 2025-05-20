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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IropkeBatangM", size: 12)
        let subjectStrokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: -2.0
        ]
        label.attributedText = NSAttributedString(
            string: "제목",
            attributes: subjectStrokeTextAttributes
        )
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.font = UIFont(name: "IropkeBatangM", size: 14)
        let placeHolderStrokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.lightGray,
            .foregroundColor: UIColor.lightGray,
        ]
        textField.attributedPlaceholder = NSAttributedString(
            string: "ex) 조 모임",
            attributes: placeHolderStrokeTextAttributes
        )
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var newPrayContentTableView = {
        let newPrayContentTableView = NewPrayContentTableView(prayRequestContents: [
            PrayRequestContent(subject: "", description: ""),
            ])
        newPrayContentTableView.translatesAutoresizingMaskIntoConstraints = false
        return newPrayContentTableView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        let navBarTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        navBarTapGesture.cancelsTouchesInView = false
        navigationController?.navigationBar.addGestureRecognizer(navBarTapGesture)
        
        setupNavigationBar()
        setupUI()
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
        saveButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
    }
    
    private func setupUI() {
        view.addSubview(prayContainerView)
        prayContainerView.addSubview(titleLabel)
        prayContainerView.addSubview(titleTextField)
        prayContainerView.addSubview(newPrayContentTableView)
        
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
            
            titleTextField.leadingAnchor.constraint(equalTo: prayContainerView.leadingAnchor, constant: 12),
            titleTextField.trailingAnchor.constraint(equalTo: prayContainerView.trailingAnchor, constant: -12),
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            newPrayContentTableView.leadingAnchor.constraint(equalTo: prayContainerView.leadingAnchor, constant: 12),
            newPrayContentTableView.trailingAnchor.constraint(equalTo: prayContainerView.trailingAnchor, constant: -12),
            newPrayContentTableView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            newPrayContentTableView.bottomAnchor.constraint(equalTo: prayContainerView.bottomAnchor, constant: -5),
        ])
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
