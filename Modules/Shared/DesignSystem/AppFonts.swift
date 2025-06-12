//
//  AppFonts.swift
//  Core
//
//  Created by 김영훈 on 5/26/25.
//

import UIKit

public enum AppFonts {
    public static let navBarLeftTitle: UIFont = UIFont(name: "IropkeBatangM", size: 22) ?? .systemFont(ofSize: 22)
    public static let navBarCenterTitle: UIFont = UIFont(name: "IropkeBatangM", size: 18) ?? .systemFont(ofSize: 18)
    public static let navBarButtonText: UIFont = .systemFont(ofSize: 17, weight: .bold)
    public static let title: UIFont = UIFont(name: "IropkeBatangM", size: 20) ?? .systemFont(ofSize: 20)
    public static let body: UIFont = UIFont(name: "IropkeBatangM", size: 16) ?? .systemFont(ofSize: 16)
    public static let detail: UIFont = UIFont(name: "IropkeBatangM", size: 14) ?? .systemFont(ofSize: 14)
    public static let micro: UIFont = UIFont(name: "IropkeBatangM", size: 12) ?? .systemFont(ofSize: 12)
    public static let category: UIFont = .systemFont(ofSize: 14, weight: .bold)
    public static let categoryInDetail: UIFont = .systemFont(ofSize: 16, weight: .bold)
}

public enum FontTextAttributes {
    public static let navBarLeftTitleAttributes: [NSAttributedString.Key: Any] = [
        .strokeWidth: -2.5
    ]
    public static let navBarCenterTitleAttributes: [NSAttributedString.Key: Any] = [
        .strokeWidth: -3.0
    ]
    public static let bodyTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeWidth: -3.0
    ]
    public static let titleTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.systemBlue,
        .foregroundColor: UIColor.systemBlue,
        .strokeWidth: -4.0
    ]
    public static let detailTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeWidth: -2.0
    ]
}
