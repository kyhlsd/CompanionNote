//
//  PrayDetailTableViewCellTests.swift
//  FeatureTests
//
//  Created by 김영훈 on 5/30/25.
//

import XCTest
@testable import Features
@testable import Core
@testable import Shared

final class PrayDetailTableViewCellTests: XCTestCase {
    
    var cell: PrayDetailTableViewCell!

    override func setUp() {
        super.setUp()
        cell = PrayDetailTableViewCell(style: .default, reuseIdentifier: "PrayDetailCell")
    }

    override func tearDown() {
        cell = nil
        super.tearDown()
    }

    func testConfigure_SetsNameAndContentCorrectly() {
        // Given
        let prayItem = PrayItem(
            name: "지수",
            content: "이번 한 주도 하나님 안에서 평안을 누리며 살 수 있도록"
        )

        // When
        cell.configure(with: prayItem)

        // Then
        XCTAssertEqual(cellNameText(cell), prayItem.name)
        XCTAssertEqual(cell.contentLabel.text, prayItem.content)
    }

    func testNameLabel_HasExpectedFontAndSettings() {
        XCTAssertEqual(cell.nameLabel.font, Shared.AppFonts.body)
        XCTAssertEqual(cell.nameLabel.numberOfLines, 0)
    }

    func testContentLabel_HasExpectedFontAndSettings() {
        XCTAssertEqual(cell.contentLabel.font, Shared.AppFonts.body)
        XCTAssertEqual(cell.contentLabel.numberOfLines, 0)
        XCTAssertEqual(cell.contentLabel.lineBreakMode, .byTruncatingTail)
        XCTAssertEqual(cell.contentLabel.lineBreakStrategy, .pushOut)
    }

    // MARK: - Helpers

    private func cellNameText(_ cell: PrayDetailTableViewCell) -> String? {
        return cell.nameLabel.attributedText?.string
    }
}
