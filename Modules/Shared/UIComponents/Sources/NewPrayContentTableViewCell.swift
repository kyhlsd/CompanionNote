//
//  NewPrayContentTableViewCell.swift
//  Shared
//
//  Created by 김영훈 on 5/20/25.
//

import UIKit

class NewPrayContentTableViewCell: UITableViewCell {
    
    private let subjectLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IropkeBatangM", size: 12)
        let subjectStrokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: -2.0
        ]
        label.attributedText = NSAttributedString(
            string: "항목 이름",
            attributes: subjectStrokeTextAttributes
        )
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subjectTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.font = UIFont(name: "IropkeBatangM", size: 14)
        let placeHolderStrokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.lightGray,
            .foregroundColor: UIColor.lightGray,
        ]
        textField.attributedPlaceholder = NSAttributedString(
            string: "ex) 영훈",
            attributes: placeHolderStrokeTextAttributes
        )
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IropkeBatangM", size: 12)
        let subjectStrokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: -2.0
        ]
        label.attributedText = NSAttributedString(
            string: "세부 내용",
            attributes: subjectStrokeTextAttributes
        )
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "ex) 매일 묵상하고 기도하기"
        textView.textColor = .lightGray
        textView.font = UIFont(name: "IropkeBatangM", size: 14)
        textView.textContainerInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        textView.textContainer.lineFragmentPadding = 0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        textView.isScrollEnabled = false
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    weak var delegate: TextViewHeightChangeDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        descriptionTextView.delegate = self
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        
        selectionStyle = .none
        
        contentView.addSubview(subjectLabel)
        contentView.addSubview(subjectTextField)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(descriptionTextView)
        
        NSLayoutConstraint.activate([
            subjectLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            subjectLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subjectLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            subjectTextField.topAnchor.constraint(equalTo: subjectLabel.bottomAnchor, constant: 4),
            subjectTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subjectTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: subjectTextField.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            descriptionTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 53)
        ])
    }
    
    func configure(index: Int) {
        let subjectStrokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: -2.0
        ]
        subjectLabel.attributedText = NSAttributedString(
            string: "항목 \(index)",
            attributes: subjectStrokeTextAttributes
        )
    }
}

extension NewPrayContentTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.onTextViewHeightChange()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "ex) 매일 묵상하고 기도하기" {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "ex) 매일 묵상하고 기도하기"
            textView.textColor = .lightGray
        }
    }
}
