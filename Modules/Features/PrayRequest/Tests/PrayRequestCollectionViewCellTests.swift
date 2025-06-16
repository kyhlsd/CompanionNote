//
//  PrayRequestCollectionViewCellTests.swift
//  FeatureTests
//
//  Created by 김영훈 on 5/30/25.
//

import XCTest
@testable import Features
@testable import Core


final class PrayRequestCollectionViewCellTests: XCTestCase {

    var cell: PrayRequestCollectionViewCell!

    override func setUp() {
        super.setUp()
        cell = PrayRequestCollectionViewCell(frame: CGRect(x: 0, y: 0, width: 320, height: 200))
    }

    override func tearDown() {
        cell = nil
        super.tearDown()
    }

    func test_UIElementsExist() {
        // 기본 UI가 nil이 아니고 화면에 잘 올라가는지 테스트
        XCTAssertNotNil(cell.contentView)
        XCTAssertNotNil(cell)
    }

    func test_configure_setsLabelsAndItems() {
        // Given
        let items = [
            PrayItem(name: "Name1", content: "Content1"),
            PrayItem(name: "Name2", content: "Content2")
        ]
        let request = PrayRequest(
            date: Date(timeIntervalSince1970: 0),
            title: "Test Title",
            items: items,
            category: .church,
            uuid: UUID()
        )
        
        // When
        cell.configure(with: request)
        
        // Then
        XCTAssertEqual(cell.categoryLabel.text, request.category.rawValue)
        XCTAssertEqual(cell.titleLabel.attributedText?.string, request.title)
        XCTAssertEqual(cell.prayItems.count, items.count)
        XCTAssertEqual(cell.dateLabel.text, DateFormatUtil.shortWithDayFormatter.string(from: request.date))
    }

    func test_enableDeleteMode_showsCheckboxAndAdjustsLayout() {
        // Given
        cell.setDeleteMode(false) // 처음은 기본 상태

        // When
        cell.setDeleteMode(true)

        // Then
        XCTAssertFalse(cell.checkBox.isHidden)
        
        // dateLabelTrailingConstraint가 checkBox.leadingAnchor와 연결되었는지 확인
        guard let constraint = cell.dateLabelTrailingConstraint else {
            XCTFail("dateLabelTrailingConstraint should not be nil")
            return
        }
        
        // constraint의 firstAnchor가 dateLabel.trailingAnchor인지
        XCTAssertTrue(constraint.firstAnchor === cell.dateLabel.trailingAnchor)
        // constraint의 secondAnchor가 checkBox.leadingAnchor인지
        XCTAssertTrue(constraint.secondAnchor === cell.checkBox.leadingAnchor)
        // constraint의 constant가 -4인지 (enableDeleteMode 내부 설정)
        XCTAssertEqual(constraint.constant, -4)
    }

    func test_disableDeleteMode_hidesCheckboxAndResetsLayout() {
        // Given
        cell.setDeleteMode(true)

        // When
        cell.setDeleteMode(false)

        // Then
        XCTAssertTrue(cell.checkBox.isHidden)
        XCTAssertFalse(cell.checkBox.isChecked)
    }

    func test_toggleCheckBoxState_togglesChecked() {
        // 초기 상태
        XCTAssertFalse(cell.checkBox.isChecked)

        cell.setChecked(true)
        XCTAssertTrue(cell.checkBox.isChecked)

        cell.setChecked(false)
        XCTAssertFalse(cell.checkBox.isChecked)
    }

    func test_tableView_hasCorrectNumberOfRows() {
        // Given
        let items = [
            PrayItem(name: "A", content: "1"),
            PrayItem(name: "B", content: "2"),
            PrayItem(name: "C", content: "3")
        ]
        let request = PrayRequest(date: Date(), title: "title", items: items, category: .personal)
        cell.configure(with: request)
        
        // When
        let rows = cell.tableView(cell.prayItemTableView, numberOfRowsInSection: 0)
        
        // Then
        XCTAssertEqual(rows, items.count)
    }

    func test_tableView_cellForRowAt_returnsConfiguredCell() {
        // Given
        let item = PrayItem(name: "TestName", content: "TestContent")
        let request = PrayRequest(date: Date(), title: "title", items: [item], category: .personal)
        cell.configure(with: request)
        
        // When
        let cellForRow = cell.tableView(cell.prayItemTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? PrayItemTableViewCell
        
        // Then
        XCTAssertNotNil(cellForRow)
        XCTAssertEqual(cellForRow?.nameLabel.text, item.name)
        XCTAssertEqual(cellForRow?.contentLabel.text, item.content)
    }
}
