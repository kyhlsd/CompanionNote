//
//  DailyNoteViewController.swift
//  Features
//
//  Created by 김영훈 on 6/26/25.
//

import UIKit
import Shared

public class DailyNoteViewController: UIViewController {
    
    private let weeklyCalendarView = WeeklyCalendarView()
    
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
        
        view.addSubview(weeklyCalendarView)
        
        weeklyCalendarView.translatesAutoresizingMaskIntoConstraints = false
        
        let sidePadding = Constants.sidePadding
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            weeklyCalendarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: sidePadding),
            weeklyCalendarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -sidePadding),
            weeklyCalendarView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Constants.topPadding),
            weeklyCalendarView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
