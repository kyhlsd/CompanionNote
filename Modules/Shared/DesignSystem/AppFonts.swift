//
//  AppFonts.swift
//  Core
//
//  Created by 김영훈 on 5/26/25.
//

import UIKit

public enum AppFonts {
    public static let navBarTitle: UIFont? = UIFont(name: "IropkeBatangM", size: 22)
    public static let navBarButtonText: UIFont? = .systemFont(ofSize: 17, weight: .bold)
    public static let title: UIFont? = UIFont(name: "IropkeBatangM", size: 20)
    public static let body: UIFont? = UIFont(name: "IropkeBatangM", size: 16)
    public static let detail: UIFont? = UIFont(name: "IropkeBatangM", size: 14)
    public static let micro: UIFont? = UIFont(name: "IropkeBatangM", size: 12)
}

public enum FontTextAttributes {
    public static let navBarTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeWidth: -2.5
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
