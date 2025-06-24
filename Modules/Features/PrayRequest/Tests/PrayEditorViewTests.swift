//
//  PrayEditorViewTests.swift
//  FeatureTests
//
//  Created by 김영훈 on 5/30/25.
//

import XCTest
@testable import Features
@testable import Core
@testable import Shared

final class PrayEditorViewTests: XCTestCase, RightBarButtonStateDelegate {
    
    var sut: PrayEditorView!
    var didCallUpdateRightBarButtonEnabled = false
    
    override func setUp() {
        super.setUp()
        sut = PrayEditorView(frame: .zero)
        sut.rightBarButtonStateDelegate = self
    }
    
    override func tearDown() {
        sut = nil
        didCallUpdateRightBarButtonEnabled = false
        super.tearDown()
    }
    
    func test_initialState_isAllTextsValidIsFalse() {
        XCTAssertFalse(sut.isAllTextsValid)
    }
    
    func test_settingIsAllTextsValid_callsDelegate() {
        sut.isAllTextsValid = true
        XCTAssertTrue(didCallUpdateRightBarButtonEnabled)
    }
    
    func test_checkTextsValidation_validAndInvalidCases() {
        // 유효하지 않은 경우: title nil
        sut.checkTextsValidation(titleText: nil, itemText: "text")
        XCTAssertFalse(sut.isAllTextsValid)
        
        // 유효하지 않은 경우: title empty
        sut.checkTextsValidation(titleText: "   ", itemText: "text")
        XCTAssertFalse(sut.isAllTextsValid)
        
        // 유효하지 않은 경우: itemText nil
        sut.checkTextsValidation(titleText: "title", itemText: nil)
        XCTAssertFalse(sut.isAllTextsValid)
        
        // 유효하지 않은 경우: itemText empty
        sut.checkTextsValidation(titleText: "title", itemText: "   ")
        XCTAssertFalse(sut.isAllTextsValid)
        
        // 유효하지 않은 경우: itemText가 플레이스홀더일 때
        sut.checkTextsValidation(titleText: "title", itemText: PlaceholderStrings.prayItemInputPlaceholder)
        XCTAssertFalse(sut.isAllTextsValid)
        
        // 유효한 경우
        sut.checkTextsValidation(titleText: "title", itemText: "content")
        XCTAssertTrue(sut.isAllTextsValid)
    }
    
    func test_textViewPlaceholderBehavior() {
        let textView = sut.prayItemTextView
        
        // 플레이스홀더 텍스트 상태에서 편집 시작
        textView.text = PlaceholderStrings.prayItemInputPlaceholder
        textView.textColor = .lightGray
        sut.textViewDidBeginEditing(textView)
        XCTAssertEqual(textView.text, "")
        XCTAssertEqual(textView.textColor, .black)
        
        // 내용 없을 때 편집 종료
        textView.text = "    "
        sut.textViewDidEndEditing(textView)
        XCTAssertEqual(textView.text, PlaceholderStrings.prayItemInputPlaceholder)
        XCTAssertEqual(textView.textColor, .lightGray)
        
        // 내용 있을 때 편집 종료
        sut.textViewDidBeginEditing(textView)
        textView.text = "something"
        sut.textViewDidEndEditing(textView)
        XCTAssertEqual(textView.text, "something")
        XCTAssertEqual(textView.textColor, .black)
    }
    
    func test_textFieldMaxLengthLimit() {
        let textField = sut.titleTextField
        
        // 기존 텍스트 18자
        textField.text = "123456789012345678"
        // 19번째 문자 입력 불가
        XCTAssertFalse(sut.textField(textField, shouldChangeCharactersIn: NSRange(location: 18, length: 0), replacementString: "a"))
        
        // 9자 + 1자 입력 가능
        textField.text = "12345678901234567"
        XCTAssertTrue(sut.textField(textField, shouldChangeCharactersIn: NSRange(location: 17, length: 0), replacementString: "a"))
    }
    
    func test_titleTextFieldDidChange_callsValidationAndDelegate() {
        sut.titleTextField.text = "test"
        sut.prayItemTextView.text = "content"
        sut.titleTextFieldDidChange(sut.titleTextField)
        XCTAssertTrue(sut.isAllTextsValid)
        XCTAssertTrue(didCallUpdateRightBarButtonEnabled)
    }
    
    func test_configure_setsCorrectValues() {
        // PrayItem 배열 생성 (content에 "item1", "item2" 텍스트 포함)
        let items = [
            PrayItem(name: "name1", content: "item1"),
            PrayItem(name: "name2", content: "item2")
        ]
        
        // 존재하는 PrayCategory 중 하나 선택 (예: .church)
        let category: PrayCategory = .church
        
        let prayRequest = PrayRequest(
            date: Date(),
            title: "test title",
            items: items,
            category: category
        )
        
        sut.configure(with: prayRequest)
        
        XCTAssertEqual(sut.titleTextField.text, "test title")
        XCTAssertTrue(sut.prayItemTextView.text.contains("item1"))
        XCTAssertTrue(sut.prayItemTextView.text.contains("item2"))
        XCTAssertEqual(sut.prayItemTextView.textColor, .black)
        
        let selectedIndex = PrayCategory.allCases.firstIndex(of: category)
        XCTAssertEqual(sut.categorySelectorView.selectedIndex, selectedIndex)
    }
    
    // MARK: - RightBarButtonStateDelegate
    
    func updateRightBarButtonEnabled() {
        didCallUpdateRightBarButtonEnabled = true
    }
}
