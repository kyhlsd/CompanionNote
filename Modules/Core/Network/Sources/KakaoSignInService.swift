//
//  KakaoLogInService.swift
//  Core
//
//  Created by 김영훈 on 6/3/25.
//

import Foundation
import KakaoSDKUser
import KakaoSDKAuth

public final class KakaoSignInService {
    
    public init() {}
    
    public func signInAndGetUserId() async throws -> String {
        if UserApi.isKakaoTalkLoginAvailable() {
            let _ = try await loginWithKakaoTalk()
        } else {
            let _ = try await loginWithKakaoAccount()
        }
        
        guard AuthApi.hasToken() else {
            throw NSError(domain: "KakaoLogin", code: 0, userInfo: [NSLocalizedDescriptionKey: "카카오 로그인 토큰이 존재하지 않음"])
        }
        
        let user = try await fetchKakaoUser()
        guard let userIdentifier = user.id else {
            throw NSError(domain: "KakaoLogin", code: 1, userInfo: [NSLocalizedDescriptionKey: "User ID가 존재하지 않음"])
        }
        
        return String(userIdentifier)
    }
    
    // 카카오톡 로그인
    private func loginWithKakaoTalk() async throws -> OAuthToken {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                UserApi.shared.loginWithKakaoTalk { token, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let token = token {
                        continuation.resume(returning: token)
                    } else {
                        continuation.resume(throwing: NSError(domain: "LoginError", code: -1))
                    }
                }
            }
        }
    }
    
    // 웹으로 카카오 로그인
    private func loginWithKakaoAccount() async throws -> OAuthToken {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                UserApi.shared.loginWithKakaoAccount { token, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let token = token {
                        continuation.resume(returning: token)
                    } else {
                        continuation.resume(throwing: NSError(domain: "LoginError", code: -1))
                    }
                }
            }
        }
    }
    
    // 사용자 정보 가져오기
    private func fetchKakaoUser() async throws -> User {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.main.async {
                UserApi.shared.me { user, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let user = user {
                        continuation.resume(returning: user)
                    } else {
                        continuation.resume(throwing: NSError(domain: "UserFetchError", code: -1))
                    }
                }
            }
        }
    }
}

extension KakaoSignInService: KakaoSignInServiceProtocol {}

// MARK: Protocols
public protocol KakaoSignInServiceProtocol {
    func signInAndGetUserId() async throws -> String
}

public protocol KakaoSignInUseCase {
    func execute() async throws -> String
}

// MARK: UseCase
public final class DefaultKakaoSignInUseCase: KakaoSignInUseCase {
    private let signInService: KakaoSignInServiceProtocol
    
    public init(signInService: KakaoSignInServiceProtocol) {
        self.signInService = signInService
    }
    
    public func execute() async throws -> String {
        return try await signInService.signInAndGetUserId()
    }
}
