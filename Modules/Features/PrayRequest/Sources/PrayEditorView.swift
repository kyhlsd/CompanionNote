//
//  PrayEditorView.swift
//  Shared
//
//  Created by 김영훈 on 5/23/25.
//

import UIKit
import Core
import Shared

// 입력 상태에 따라 NavigationBar RightButton 상태 Update
protocol RightBarButtonStateDelegate: AnyObject {
    func updateRightBarButtonEnabled()
}

final class PrayEditorView: UIView {
    
    private let titleLabel = UILabel()
    private let titleTextField = PaddedTextField()
    private let prayContentLabel = UILabel()
    private let prayContentTextView = UITextView()
    
    private var prayContentTextViewBottomConstraint: NSLayoutConstraint!
    weak var delegate: RightBarButtonStateDelegate?
    
    var isAllTextsValid: Bool = false {
        didSet {
            delegate?.updateRightBarButtonEnabled()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupDelegate()
        setupTarget()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Setups
    private func setupUI() {
        setupTitleLabel()
        setupTitleTextField()
        setupPrayContentLabel()
        setupPrayContentTextView()
        
        addSubview(titleLabel)
        addSubview(titleTextField)
        addSubview(prayContentLabel)
        addSubview(prayContentTextView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        prayContentLabel.translatesAutoresizingMaskIntoConstraints = false
        prayContentTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            
            titleTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            prayContentLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            prayContentLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            prayContentLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            
            prayContentTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            prayContentTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            prayContentTextView.topAnchor.constraint(equalTo: prayContentLabel.bottomAnchor, constant: 4),
        ])
        
        prayContentTextViewBottomConstraint = prayContentTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        prayContentTextViewBottomConstraint.isActive = true
    }
    
    private func setupTitleLabel() {
        titleLabel.font = UIFont(name: "IropkeBatangM", size: 14)
        let subjectStrokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: -2.0
        ]
        titleLabel.attributedText = NSAttributedString(
            string: "제목",
            attributes: subjectStrokeTextAttributes
        )
        titleLabel.numberOfLines = 1
    }
    
    private func setupTitleTextField() {
        titleTextField.font = UIFont(name: "IropkeBatangM", size: 16)
        let placeHolderStrokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.lightGray,
            .foregroundColor: UIColor.lightGray,
        ]
        titleTextField.attributedPlaceholder = NSAttributedString(
            string: PlaceholderStrings.prayTitleInputPlaceholder,
            attributes: placeHolderStrokeTextAttributes
        )
        titleTextField.layer.borderColor = UIColor.lightGray.cgColor
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.cornerRadius = 8
    }
    
    private func setupPrayContentLabel() {
        prayContentLabel.font = UIFont(name: "IropkeBatangM", size: 14)
        let subjectStrokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: -2.0
        ]
        prayContentLabel.attributedText = NSAttributedString(
            string: "내용",
            attributes: subjectStrokeTextAttributes
        )
        prayContentLabel.numberOfLines = 1
    }
    
    private func setupPrayContentTextView() {
        prayContentTextView.text = PlaceholderStrings.prayContentInputPlaceholder
        prayContentTextView.textColor = .lightGray
        prayContentTextView.font = UIFont(name: "IropkeBatangM", size: 16)
        prayContentTextView.textContainerInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        prayContentTextView.textContainer.lineFragmentPadding = 0
        prayContentTextView.layer.borderColor = UIColor.lightGray.cgColor
        prayContentTextView.layer.borderWidth = 1
        prayContentTextView.layer.cornerRadius = 8
    }
    
    private func setupDelegate() {
        titleTextField.delegate = self
        prayContentTextView.delegate = self
    }
    
    private func setupTarget() {
        titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func checkTextsValidation(titleText: String?, contentText: String?) {
        guard let titleText = titleText, let contentText = contentText else {
            isAllTextsValid = false
            return
        }
        
        if titleText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            isAllTextsValid = false
            return
        }
        
        if contentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || contentText == PlaceholderStrings.prayContentInputPlaceholder {
            isAllTextsValid = false
            return
        }
        
        isAllTextsValid = true
        return
    }
    
    func configure(with prayRequest: PrayRequest) {
        titleTextField.text = prayRequest.title
        prayContentTextView.text = PrayRequestContentUtils.convertFromPrayRequestContents(with: prayRequest.contents)
        prayContentTextView.textColor = .black
    }
    
    func updateBottomConstraint(with constant: CGFloat = 0.0, animationDuration: TimeInterval) {
        prayContentTextViewBottomConstraint.constant = -12 - constant

        UIView.animate(withDuration: animationDuration) {
            self.layoutIfNeeded()
        }
    }
    
    func getPrayContentText() -> String {
        return prayContentTextView.text
    }
    
    func getEditedPrayRequest() -> PrayRequest {
        return PrayRequest(date: Date(), title: titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "", contents: PrayRequestContentUtils.convertToPrayRequestContent(with: prayContentTextView.text))
    }
}

// MARK: Extensions
extension PrayEditorView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == PlaceholderStrings.prayContentInputPlaceholder {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = PlaceholderStrings.prayContentInputPlaceholder
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkTextsValidation(titleText: titleTextField.text, contentText: textView.text)
    }
}

extension PrayEditorView: UITextFieldDelegate {
    
    // 입력 가능 텍스트 최대 20자 설정
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 변경 후 텍스트를 미리 계산
        if let currentText = textField.text,
           let textRange = Range(range, in: currentText) {
            
            let updatedText = currentText.replacingCharacters(in: textRange, with: string)
            
            return updatedText.count <= 20
        }
        
        return true
    }
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        checkTextsValidation(titleText: textField.text, contentText: prayContentTextView.text)
        delegate?.updateRightBarButtonEnabled()
    }
}
