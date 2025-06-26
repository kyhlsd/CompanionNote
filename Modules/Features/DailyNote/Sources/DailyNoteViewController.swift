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
    private let expandBarButton = UIBarButtonItem()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupUI()
        setupButtonActions()
    }
    
    // MARK: Setups
    private func setupNavigationBar() {
        setupExpandBarButton()
        
        let label = UILabel()
        label.attributedText = NSAttributedString(
            string: "신앙 일기",
            attributes: Shared.FontTextAttributes.navBarLeftTitleAttributes
        )
        label.font = Shared.AppFonts.navBarLeftTitle
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
        navigationItem.rightBarButtonItem = expandBarButton
    }
    
    private func setupExpandBarButton() {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.down")?
            .withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
        button.setImage(image, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        let navBarButtonSize = Shared.Constants.navBarButtonSize
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: navBarButtonSize),
            button.heightAnchor.constraint(equalToConstant: navBarButtonSize)
        ])
        expandBarButton.customView = button
    }
    
    private func setupUI() {
        weeklyCalendarView.isWeeklyMode = true
        
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        view.addSubview(weeklyCalendarView)
        
        weeklyCalendarView.translatesAutoresizingMaskIntoConstraints = false
        
        let sidePadding = Constants.sidePadding
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            weeklyCalendarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: sidePadding),
            weeklyCalendarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -sidePadding),
            weeklyCalendarView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Constants.topPadding)
        ])
    }
    
    private func setupButtonActions() {
        // Expand Button
        if let button = expandBarButton.customView as? UIButton {
            button.addAction(UIAction { [weak self] _ in
                guard let self = self else { return }
                expandButtonTapped()
                let imageName = weeklyCalendarView.isWeeklyMode ? "chevron.down" : "chevron.up"
                DispatchQueue.main.async {
                    button.setImage(UIImage(systemName: imageName), for: .normal)
                }
            }, for: .touchUpInside)
        }
    }
    
    // MARK: Button Actions
    private func expandButtonTapped() {
        weeklyCalendarView.isWeeklyMode.toggle()
    }
}
