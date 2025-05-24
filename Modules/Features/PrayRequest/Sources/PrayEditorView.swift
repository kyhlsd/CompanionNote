//
//  PrayEditorViewController.swift
//  Shared
//
//  Created by 김영훈 on 5/23/25.
//

import UIKit
import Shared

public class PrayEditorView: UIView {
    
    private let titleLabel: UILabel = {
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
    
    private let titleTextField: PaddedTextField = {
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
    public weak var delegate: RightBarButtonStateDelegate?
    
    public var isAllTextsValid: Bool = false {
        didSet {
            delegate?.updateRightBarButtonEnabled()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
        titleTextField.delegate = self
        prayContentTextView.delegate = self
        
        titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        addSubview(titleLabel)
        addSubview(titleTextField)
        addSubview(prayContentLabel)
        addSubview(prayContentTextView)
        
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
    
    public func checkTextsValidation(titleText: String?, contentText: String?) {
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
    
    // TODO: Util로 빼기
    public func convertToPrayRequestContent(with text: String) -> [PrayRequestContent] {
        var results = [PrayRequestContent]()
        
        // 입력 끝에 개행 추가 (마지막 항목까지 매치되도록)
        let normalizedText = text.hasSuffix("\n") ? text : text + "\n"
        
        // ":"가 없을 때는 전체 Text를 하나의 Description으로 처리
        if !text.contains(":") {
            let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            let prayRequestContent = PrayRequestContent(subject: "", description: trimmedText)
            results.append(prayRequestContent)
            print(results)
            return results
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
        return results
    }
    
    public func convertFromPrayRequestContents(with contents: [PrayRequestContent]) -> String {
        let lines = contents.map { content in
            if content.subject.isEmpty {
                return content.description
            } else {
                return "\(content.subject) : \(content.description)"
            }
        }
        
        return lines.joined(separator: "\n\n")
    }
    
    public func getPrayContentText() -> String {
        return prayContentTextView.text
    }
    
    public func updateBottomConstraint(with constant: CGFloat = 0.0, animationDuration: TimeInterval) {
        prayContentTextViewBottomConstraint.constant = -12 - constant

        UIView.animate(withDuration: animationDuration) {
            self.layoutIfNeeded()
        }
    }
    
    public func configure(with prayRequest: PrayRequest) {
        titleTextField.text = prayRequest.title
        prayContentTextView.text = convertFromPrayRequestContents(with: prayRequest.contents)
        prayContentTextView.textColor = .black
    }
    
    public func getEditedPrayRequest() -> PrayRequest {
        return PrayRequest(date: Date(), title: titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "", contents: convertToPrayRequestContent(with: prayContentTextView.text))
    }
}

extension PrayEditorView: UITextViewDelegate {
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == PlaceholderStrings.prayContentInputPlaceholder {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = PlaceholderStrings.prayContentInputPlaceholder
            textView.textColor = .lightGray
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        checkTextsValidation(titleText: titleTextField.text, contentText: textView.text)
    }
}

extension PrayEditorView: UITextFieldDelegate {
    
    // TODO: 글자수 제한
//    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        // 변경 후 텍스트를 미리 계산
//        if let currentText = textField.text,
//           let textRange = Range(range, in: currentText) {
//            
//            let updatedText = currentText.replacingCharacters(in: textRange, with: string)
//            
//            checkTextsValidation(titleText: updatedText, contentText: prayContentTextView.text)
//        }
//        
//        return true // 텍스트 변경을 허용
//    }
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        checkTextsValidation(titleText: textField.text, contentText: prayContentTextView.text)
        delegate?.updateRightBarButtonEnabled()
    }
}

public protocol RightBarButtonStateDelegate: AnyObject {
    func updateRightBarButtonEnabled()
}
