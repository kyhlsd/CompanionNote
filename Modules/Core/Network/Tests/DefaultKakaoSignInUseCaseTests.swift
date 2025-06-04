//
//  DefaultKakaoSignInUseCaseTests.swift
//  CoreTests
//
//  Created by 김영훈 on 6/4/25.
//

import XCTest
@testable import Core

final class DefaultKakaoSignInUseCaseTests: XCTestCase {
    
    func test_execute_success_returnsUserId() async throws {
        // Given
        let mockService = MockKakaoSignInService()
        mockService.shouldSucceed = true
        mockService.mockUserId = "testUserId"
        let useCase = DefaultKakaoSignInUseCase(signInService: mockService)
        
        // When
        let result = try await useCase.execute()
        
        // Then
        XCTAssertEqual(result, "testUserId")
    }
    
    func test_execute_failure_throwsError() async {
        // Given
        let mockService = MockKakaoSignInService()
        mockService.shouldSucceed = false
        mockService.error = NSError(domain: "Test", code: 999, userInfo: [NSLocalizedDescriptionKey: "Login Failed"])
        let useCase = DefaultKakaoSignInUseCase(signInService: mockService)
        
        // When / Then
        do {
            _ = try await useCase.execute()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual((error as NSError).code, 999)
        }
    }
}


final class MockKakaoSignInService: KakaoSignInServiceProtocol {
    var shouldSucceed = true
    var mockUserId: String = "123456"
    var error: Error = NSError(domain: "KakaoLogin", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock Error"])
    
    func signInAndGetUserId() async throws -> String {
        if shouldSucceed {
            return mockUserId
        } else {
            throw error
        }
    }
}
