//
//  DateFormatUtil.swift
//  Core
//
//  Created by 김영훈 on 5/25/25.
//

import Foundation

public enum DateFormatUtil {
    public static let shortWithDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yy.MM.dd (E)"
        return formatter
    }()
}
