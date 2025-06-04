//
//  AppleSignInService.swift
//  Core
//
//  Created by 김영훈 on 6/3/25.
//

import Foundation
import AuthenticationServices
import CryptoKit

public final class AppleSignInService: NSObject {
    
    private var continuation: CheckedContinuation<String, Error>?
    private var currentNonce: String?
    private var presentationAnchor: ASPresentationAnchor?
    
    public func signInAndGetUserId(presentationAnchor: ASPresentationAnchor?) async throws -> String {
        let nonce = randomNonceString()
        currentNonce = nonce
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            self.presentationAnchor = presentationAnchor
            authorizationController.performRequests()
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}

extension AppleSignInService: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard self.currentNonce != nil else {
            continuation?.resume(throwing: NSError(domain: "AppleLogin", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing nonce"]))
            return
        }
        
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?.resume(throwing: NSError(domain: "AppleLogin", code: -2, userInfo: [NSLocalizedDescriptionKey: "Invalid credential"]))
            return
        }
        
        let userIdentifier = credential.user
        
        continuation?.resume(returning: userIdentifier)
        cleanup()
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: error)
        cleanup()
    }
    
    private func cleanup() {
        continuation = nil
        currentNonce = nil
        presentationAnchor = nil
    }
}

extension AppleSignInService: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return presentationAnchor ?? ASPresentationAnchor()
    }
}

extension AppleSignInService: AppleSignInServiceProtocol {}

public protocol AppleSignInServiceProtocol {
    func signInAndGetUserId(presentationAnchor: ASPresentationAnchor?) async throws -> String
}

public protocol AppleSignInUseCase {
    func execute(presentationAnchor: ASPresentationAnchor?) async throws -> String
}

public final class DefaultAppleSignInUseCase: AppleSignInUseCase {
    private let signInService: AppleSignInServiceProtocol
    
    public init(signInService: AppleSignInServiceProtocol) {
        self.signInService = signInService
    }
    
    public func execute(presentationAnchor: ASPresentationAnchor?) async throws -> String {
        return try await signInService.signInAndGetUserId(presentationAnchor: presentationAnchor)
    }
}
