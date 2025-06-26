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
        let mockFirestore = MockFirestoreUseCase()
        mockApple.userId = "apple_123"
        mockFirestore.shouldUserExist = true
        
        let sut = SpySocialLoginViewController(
            appleSignInUseCase: mockApple,
            kakaoSignInUseCase: MockKakaoSignInUseCase(),  // dummy
            userUseCase: mockFirestore
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
        XCTAssertTrue(sut.didPresentTabbar)
    }
    
    @MainActor
    func test_kakaoLogin_success_userDoesNotExist_createsUser() async {
        // Given
        let mockKakao = MockKakaoSignInUseCase()
        mockKakao.userId = "kakao_456"
        let mockFirestore = MockFirestoreUseCase()
        mockFirestore.shouldUserExist = false
        
        let sut = SpySocialLoginViewController(
            appleSignInUseCase: MockAppleSignInUseCase(),
            kakaoSignInUseCase: mockKakao,
            userUseCase: mockFirestore
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
        
        let sut = SpySocialLoginViewController(
            appleSignInUseCase: mockApple,
            kakaoSignInUseCase: MockKakaoSignInUseCase(),
            userUseCase: MockFirestoreUseCase()
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
        
        let sut = SpySocialLoginViewController(
            appleSignInUseCase: mockApple,
            kakaoSignInUseCase: MockKakaoSignInUseCase(),
            userUseCase: mockFirestore
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
        
        let sut = SpySocialLoginViewController(
            appleSignInUseCase: MockAppleSignInUseCase(),
            kakaoSignInUseCase: mockKakao,
            userUseCase: MockFirestoreUseCase()
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
        
        let sut = SpySocialLoginViewController(
            appleSignInUseCase: MockAppleSignInUseCase(),
            kakaoSignInUseCase: mockKakao,
            userUseCase: mockFirestore
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
    
    final class MockAppleSignInUseCase: AppleSignInUseCase {
        var shouldSucceed = true
        var userId: String = "mock_apple_user_id"
        func execute(presentationAnchor: ASPresentationAnchor?) async throws {
            if shouldSucceed {
                
            } else {
                throw NSError(domain: "TestError", code: 999, userInfo: nil)
            }
        }
    }
    
    final class MockKakaoSignInUseCase: KakaoSignInUseCase {
        var shouldSucceed = true
        var userId: String = "mock_kakao_user_id"
        func execute() async throws {
            if shouldSucceed {
                
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
        let mockApple: MockAppleSignInUseCase
        let mockFirestore: MockFirestoreUseCase
        let mockKakao: MockKakaoSignInUseCase
        
        init(
            appleSignInUseCase: MockAppleSignInUseCase,
            kakaoSignInUseCase: MockKakaoSignInUseCase,
            userUseCase: MockFirestoreUseCase
        ) {
            self.mockApple = appleSignInUseCase
            self.mockKakao = kakaoSignInUseCase
            self.mockFirestore = userUseCase
            super.init(
                appleSignInUseCase: mockApple,
                kakaoSignInUseCase: mockKakao,
                userUseCase: mockFirestore
            )
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var didPresentAlert = false
        var didPresentTabbar = false
        
        override func presentLoginFailAlert() {
            didPresentAlert = true
        }
        
        override func presentTabBarController() {
            didPresentTabbar = true
        }
        
        override func appleLoginButtonTapped() {
            Task { [weak self] in
                guard let self = self else { return }
                
                do {
                    guard let anchor = self.view.window else { return }
                    try await mockApple.execute(presentationAnchor: anchor)
                    
                    let userIdentifier = mockApple.userId
                    
                    // 서버 User Collection에 추가
                    let userExists = try await mockFirestore.userExists(userId: userIdentifier)
                    if !userExists {
                        try await mockFirestore.createUser(userId: userIdentifier)
                    }
                    
                    presentTabBarController()
                } catch {
                    presentLoginFailAlert()
                }
            }
        }
        
        override func kakaoLoginButtonTapped() {
            Task { [weak self] in
                guard let self = self else { return }
                
                do {
                    try await mockKakao.execute()
                    
                    let userIdentifier = mockKakao.userId

                    // 서버 User Collection에 추가
                    let userExists = try await mockFirestore.userExists(userId: userIdentifier)
                    if !userExists {
                        try await mockFirestore.createUser(userId: userIdentifier)
                    }
                    
                    presentTabBarController()
                } catch {
                    presentLoginFailAlert()
                }
            }
        }
    }
}

