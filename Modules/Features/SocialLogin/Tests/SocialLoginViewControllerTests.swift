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
        
        let sut = SocialLoginViewController(
            appleSignInUseCase: mockApple,
            kakaoSignInUseCase: MockKakaoSignInUseCase(),  // dummy
            firestoreUseCase: mockFirestore,
            userDefaults: testUserDefaults
        )
        
        let window = UIWindow()
        window.rootViewController = sut
        window.makeKeyAndVisible()
        
        let expectation = XCTestExpectation(description: "Wait for apple login to complete")
        Task {
            // When
            sut.appleLoginButtonTapped()
            try? await Task.sleep(nanoseconds: 500_000_000)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1.0)

        // Then
        let savedId = testUserDefaults.string(forKey: "userId")
        XCTAssertEqual(savedId, "apple_123")
        XCTAssertEqual(mockFirestore.checkedUserId, "apple_123")
    }
    
    @MainActor
    func test_kakaoLogin_success_userDoesNotExist_createsUser() async {
        // Given
        let mockKakao = MockKakaoSignInUseCase()
        mockKakao.userId = "kakao_456"
        let mockFirestore = MockFirestoreUseCase()
        mockFirestore.shouldUserExist = false
        mockFirestore.createUserResult = true
        
        let testUserDefaults = UserDefaults(suiteName: "io.tuist.CompanionNote.tests")!
        testUserDefaults.removePersistentDomain(forName: "io.tuist.CompanionNote.tests")
        
        let sut = SocialLoginViewController(
            appleSignInUseCase: MockAppleSignInUseCase(),
            kakaoSignInUseCase: mockKakao,
            firestoreUseCase: mockFirestore,
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
        XCTAssertEqual(mockFirestore.checkedUserId, "kakao_456")
    }
    
    @MainActor
    func test_appleLogin_whenSignInFails_shouldPresentLoginFailAlert() async {
        // Given
        final class FailingAppleSignInUseCase: AppleSignInUseCase {
            func execute(presentationAnchor: ASPresentationAnchor?) async throws -> String {
                throw NSError(domain: "Test", code: -1, userInfo: nil)
            }
        }

        let testUserDefaults = UserDefaults(suiteName: "io.tuist.CompanionNote.tests")!
        testUserDefaults.removePersistentDomain(forName: "io.tuist.CompanionNote.tests")

        let sut = SpySocialLoginViewController(
            appleSignInUseCase: FailingAppleSignInUseCase(),
            kakaoSignInUseCase: MockKakaoSignInUseCase(),
            firestoreUseCase: MockFirestoreUseCase(),
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
    }

    @MainActor
    func test_appleLogin_whenCreateUserFails_shouldPresentLoginFailAlert() async {
        // Given
        let mockApple = MockAppleSignInUseCase()
        mockApple.userId = "apple_fail_user"

        let mockFirestore = MockFirestoreUseCase()
        mockFirestore.shouldUserExist = false
        mockFirestore.createUserResult = false  // <- 실패 유도

        let testUserDefaults = UserDefaults(suiteName: "io.tuist.CompanionNote.tests")!
        testUserDefaults.removePersistentDomain(forName: "io.tuist.CompanionNote.tests")

        let sut = SpySocialLoginViewController(
            appleSignInUseCase: mockApple,
            kakaoSignInUseCase: MockKakaoSignInUseCase(),
            firestoreUseCase: mockFirestore,
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
    }

    @MainActor
    func test_kakaoLogin_whenSignInFails_shouldPresentLoginFailAlert() async {
        // Given
        final class FailingKakaoSignInUseCase: KakaoSignInUseCase {
            func execute() async throws -> String {
                throw NSError(domain: "Test", code: -1, userInfo: nil)
            }
        }
        
        let testUserDefaults = UserDefaults(suiteName: "io.tuist.CompanionNote.tests")!
            testUserDefaults.removePersistentDomain(forName: "io.tuist.CompanionNote.tests")
        
        let sut = SpySocialLoginViewController(
            appleSignInUseCase: MockAppleSignInUseCase(),
            kakaoSignInUseCase: FailingKakaoSignInUseCase(),
            firestoreUseCase: MockFirestoreUseCase(),
            userDefaults: testUserDefaults
        )
        
        let window = UIWindow()
        window.rootViewController = sut
        window.makeKeyAndVisible()
        
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
    }
    
    @MainActor
    func test_kakaoLogin_whenCreateUserFails_shouldPresentLoginFailAlert() async {
        // Given
        let mockKakao = MockKakaoSignInUseCase()
        mockKakao.userId = "kakao_789"
        let mockFirestore = MockFirestoreUseCase()
        mockFirestore.shouldUserExist = false
        mockFirestore.createUserResult = false

        let testUserDefaults = UserDefaults(suiteName: "io.tuist.CompanionNote.tests")!
        testUserDefaults.removePersistentDomain(forName: "io.tuist.CompanionNote.tests")

        let sut = SpySocialLoginViewController(
            appleSignInUseCase: MockAppleSignInUseCase(),
            kakaoSignInUseCase: mockKakao,
            firestoreUseCase: mockFirestore,
            userDefaults: testUserDefaults
        )

        let window = UIWindow()
        window.rootViewController = sut
        window.makeKeyAndVisible()

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
    }

    
    override func tearDown() {
        UserDefaults(suiteName: "io.tuist.CompanionNote.tests")?.removePersistentDomain(forName: "io.tuist.CompanionNote.tests")
        super.tearDown()
    }
}

final class MockAppleSignInUseCase: AppleSignInUseCase {
    var userId: String = "mock_apple_user_id"
    func execute(presentationAnchor: ASPresentationAnchor?) async throws -> String {
        return userId
    }
}

final class MockKakaoSignInUseCase: KakaoSignInUseCase {
    var userId: String = "mock_kakao_user_id"
    func execute() async throws -> String {
        return userId
    }
}

final class MockFirestoreUseCase: FirestoreUseCase {
    var shouldUserExist = false
    var createUserResult = true
    var checkedUserId: String?
    
    func checkIfUserExists(userId: String) async throws -> Bool {
        checkedUserId = userId
        return shouldUserExist
    }

    func createUserData(userId: String) async -> Bool {
        checkedUserId = userId
        return createUserResult
    }
}

final class SpySocialLoginViewController: SocialLoginViewController {
    var didPresentAlert = false
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if viewControllerToPresent is UIAlertController {
            didPresentAlert = true
        }
    }
}
