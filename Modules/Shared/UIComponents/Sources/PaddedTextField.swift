//
//  PaddedTextField.swift
//  Shared
//
//  Created by 김영훈 on 5/21/25.
//

import UIKit

public class PaddedTextField: UITextField {
    public var textPadding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }

    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
}

