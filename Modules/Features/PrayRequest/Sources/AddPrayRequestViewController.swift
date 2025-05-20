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
    
    private lazy var titleTextField = {
        let textField = UITextField()
        textField.placeholder = "제목을 입력하세요"
        let titleStrokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.systemBlue,
            .foregroundColor: UIColor.systemBlue,
            .strokeWidth: -4.0,
            .font: UIFont(name: "IropkeBatangM", size: 16) ?? .systemFont(ofSize: 16)
        ]
        let titlePlaceHolderStrokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: -4.0,
            .font: UIFont(name: "IropkeBatangM", size: 16) ?? .systemFont(ofSize: 16)
        ]
        textField.defaultTextAttributes = titleStrokeTextAttributes
        textField.attributedPlaceholder = NSAttributedString(
            string: "제목을 입력하세요",
            attributes: titlePlaceHolderStrokeTextAttributes
        )
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var dateLabel = {
        let label = UILabel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        label.text = dateFormatter.string(from: Date())
        label.font = UIFont(name: "IropkeBatangM", size: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
            string: "새로운 기도 제목",
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
        prayContainerView.addSubview(titleTextField)
        prayContainerView.addSubview(dateLabel)
        
        let sidePadding = Constants.sidePadding
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
            prayContainerView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 4),
            prayContainerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -12),
            prayContainerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: sidePadding),
            prayContainerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -sidePadding),
            
            titleTextField.leadingAnchor.constraint(equalTo: prayContainerView.leadingAnchor, constant: 12),
            titleTextField.widthAnchor.constraint(equalToConstant: 200),
            titleTextField.topAnchor.constraint(equalTo: prayContainerView.topAnchor, constant: 12),
            
            dateLabel.bottomAnchor.constraint(equalTo: titleTextField.bottomAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: prayContainerView.trailingAnchor, constant: -12),
        ])
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
