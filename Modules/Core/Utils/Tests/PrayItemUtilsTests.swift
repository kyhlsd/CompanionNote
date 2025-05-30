//
//  PrayItemUtilsTests.swift
//  CoreTests
//
//  Created by 김영훈 on 5/30/25.
//

import XCTest
@testable import Core

final class PrayItemUtilsTests: XCTestCase {
    
    func testConvertToPrayItem_withNameAndContent() {
        let input = """
        John: Please pray for my exam.
        Sarah: Health and peace in the family.
        """
        
        let expected: [PrayItem] = [
            PrayItem(name: "John", content: "Please pray for my exam."),
            PrayItem(name: "Sarah", content: "Health and peace in the family.")
        ]
        
        let result = PrayItemUtils.convertToPrayItem(with: input)
        XCTAssertEqual(result, expected)
    }
    
    func testConvertToPrayItem_withoutName() {
        let input = "Just a simple prayer without a name"
        let expected: [PrayItem] = [
            PrayItem(name: "", content: "Just a simple prayer without a name")
        ]
        
        let result = PrayItemUtils.convertToPrayItem(with: input)
        XCTAssertEqual(result, expected)
    }
    
    func testConvertToPrayItem_withEmptyLinesAndSpaces() {
        let input = """
        
        John :    Help in finding a job.
        
        Mary:Healing from illness.

        """
        
        let expected: [PrayItem] = [
            PrayItem(name: "John", content: "Help in finding a job."),
            PrayItem(name: "Mary", content: "Healing from illness.")
        ]
        
        let result = PrayItemUtils.convertToPrayItem(with: input)
        XCTAssertEqual(result, expected)
    }
    
    func testConvertToPrayItem_multilineContent() {
        let input = """
        John: Please pray for
        my upcoming mission trip.

        Sarah: Peace and comfort for my family.
        """
        
        let expected: [PrayItem] = [
            PrayItem(name: "John", content: "Please pray for\nmy upcoming mission trip."),
            PrayItem(name: "Sarah", content: "Peace and comfort for my family.")
        ]
        
        let result = PrayItemUtils.convertToPrayItem(with: input)
        XCTAssertEqual(result, expected)
    }

    func testConvertFromPrayItem_withNameAndContent() {
        let input: [PrayItem] = [
            PrayItem(name: "John", content: "Please pray for my exam."),
            PrayItem(name: "Sarah", content: "Health and peace.")
        ]
        
        let expected = """
        John : Please pray for my exam.

        Sarah : Health and peace.
        """
        
        let result = PrayItemUtils.convertFromPrayItem(with: input)
        XCTAssertEqual(result, expected)
    }
    
    func testConvertFromPrayItem_withoutName() {
        let input: [PrayItem] = [
            PrayItem(name: "", content: "This is a general prayer.")
        ]
        
        let expected = "This is a general prayer."
        let result = PrayItemUtils.convertFromPrayItem(with: input)
        XCTAssertEqual(result, expected)
    }
    
    func testRoundTripConversion() {
        let originalText = """
        Alice: For a safe trip.
        Bob: Peace in the world.
        """
        
        let items = PrayItemUtils.convertToPrayItem(with: originalText)
        let resultText = PrayItemUtils.convertFromPrayItem(with: items)
        let itemsRoundTripped = PrayItemUtils.convertToPrayItem(with: resultText)
        
        XCTAssertEqual(items, itemsRoundTripped)
    }
}
