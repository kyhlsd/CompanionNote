//
//  DefaultAppleSignInUseCaseTests.swift
//  CoreTests
//
//  Created by 김영훈 on 6/4/25.
//

import XCTest
import AuthenticationServices
@testable import Core

final class DefaultAppleSignInUseCaseTests: XCTestCase {
    
    func test_execute_success_returnsUserId() async throws {
        // Given
        let mockService = MockAppleSignInService()
        mockService.shouldSucceed = true
        mockService.mockUserId = "test-user-id"
        let useCase = DefaultAppleSignInUseCase(signInService: mockService)
        
        // When
        let userId = try await useCase.execute(presentationAnchor: nil)
        
        // Then
        XCTAssertEqual(userId, "test-user-id")
    }
    
    func test_execute_failure_throwsError() async {
        // Given
        let mockService = MockAppleSignInService()
        mockService.shouldSucceed = false
        mockService.error = NSError(domain: "AppleLogin", code: 1234, userInfo: nil)
        let useCase = DefaultAppleSignInUseCase(signInService: mockService)
        
        // When & Then
        do {
            _ = try await useCase.execute(presentationAnchor: nil)
            XCTFail("Expected to throw but succeeded")
        } catch {
            XCTAssertEqual((error as NSError).code, 1234)
        }
    }
}

final class MockAppleSignInService: AppleSignInServiceProtocol {
    var shouldSucceed = true
    var mockUserId = "mocked-user-id"
    var error: Error = NSError(domain: "Test", code: 999, userInfo: nil)

    func signInAndGetUserId(presentationAnchor: ASPresentationAnchor?) async throws -> String {
        if shouldSucceed {
            return mockUserId
        } else {
            throw error
        }
    }
}

