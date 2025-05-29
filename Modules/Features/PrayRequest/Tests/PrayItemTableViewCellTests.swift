//
//  PrayItemTableViewCellTests.swift
//  FeatureTests
//
//  Created by 김영훈 on 5/30/25.
//

import XCTest
@testable import Features
@testable import Core
@testable import Shared

final class PrayItemTableViewCellTests: XCTestCase {

    func test_configure_setsNameAndContentCorrectly() {
        // Given
        let cell = PrayItemTableViewCell(style: .default, reuseIdentifier: nil)
        let name = "테스트 사용자"
        let content = "기도 제목 내용 테스트"
        let item = PrayItem(name: name, content: content)
        
        // When
        cell.configure(with: item)

        // Then
        // NSAttributedString.string 비교로 텍스트 확인
        XCTAssertEqual(cell.nameLabel.attributedText?.string, name)
        XCTAssertEqual(cell.contentLabel.text, content)
    }

    func test_labelsHaveCorrectFont() {
        // Given
        let cell = PrayItemTableViewCell(style: .default, reuseIdentifier: nil)

        // When
        // force layoutSubviews so setupUI is complete
        cell.layoutIfNeeded()

        // Then
        XCTAssertEqual(cell.nameLabel.font, Shared.AppFonts.micro)
        XCTAssertEqual(cell.contentLabel.font, Shared.AppFonts.micro)
    }

    func test_contentLabelNumberOfLinesAndLineBreak() {
        let cell = PrayItemTableViewCell(style: .default, reuseIdentifier: nil)

        XCTAssertEqual(cell.contentLabel.numberOfLines, 2)
        XCTAssertEqual(cell.contentLabel.lineBreakMode, .byTruncatingTail)
        XCTAssertEqual(cell.contentLabel.lineBreakStrategy, .pushOut)
    }

    func test_nameLabelNumberOfLines() {
        let cell = PrayItemTableViewCell(style: .default, reuseIdentifier: nil)
        XCTAssertEqual(cell.nameLabel.numberOfLines, 1)
    }
}
