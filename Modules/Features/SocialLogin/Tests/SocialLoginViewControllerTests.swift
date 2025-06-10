//
//  SocialLoginViewControllerTests.swift
//  FeatureTests
//
//  Created by 김영훈 on 6/4/25.
//

import XCTest
import AuthenticationServices
@testable import Core
@testable import Features

final class SocialLoginViewControllerTests: XCTestCase {
    @MainActor
    func test_appleLogin_success_userExists() async {
        // Given
        let mockApple = MockAppleSignInUseCase()
        mockApple.userId = "apple_123"
        let mockFirestore = MockFirestoreUseCase()
        mockFirestore.shouldUserExist = true
        
        let testUserDefaults = UserDefaults(suiteName: "io.tuist.CompanionNote.tests")!
        testUserDefaults.removePersistentDomain(forName: "io.tuist.CompanionNote.tests")
        
        let sut = SpySocialLoginViewController(
            appleSignInUseCase: mockApple,
            kakaoSignInUseCase: MockKakaoSignInUseCase(),  // dummy
            userUseCase: mockFirestore,
            userDefaults: testUserDefaults
        )
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = sut
        window.makeKeyAndVisible()
        
        // When
        let expectation = XCTestExpectation(description: "Wait for kakao createUserData fail")
        Task {
            sut.appleLoginButtonTapped()
            try? await Task.sleep(nanoseconds: 500_000_000)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1.0)
        
        // Then
        let savedId = testUserDefaults.string(forKey: "userId")
        XCTAssertEqual(savedId, "apple_123")
        XCTAssertTrue(sut.didPresentTabbar)
    }
    
    @MainActor
    func test_kakaoLogin_success_userDoesNotExist_createsUser() async {
        // Given
        let mockKakao = MockKakaoSignInUseCase()
        mockKakao.userId = "kakao_456"
        let mockFirestore = MockFirestoreUseCase()
        mockFirestore.shouldUserExist = false
        
        let testUserDefaults = UserDefaults(suiteName: "io.tuist.CompanionNote.tests")!
        testUserDefaults.removePersistentDomain(forName: "io.tuist.CompanionNote.tests")
        
        let sut = SpySocialLoginViewController(
            appleSignInUseCase: MockAppleSignInUseCase(),
            kakaoSignInUseCase: mockKakao,
            userUseCase: mockFirestore,
            userDefaults: testUserDefaults
        )
        
        let expectation = XCTestExpectation(description: "Wait for kakao login to complete")
        Task {
            // When
            sut.kakaoLoginButtonTapped()
            try? await Task.sleep(nanoseconds: 500_000_000)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1.0)
        
        // Then
        let savedId = testUserDefaults.string(forKey: "userId")
        XCTAssertEqual(savedId, "kakao_456")
        XCTAssertTrue(sut.didPresentTabbar)
    }
    
    @MainActor
    func test_appleLogin_whenSignInFails_shouldPresentLoginFailAlert() async {
        // Given
        let mockApple = MockAppleSignInUseCase()
        mockApple.userId = "apple_123"
        mockApple.shouldSucceed = false
        let mockFirestore = MockFirestoreUseCase()
        mockFirestore.shouldUserExist = true
        
        
        let testUserDefaults = UserDefaults(suiteName: "io.tuist.CompanionNote.tests")!
        testUserDefaults.removePersistentDomain(forName: "io.tuist.CompanionNote.tests")
        
        let sut = SpySocialLoginViewController(
            appleSignInUseCase: mockApple,
            kakaoSignInUseCase: MockKakaoSignInUseCase(),
            userUseCase: MockFirestoreUseCase(),
            userDefaults: testUserDefaults
        )
        
        let window = UIWindow()
        window.rootViewController = sut
        window.makeKeyAndVisible()
        
        // When
        let expectation = XCTestExpectation(description: "Apple login should fail and alert presented")
        Task {
            sut.appleLoginButtonTapped()
            try? await Task.sleep(nanoseconds: 500_000_000)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertTrue(sut.didPresentAlert)
        XCTAssertFalse(sut.didPresentTabbar)
    }
    
    @MainActor
    func test_appleLogin_whenCreateUserFails_shouldPresentLoginFailAlert() async {
        // Given
        let mockApple = MockAppleSignInUseCase()
        mockApple.userId = "apple_fail_user"
        
        let mockFirestore = MockFirestoreUseCase()
        mockFirestore.shouldUserExist = false
        mockFirestore.shouldSucceed = false
        
        let testUserDefaults = UserDefaults(suiteName: "io.tuist.CompanionNote.tests")!
        testUserDefaults.removePersistentDomain(forName: "io.tuist.CompanionNote.tests")
        
        let sut = SpySocialLoginViewController(
            appleSignInUseCase: mockApple,
            kakaoSignInUseCase: MockKakaoSignInUseCase(),
            userUseCase: mockFirestore,
            userDefaults: testUserDefaults
        )
        
        let window = UIWindow()
        window.rootViewController = sut
        window.makeKeyAndVisible()
        
        // When
        let expectation = XCTestExpectation(description: "Apple createUserData should fail and alert presented")
        Task {
            sut.appleLoginButtonTapped()
            try? await Task.sleep(nanoseconds: 500_000_000)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertTrue(sut.didPresentAlert)
        XCTAssertFalse(sut.didPresentTabbar)
    }
    
    @MainActor
    func test_kakaoLogin_whenSignInFails_shouldPresentLoginFailAlert() async {
        // Given
        let mockKakao = MockKakaoSignInUseCase()
        mockKakao.shouldSucceed = false
        mockKakao.userId = "kakao_456"
        
        let testUserDefaults = UserDefaults(suiteName: "io.tuist.CompanionNote.tests")!
        testUserDefaults.removePersistentDomain(forName: "io.tuist.CompanionNote.tests")
        
        let sut = SpySocialLoginViewController(
            appleSignInUseCase: MockAppleSignInUseCase(),
            kakaoSignInUseCase: mockKakao,
            userUseCase: MockFirestoreUseCase(),
            userDefaults: testUserDefaults
        )
        
        // When
        let expectation = XCTestExpectation(description: "Wait for kakao login fail")
        Task {
            sut.kakaoLoginButtonTapped()
            try? await Task.sleep(nanoseconds: 500_000_000)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertTrue(sut.didPresentAlert)
        XCTAssertFalse(sut.didPresentTabbar)
    }
    
        @MainActor
        func test_kakaoLogin_whenCreateUserFails_shouldPresentLoginFailAlert() async {
            // Given
            let mockKakao = MockKakaoSignInUseCase()
            mockKakao.userId = "kakao_789"
            let mockFirestore = MockFirestoreUseCase()
            mockFirestore.shouldSucceed = false
    
            let testUserDefaults = UserDefaults(suiteName: "io.tuist.CompanionNote.tests")!
            testUserDefaults.removePersistentDomain(forName: "io.tuist.CompanionNote.tests")
    
            let sut = SpySocialLoginViewController(
                appleSignInUseCase: MockAppleSignInUseCase(),
                kakaoSignInUseCase: mockKakao,
                userUseCase: mockFirestore,
                userDefaults: testUserDefaults
            )
    
            // When
            let expectation = XCTestExpectation(description: "Wait for kakao createUserData fail")
            Task {
                sut.kakaoLoginButtonTapped()
                try? await Task.sleep(nanoseconds: 500_000_000)
                expectation.fulfill()
            }
            await fulfillment(of: [expectation], timeout: 1.0)
    
            // Then
            XCTAssertTrue(sut.didPresentAlert)
            XCTAssertFalse(sut.didPresentTabbar)
        }
    
    override func tearDown() {
        UserDefaults(suiteName: "io.tuist.CompanionNote.tests")?.removePersistentDomain(forName: "io.tuist.CompanionNote.tests")
        super.tearDown()
    }
    
    final class MockAppleSignInUseCase: AppleSignInUseCase {
        var shouldSucceed = true
        var userId: String = "mock_apple_user_id"
        func execute(presentationAnchor: ASPresentationAnchor?) async throws -> String {
            if shouldSucceed {
                return userId
            } else {
                throw NSError(domain: "TestError", code: 999, userInfo: nil)
            }
        }
    }
    
    final class MockKakaoSignInUseCase: KakaoSignInUseCase {
        var shouldSucceed = true
        var userId: String = "mock_kakao_user_id"
        func execute() async throws -> String {
            if shouldSucceed {
                return userId
            } else {
                throw NSError(domain: "TestError", code: 999, userInfo: nil)
            }
        }
    }
    
    final class MockFirestoreUseCase: UserUseCase {
        var shouldUserExist = false
        var shouldSucceed = true
        
        func userExists(userId: String) async throws -> Bool {
            if shouldSucceed {
                return shouldUserExist
            } else {
                throw NSError(domain: "TestError", code: 999, userInfo: nil)
            }
        }
        
        func createUser(userId: String) async throws {
            if !shouldSucceed {
                throw NSError(domain: "TestError", code: 999, userInfo: nil)
            }
        }
    }
    
    final class SpySocialLoginViewController: SocialLoginViewController {
        var didPresentAlert = false
        var didPresentTabbar = false
        
        override func presentLoginFailAlert() {
            didPresentAlert = true
        }
        
        override func presentTabBarController() {
            didPresentTabbar = true
        }
    }
}

