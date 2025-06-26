//
//  DailyNoteViewController.swift
//  Features
//
//  Created by 김영훈 on 6/26/25.
//

import UIKit
import Shared

public class DailyNoteViewController: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupUI()
    }
    
    // MARK: Setups
    private func setupNavigationBar() {
        let label = UILabel()
        label.attributedText = NSAttributedString(
            string: "신앙 일기",
            attributes: Shared.FontTextAttributes.navBarLeftTitleAttributes
            )
        label.font = Shared.AppFonts.navBarLeftTitle
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
    }
}
