//
//  CategorySelectorView.swift
//  Shared
//
//  Created by 김영훈 on 5/27/25.
//

import UIKit

public protocol SelectCategoryDelegate: AnyObject {
    func didSelectCategory(_ index: Int)
}

public class CategorySelectorView: UIView {
    private let categories: [String]
    private var buttons: [UIButton] = []
    private let isUnderlineVisible: Bool
    private let underlineView = UIView()
    
    private var underlineLeadingConstraint: NSLayoutConstraint?
    private var underlineWidthConstraint: NSLayoutConstraint?
    
    public weak var selectCategoryDelegate: SelectCategoryDelegate?
    
    public var selectedIndex: Int = 0 {
        didSet { updateSelection(animated: true) }
    }
    
    public init(categories: [String], isUnderlineVisible: Bool) {
        self.categories = categories
        self.isUnderlineVisible = isUnderlineVisible
        super.init(frame: .zero)
        setupUI()
        updateSelection(animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateSelection(animated: false)
    }
    
    // MARK: Setups
    private func setupUI() {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        for (index, title) in categories.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.gray, for: .normal)
            button.titleLabel?.font = Shared.AppFonts.category
            button.alpha = 0.5
            button.tag = index
            button.addAction(UIAction { [weak self] _ in
                self?.categoryTapped(button)
            }, for: .touchUpInside)
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
        
        underlineView.backgroundColor = .systemBlue
        addSubview(underlineView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            
            underlineView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            underlineView.heightAnchor.constraint(equalToConstant: 2),
        ])
        
        let firstButton = buttons[0]
        underlineLeadingConstraint = underlineView.leadingAnchor.constraint(equalTo: firstButton.leadingAnchor)
        underlineLeadingConstraint?.isActive = true
        underlineWidthConstraint = underlineView.widthAnchor.constraint(equalTo: firstButton.widthAnchor)
        underlineWidthConstraint?.isActive = true
        
        underlineView.isHidden = !isUnderlineVisible
    }
    
    private func updateSelection(animated: Bool) {
        for (index, button) in buttons.enumerated() {
            let isSelected = (index == selectedIndex)
            button.setTitleColor(isSelected ? .systemBlue : .gray, for: .normal)
            button.alpha = isSelected ? 1.0 : 0.5
        }
        
        let selectedButton = buttons[selectedIndex]
        underlineLeadingConstraint?.isActive = false
        underlineWidthConstraint?.isActive = false
        underlineLeadingConstraint = underlineView.leadingAnchor.constraint(equalTo: selectedButton.leadingAnchor)
        underlineWidthConstraint = underlineView.widthAnchor.constraint(equalTo: selectedButton.widthAnchor)
        underlineLeadingConstraint?.isActive = true
        underlineWidthConstraint?.isActive = true
        
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.layoutIfNeeded()
            }
        } else {
            self.layoutIfNeeded()
        }
    }
    
    //MARK: Button Actions
    private func categoryTapped(_ sender: UIButton) {
        let index = sender.tag
        guard selectedIndex != index else { return }
        selectedIndex = index
        selectCategoryDelegate?.didSelectCategory(index)
    }
}
