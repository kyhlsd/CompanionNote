//
//  PrayContainer.swift
//  Shared
//
//  Created by 김영훈 on 5/17/25.
//

import UIKit

public class CellContainerView: UIView {
    
    override public init(frame: CGRect = .zero) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "CellColor", in: Bundle.module, compatibleWith: nil)
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
