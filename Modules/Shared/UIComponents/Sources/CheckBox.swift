//
//  CheckBox.swift
//  Shared
//
//  Created by 김영훈 on 5/22/25.
//

import UIKit

public class CheckBox: UIButton {
    
    public var isChecked = false {
        didSet {
            updateImage()
        }
    }
    
    private func updateImage() {
        let imageName = isChecked ? "checkmark.square" : "square"
        let image = UIImage(systemName: imageName)
        self.configuration?.image = image
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.addAction(UIAction() { [weak self] _ in
            self?.isChecked.toggle()
        }, for: .touchUpInside)
        
        self.tintColor = .systemBlue
        self.imageView?.contentMode = .scaleAspectFit
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets.zero
        config.imagePlacement = .all
        config.imagePadding = 0
        config.preferredSymbolConfigurationForImage = imageConfig
        self.configuration = config
        
        updateImage()
    }
}
