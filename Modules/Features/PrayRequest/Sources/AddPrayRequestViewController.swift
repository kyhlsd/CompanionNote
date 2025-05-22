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
        label.font = UIFont(name: "IropkeBatangM", size: 14)
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
        textField.font = UIFont(name: "IropkeBatangM", size: 16)
        let placeHolderStrokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.lightGray,
            .foregroundColor: UIColor.lightGray,
        ]
        textField.attributedPlaceholder = NSAttributedString(
            string: PlaceholderStrings.prayTitleInputPlaceholder,
            attributes: placeHolderStrokeTextAttributes
        )
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let prayContentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IropkeBatangM", size: 14)
        let subjectStrokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: -2.0
        ]
        label.attributedText = NSAttributedString(
            string: "내용",
            attributes: subjectStrokeTextAttributes
        )
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let prayContentTextView: UITextView = {
        let textView = UITextView()
        textView.text = PlaceholderStrings.prayContentInputPlaceholder
        textView.textColor = .lightGray
        textView.font = UIFont(name: "IropkeBatangM", size: 16)
        textView.textContainerInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        textView.textContainer.lineFragmentPadding = 0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 8
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private var prayContentTextViewBottomConstraint: NSLayoutConstraint!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        setupNavigationBar()
        setupTapGesture()
        setupUI()
        setupNotificationCenter()
        
        titleTextField.delegate = self
        prayContentTextView.delegate = self
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
            self.convertToPrayRequestContent(with: self.prayContentTextView.text)
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
        prayContainerView.addSubview(titleLabel)
        prayContainerView.addSubview(titleTextField)
        prayContainerView.addSubview(prayContentLabel)
        prayContainerView.addSubview(prayContentTextView)
        
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
            
            prayContentLabel.leadingAnchor.constraint(equalTo: prayContainerView.leadingAnchor, constant: 12),
            prayContentLabel.trailingAnchor.constraint(equalTo: prayContainerView.trailingAnchor, constant: -12),
            prayContentLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            
            prayContentTextView.leadingAnchor.constraint(equalTo: prayContainerView.leadingAnchor, constant: 12),
            prayContentTextView.trailingAnchor.constraint(equalTo: prayContainerView.trailingAnchor, constant: -12),
            prayContentTextView.topAnchor.constraint(equalTo: prayContentLabel.bottomAnchor, constant: 4),
        ])
        
        prayContentTextViewBottomConstraint = prayContentTextView.bottomAnchor.constraint(equalTo: prayContainerView.bottomAnchor, constant: -12)
        prayContentTextViewBottomConstraint.isActive = true
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func checkSaveButtonEnabled(titleText: String?, contentText: String?) -> Bool {
        guard let titleText = titleText, let contentText = contentText else { return false }
        
        if titleText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return false
        }
        
        if contentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || contentText == PlaceholderStrings.prayContentInputPlaceholder {
            return false
        }
        
        return true
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
        
        prayContentTextViewBottomConstraint.constant = -12 - safeOffset

        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func handleKeyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }

        prayContentTextViewBottomConstraint.constant = -12

        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }

    private func convertToPrayRequestContent(with text: String) {
        var results = [PrayRequestContent]()
        
        // 입력 끝에 개행 추가 (마지막 항목까지 매치되도록)
        let normalizedText = text.hasSuffix("\n") ? text : text + "\n"
        
        // ":"가 없을 때는 전체 Text를 하나의 Description으로 처리
        if !text.contains(":") {
            let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            let prayRequestContent = PrayRequestContent(subject: "", description: trimmedText)
            results.append(prayRequestContent)
            print(results)
            return
        }
        
        // ":" 기준으로 둘로 나눔
        let pattern = #"(?ms)^([^:\n]+)\s*:\s*(.*?)(?=^[^:\n]+\s*:\s*|\z)"#
        
        if let regex = try? NSRegularExpression(pattern: pattern) {
            let nsText = normalizedText as NSString
            let matches = regex.matches(in: normalizedText, range: NSRange(normalizedText.startIndex..., in: normalizedText))
            
            for match in matches {
                let rawSubject = nsText.substring(with: match.range(at: 1))
                let rawDescription = nsText.substring(with: match.range(at: 2))
                
                let subject = rawSubject.trimmingCharacters(in: .whitespacesAndNewlines)
                let description = rawDescription.trimmingCharacters(in: .whitespacesAndNewlines)
                
                let prayRequestContent = PrayRequestContent(subject: subject, description: description)
                results.append(prayRequestContent)
            }
        }
        print(results)
    }

}

extension AddPrayRequestViewController: UITextViewDelegate {
    
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
        navigationItem.rightBarButtonItem?.isEnabled = checkSaveButtonEnabled(titleText: titleTextField.text, contentText: textView.text)
    }
}

extension AddPrayRequestViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 변경 후 텍스트를 미리 계산
        if let currentText = textField.text,
           let textRange = Range(range, in: currentText) {
            
            let updatedText = currentText.replacingCharacters(in: textRange, with: string)
            
            navigationItem.rightBarButtonItem?.isEnabled = checkSaveButtonEnabled(titleText: updatedText, contentText: prayContentTextView.text)
        }
        
        return true // 텍스트 변경을 허용
    }
}
