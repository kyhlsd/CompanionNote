//
//  SearchPrayRequestUtils.swift
//  Core
//
//  Created by 김영훈 on 6/12/25.
//

import Foundation

public enum SearchPrayRequestUtils {
    public static func matches(target: PrayRequest, keyword: String) -> Bool {
        // title
        if target.title.localizedCaseInsensitiveContains(keyword) {
            return true
        }
        
        // category
        if target.category.rawValue.localizedCaseInsensitiveContains(keyword) {
            return true
        }
        
        // items의 name과 content 검색
        for item in target.items {
            if item.name.localizedCaseInsensitiveContains(keyword) ||
                item.content.localizedCaseInsensitiveContains(keyword) {
                return true
            }
        }
        
        return false
    }
}
