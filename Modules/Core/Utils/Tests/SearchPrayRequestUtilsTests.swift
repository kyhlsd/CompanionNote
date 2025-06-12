//
//  SearchPrayRequestUtilsTests.swift
//  CoreTests
//
//  Created by 김영훈 on 6/12/25.
//

import XCTest
@testable import Core

final class SearchPrayRequestUtilsTests: XCTestCase {
    
    private var sampleRequest: PrayRequest!
    
    override func setUp() {
        super.setUp()
        sampleRequest = PrayRequest(
            date: Date(),
            title: "교회 기도제목",
            items: [
                PrayItem(name: "지수", content: "하나님의 평안이 가득하길 기도합니다."),
                PrayItem(name: "영훈", content: "지혜로운 선택을 하도록"),
                PrayItem(name: "Gido", content: "good"),
            ],
            category: .church
        )
    }
    
    func test_match_title_shouldReturnTrue() {
        XCTAssertTrue(SearchPrayRequestUtils.matches(target: sampleRequest, keyword: "기도"))
    }
    
    func test_match_category_shouldReturnTrue() {
        XCTAssertTrue(SearchPrayRequestUtils.matches(target: sampleRequest, keyword: "교회"))
    }
    
    func test_match_itemName_shouldReturnTrue() {
        XCTAssertTrue(SearchPrayRequestUtils.matches(target: sampleRequest, keyword: "지수"))
    }
    
    func test_match_itemContent_shouldReturnTrue() {
        XCTAssertTrue(SearchPrayRequestUtils.matches(target: sampleRequest, keyword: "평안"))
    }
    
    func test_match_caseInsensitive_shouldReturnTrue() {
        XCTAssertTrue(SearchPrayRequestUtils.matches(target: sampleRequest, keyword: "GIDo")) // 영어로도 대소문자 무시 확인
    }
    
    func test_notMatchingKeyword_shouldReturnFalse() {
        XCTAssertFalse(SearchPrayRequestUtils.matches(target: sampleRequest, keyword: "무관한단어"))
    }
    
}
