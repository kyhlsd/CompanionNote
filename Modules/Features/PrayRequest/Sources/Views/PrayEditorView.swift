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
    private let categoryLabel = UILabel()
    let categorySelectorView = CategorySelectorView(categories: PrayCategory.allCases.map { $0.rawValue }, isUnderlineVisible: false)
    private let titleLabel = UILabel()
    let titleTextField = PaddedTextField()
    private let prayItemLabel = UILabel()
    let prayItemTextView = UITextView()
    
    private var prayItemTextViewBottomConstraint: NSLayoutConstraint!
    weak var rightBarButtonStateDelegate: RightBarButtonStateDelegate?
    
    var isAllTextsValid: Bool = false {
        didSet {
            rightBarButtonStateDelegate?.updateRightBarButtonEnabled()
        }
    }
    
    var isTextViewFirstResponder: Bool {
        return prayItemTextView.isFirstResponder
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
        setupCategoryLabel()
        setupTitleLabel()
        setupTitleTextField()
        setupPrayItemLabel()
        setupPrayItemTextView()
        
        addSubview(categoryLabel)
        addSubview(categorySelectorView)
        addSubview(titleLabel)
        addSubview(titleTextField)
        addSubview(prayItemLabel)
        addSubview(prayItemTextView)
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categorySelectorView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        prayItemLabel.translatesAutoresizingMaskIntoConstraints = false
        prayItemTextView.translatesAutoresizingMaskIntoConstraints = false
        
        let innerPadding = Constants.innerPadding
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            categoryLabel.topAnchor.constraint(equalTo: topAnchor),
            
            categorySelectorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            categorySelectorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            categorySelectorView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
            categorySelectorView.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: categorySelectorView.bottomAnchor),
            
            titleTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            prayItemLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            prayItemLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            prayItemLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            
            prayItemTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            prayItemTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            prayItemTextView.topAnchor.constraint(equalTo: prayItemLabel.bottomAnchor, constant: 4),
        ])
        
        prayItemTextViewBottomConstraint = prayItemTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -innerPadding)
        prayItemTextViewBottomConstraint.isActive = true
    }
    
    private func setupCategoryLabel() {
        categoryLabel.font = Shared.AppFonts.detail
        categoryLabel.attributedText = NSAttributedString(
            string: "카테고리",
            attributes: Shared.FontTextAttributes.detailTextAttributes
        )
        categoryLabel.numberOfLines = 1
    }
    
    private func setupTitleLabel() {
        titleLabel.font = Shared.AppFonts.detail
        titleLabel.attributedText = NSAttributedString(
            string: "제목",
            attributes: Shared.FontTextAttributes.detailTextAttributes
        )
        titleLabel.numberOfLines = 1
    }
    
    private func setupTitleTextField() {
        titleTextField.font = Shared.AppFonts.body
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
    
    private func setupPrayItemLabel() {
        prayItemLabel.font = Shared.AppFonts.detail
        prayItemLabel.attributedText = NSAttributedString(
            string: "내용",
            attributes: Shared.FontTextAttributes.detailTextAttributes
        )
        prayItemLabel.numberOfLines = 1
    }
    
    private func setupPrayItemTextView() {
        prayItemTextView.text = PlaceholderStrings.prayItemInputPlaceholder
        prayItemTextView.textColor = .lightGray
        prayItemTextView.font = Shared.AppFonts.body
        prayItemTextView.textContainerInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        prayItemTextView.textContainer.lineFragmentPadding = 0
        prayItemTextView.layer.borderColor = UIColor.lightGray.cgColor
        prayItemTextView.layer.borderWidth = 1
        prayItemTextView.layer.cornerRadius = 8
    }
    
    private func setupDelegate() {
        titleTextField.delegate = self
        prayItemTextView.delegate = self
    }
    
    private func setupTarget() {
        titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    func checkTextsValidation(titleText: String?, itemText: String?) {
        guard let titleText = titleText, let itemText = itemText else {
            isAllTextsValid = false
            return
        }
        
        if titleText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            isAllTextsValid = false
            return
        }
        
        if itemText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || itemText == PlaceholderStrings.prayItemInputPlaceholder {
            isAllTextsValid = false
            return
        }
        
        isAllTextsValid = true
        return
    }
    
    func configure(with prayRequest: PrayRequest) {
        titleTextField.text = prayRequest.title
        prayItemTextView.text = PrayItemUtils.convertFromPrayItem(with: prayRequest.items)
        prayItemTextView.textColor = .black
        if let index = PrayCategory.allCases.firstIndex(of: prayRequest.category) {
            categorySelectorView.selectedIndex = index
        }
    }
    
    func updateBottomConstraint(with constant: CGFloat = 0.0, animationDuration: TimeInterval) {
        let innerPadding = Constants.innerPadding
        prayItemTextViewBottomConstraint.constant = -innerPadding - constant
        
        UIView.animate(withDuration: animationDuration) {
            self.layoutIfNeeded()
        }
    }
    
    func moveView(up: Bool, animationDuration: TimeInterval) {
        //        PrayItemLabel이 가장 위에 오도록 움직여야 하는 값
        let offset = categoryLabel.frame.height + 4 + categorySelectorView.frame.height +  titleLabel.frame.height + 4 + titleTextField.frame.height + 16
        UIView.animate(withDuration: animationDuration) {
            self.transform = up ? CGAffineTransform(translationX: 0, y: -offset) : .identity
        }
    }
    
    func getTextViewHeight() -> CGFloat {
        return prayItemTextView.frame.height
    }
    
    func getPrayItemText() -> String {
        return prayItemTextView.text
    }
    
    func getPrayRequest() -> PrayRequest {
        return PrayRequest(date: Date(), title: titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "", items: PrayItemUtils.convertToPrayItem(with: prayItemTextView.text), category: PrayCategory.allCases[ categorySelectorView.selectedIndex])
    }
}

// MARK: Extensions
extension PrayEditorView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == PlaceholderStrings.prayItemInputPlaceholder {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = PlaceholderStrings.prayItemInputPlaceholder
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkTextsValidation(titleText: titleTextField.text, itemText: textView.text)
    }
}

extension PrayEditorView: UITextFieldDelegate {
    
    // 입력 가능 텍스트 최대 10자 설정
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text ?? ""
        return TextInputUtils.shouldAllowChange(oldText: oldText, replacementText: string, maxLength: 10)
    }
    
    @objc func titleTextFieldDidChange(_ textField: UITextField) {
        checkTextsValidation(titleText: textField.text, itemText: prayItemTextView.text)
        rightBarButtonStateDelegate?.updateRightBarButtonEnabled()
    }
}
