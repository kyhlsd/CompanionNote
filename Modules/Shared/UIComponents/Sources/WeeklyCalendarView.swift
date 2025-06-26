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
    }
    
    private func setupCalendarView() {
        calendar.scope = .week
        calendar.headerHeight = 0
        calendar.appearance.weekdayTextColor = .gray
        calendar.appearance.titleDefaultColor = UIColor(named: "BasicTextColor", in: .module, compatibleWith: nil)
        calendar.appearance.titleWeekendColor = nil
        calendar.appearance.todayColor = nil
        calendar.appearance.titleTodayColor = UIColor(named: "BasicTextColor", in: .module, compatibleWith: nil)
        
        calendar.delegate = self
        
        calendar.select(Date())
    }
}

// MARK: Extensions
extension WeeklyCalendarView: FSCalendarDelegate {
    // 미래 날짜는 선택 못함
    public func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return date <= Date()
    }
}

extension WeeklyCalendarView: FSCalendarDelegateAppearance {
    // 선택 안되는 날짜, 주말 색상 변경
    public func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        if date > Date() {
            return UIColor(named: "DisabledColor", in: .module, compatibleWith: nil)
        }
        
        let weekday = Calendar.current.component(.weekday, from: date)
        if weekday == 7 { // 토요일 (1=일요일, 7=토요일)
            return .systemBlue
        } else if weekday == 1 { // 일요일
            return .systemRed
        }
        return nil // 기본 색 사용Add commentMore actions
    }
}
