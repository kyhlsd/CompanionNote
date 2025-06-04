//
//  CustomTabBarAppearance.swift
//  Shared
//
//  Created by 김영훈 on 6/4/25.
//

import UIKit

public enum CustomTabBarAppearance {
    public static func makeAppearance() -> UITabBarAppearance {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = UIColor.lightGray
        
        // 선택된 탭 색상
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "SelectedTabColor")
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "SelectedTabColor") ?? UIColor.black]
        
        // 선택되지 않은 탭 색상
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(named: "UnselectedTabColor")
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(named: "UnselectedTabColor") ?? UIColor.systemGray]
        
        appearance.backgroundColor = UIColor(named: "TabBarColor")
        
        return appearance
    }
}
