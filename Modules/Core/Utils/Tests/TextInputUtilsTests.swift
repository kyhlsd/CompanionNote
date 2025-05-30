//
//  TextInputUtilsTests.swift
//  CoreTests
//
//  Created by 김영훈 on 5/30/25.
//

import XCTest
@testable import Core

final class TextInputUtilsTests: XCTestCase {

    func testShouldAllowChange_withinLimit() {
        let result = TextInputUtils.shouldAllowChange(oldText: "안녕", replacementText: "하", maxLength: 10)
        XCTAssertTrue(result)
    }

    func testShouldAllowChange_exceedsLimit_noComposition() {
        let result = TextInputUtils.shouldAllowChange(oldText: "안녕하세요", replacementText: "요", maxLength: 5)
        XCTAssertFalse(result)
    }

    func testShouldAllowChange_exceedsLimit_withInitialConsonantAndVowel() {
        // oldText = "ㄱ", replacement = "ㅏ" → forming "가"
        let result = TextInputUtils.shouldAllowChange(oldText: "ㄱ", replacementText: "ㅏ", maxLength: 1)
        XCTAssertTrue(result)
    }

    func testShouldAllowChange_exceedsLimit_withCompoundVowel() {
        // "ㅗ" + "ㅏ" → "ㅘ"
        let result = TextInputUtils.shouldAllowChange(oldText: "ㅗ", replacementText: "ㅏ", maxLength: 1)
        XCTAssertTrue(result)
    }

    func testShouldAllowChange_exceedsLimit_withFinalConsonant() {
        // "가" (초성+중성) + 받침 "ㄱ"
        let result = TextInputUtils.shouldAllowChange(oldText: "가", replacementText: "ㄱ", maxLength: 1)
        XCTAssertTrue(result)
    }

    func testShouldAllowChange_exceedsLimit_withCompoundFinalConsonant() {
        // "각" (초성+중성+종성 ㄱ) + "ㅅ" → "ㄳ"
        let result = TextInputUtils.shouldAllowChange(oldText: "각", replacementText: "ㅅ", maxLength: 1)
        XCTAssertTrue(result)
    }

    func testShouldAllowChange_exceedsLimit_withInvalidComposition() {
        // "ㅎ" + "ㅎ" (not valid composition)
        let result = TextInputUtils.shouldAllowChange(oldText: "ㅎ", replacementText: "ㅎ", maxLength: 1)
        XCTAssertFalse(result)
    }

    func testShouldAllowChange_whenOldTextEmpty() {
        let result = TextInputUtils.shouldAllowChange(oldText: "", replacementText: "안", maxLength: 0)
        XCTAssertFalse(result)
    }

    func testShouldAllowChange_whenReplacingWithNonKoreanCharacter() {
        let result = TextInputUtils.shouldAllowChange(oldText: "가", replacementText: "a", maxLength: 1)
        XCTAssertFalse(result)
    }
}

