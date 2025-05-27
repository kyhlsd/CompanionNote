//
//  PaddedLabel.swift
//  Shared
//
//  Created by 김영훈 on 5/27/25.
//

import UIKit

public class PaddedLabel: UILabel {
    public var textInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)

    public override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: textInsets)
        super.drawText(in: insetRect)
    }

    public override var intrinsicContentSize: CGSize {
        let originalSize = super.intrinsicContentSize
        let width = originalSize.width + textInsets.left + textInsets.right
        let height = originalSize.height + textInsets.top + textInsets.bottom
        return CGSize(width: width, height: height)
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        let originalSize = super.sizeThatFits(size)
        let width = originalSize.width + textInsets.left + textInsets.right
        let height = originalSize.height + textInsets.top + textInsets.bottom
        return CGSize(width: width, height: height)
    }
}
