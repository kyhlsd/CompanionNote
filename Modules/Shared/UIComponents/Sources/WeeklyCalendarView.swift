//
//  WeeklyCalendarView.swift
//  Shared
//
//  Created by 김영훈 on 6/26/25.
//

import UIKit
import FSCalendar

public final class WeeklyCalendarView: UIView {
    private let calendar = FSCalendar()
    public var isWeeklyMode = true {
        didSet {
            setMode(isWeeklyMode)
        }
    }
    
    private var heightConstraint: NSLayoutConstraint?
    private let weeklyModeHeight: CGFloat = 79.33333333333333
    
    public init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setups
    private func setupUI() {
        setupCalendarView()
        
        addSubview(calendar)
        
        calendar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendar.leadingAnchor.constraint(equalTo: leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: trailingAnchor),
            calendar.topAnchor.constraint(equalTo: topAnchor),
            calendar.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        heightConstraint = calendar.heightAnchor.constraint(equalToConstant: 300)
        heightConstraint?.isActive = true
    }
    
    private func setupCalendarView() {
        calendar.appearance.weekdayTextColor = .gray
        calendar.appearance.titleDefaultColor = UIColor(named: "BasicTextColor", in: .module, compatibleWith: nil)
        calendar.appearance.titleWeekendColor = nil
        calendar.appearance.todayColor = nil
        calendar.appearance.titleTodayColor = UIColor(named: "BasicTextColor", in: .module, compatibleWith: nil)
        
        calendar.delegate = self
        
        calendar.select(Date())
    }
    
    private func setMode(_ isWeeklyMode: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if isWeeklyMode {
                calendar.setScope(.week, animated: false)
            } else {
                calendar.setScope(.month, animated: false)
            }
        }
    }
}

// MARK: Extensions
extension WeeklyCalendarView: FSCalendarDelegate {
    public func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        heightConstraint?.constant = isWeeklyMode ? weeklyModeHeight : 300
        calendar.headerHeight = self.isWeeklyMode ? 0 : -1
        self.layoutIfNeeded()
    }
    
    // 미래 날짜는 선택 못함
    public func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return date <= Date()
    }
    
    public func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendar.reloadData()
    }
}

extension WeeklyCalendarView: FSCalendarDelegateAppearance {
    // 선택 안되는 날짜, 주말 색상 변경
    public func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        // 미래 날짜
        if date > Date() {
            return UIColor(named: "DisabledColor", in: .module, compatibleWith: nil)
        }
        
        // 현재 달력의 지난달 날짜Add commentMore actions
        if !Calendar.current.isDate(date, equalTo: calendar.currentPage, toGranularity: .month) {
            return UIColor(named: "DisabledColor", in: .module, compatibleWith: nil)
        }
        
        // 주말
        let weekday = Calendar.current.component(.weekday, from: date)
        if weekday == 7 { // 토요일 (1=일요일, 7=토요일)
            return .systemBlue
        } else if weekday == 1 { // 일요일
            return .systemRed
        }
        
        return nil // 기본 색 사용Add commentMore actions
    }
}
