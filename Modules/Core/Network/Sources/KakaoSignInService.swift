//
//  KakaoLogInService.swift
//  Core
//
//  Created by 김영훈 on 6/3/25.
//

import Foundation
import KakaoSDKUser
import KakaoSDKAuth
import FirebaseFunctions
import FirebaseAuth

public final class KakaoSignInService {
    
    public init() {}
    
    public func signIn() async throws {
        let token: OAuthToken
        if UserApi.isKakaoTalkLoginAvailable() {
            token = try await loginWithKakaoTalk()
        } else {
            token = try await loginWithKakaoAccount()
        }
        
        let kakaoAccessToken = token.accessToken
        
        let firebaseCustomToken = try await getFirebaseCustomToken(kakaoAccessToken: kakaoAccessToken)
        try await Auth.auth().signIn(withCustomToken: firebaseCustomToken)
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
    
    private func getFirebaseCustomToken(kakaoAccessToken: String) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            let functions = Functions.functions()
            functions.httpsCallable("kakaoSignIn").call(["token": kakaoAccessToken]) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let token = (result?.data as? [String: Any])?["token"] as? String {
                    continuation.resume(returning: token)
                } else {
                    continuation.resume(throwing: NSError(domain: "FirebaseTokenError", code: -1, userInfo: [NSLocalizedDescriptionKey: "커스텀 토큰을 받지 못했습니다."]))
                }
            }
        }
    }
}

extension KakaoSignInService: KakaoSignInServiceProtocol {}

// MARK: Protocols
public protocol KakaoSignInServiceProtocol {
    func signIn() async throws
}

public protocol KakaoSignInUseCase {
    func execute() async throws
}

// MARK: UseCase
public final class DefaultKakaoSignInUseCase: KakaoSignInUseCase {
    private let signInService: KakaoSignInServiceProtocol
    
    public init(signInService: KakaoSignInServiceProtocol) {
        self.signInService = signInService
    }
    
    public func execute() async throws {
        return try await signInService.signIn()
    }
}
