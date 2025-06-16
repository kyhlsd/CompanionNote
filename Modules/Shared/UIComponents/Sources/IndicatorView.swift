//
//  IndicatorView.swift
//  Shared
//
//  Created by 김영훈 on 6/15/25.
//

import UIKit

public class IndicatorView: UIActivityIndicatorView {
    
    override public init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        style = .large
        hidesWhenStopped = true
        color = .gray
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
