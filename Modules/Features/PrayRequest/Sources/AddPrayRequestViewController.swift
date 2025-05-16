//
//  AddPrayRequestViewController.swift
//  Features
//
//  Created by 김영훈 on 4/18/25.
//

import UIKit

class AddPrayRequestViewController: UIViewController {

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
        
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
