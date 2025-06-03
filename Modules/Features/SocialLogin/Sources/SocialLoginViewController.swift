//
//  SocialLoginViewController.swift
//  Features
//
//  Created by 김영훈 on 5/31/25.
//

import UIKit
import AuthenticationServices
import CryptoKit
import FirebaseCore
import FirebaseFirestore
import Security
import KakaoSDKAuth
import KakaoSDKUser

public class SocialLoginViewController: UIViewController {
    
    var currentNonce: String?
    let db = Firestore.firestore()
    
    private let appleLoginButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
    
    private let kakaoLoginButton = UIButton()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButtonActions()
    }
    
    private func setupUI() {
        setupKakaoLoginButton()
        
        view.addSubview(appleLoginButton)
        view.addSubview(kakaoLoginButton)
        
        appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        kakaoLoginButton.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        let socialLoginButtonsHeight: CGFloat = 48
        let socialLoginButtonsWidth: CGFloat = socialLoginButtonsHeight * 20.0 / 3.0
        
        NSLayoutConstraint.activate([
            appleLoginButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            appleLoginButton.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            appleLoginButton.heightAnchor.constraint(equalToConstant: socialLoginButtonsHeight),
            appleLoginButton.widthAnchor.constraint(equalToConstant: socialLoginButtonsWidth),
            
            kakaoLoginButton.topAnchor.constraint(equalTo: appleLoginButton.bottomAnchor, constant: 40),
            kakaoLoginButton.heightAnchor.constraint(equalToConstant: socialLoginButtonsHeight),
            kakaoLoginButton.widthAnchor.constraint(equalToConstant: socialLoginButtonsWidth),
            kakaoLoginButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
    }
    
    private func setupKakaoLoginButton() {
        kakaoLoginButton.setImage(UIImage(named: "kakao_login_large_wide", in: .module, with: nil), for: .normal)
        kakaoLoginButton.contentVerticalAlignment = .fill
        kakaoLoginButton.contentHorizontalAlignment = .fill
    }
    
    private func setupButtonActions() {
        appleLoginButton.addAction(UIAction { [weak self] _ in
            self?.appleLoginButtonTapped()
        }, for: .touchUpInside)
        kakaoLoginButton.addAction(UIAction { [weak self] _ in
            self?.kakaoLoginButtonTapped()
        }, for: .touchUpInside)
    }
    
    private func appleLoginButtonTapped() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func kakaoLoginButtonTapped() {
        Task {
            do {
                if UserApi.isKakaoTalkLoginAvailable() {
                    let _ = try await loginWithKakaoTalk()
                } else {
                    let _ = try await loginWithKakaoAccount()
                }
                
                guard AuthApi.hasToken() else {
                    print("로그인 토큰이 존재하지 않음")
                    return
                }
                
                let user = try await fetchKakaoUser()
                guard let rawUserId = user.id else {
                    print("user ID가 존재하지 않음")
                    return
                }
                
                let userIdentifier = String(rawUserId)
                let userExists = try await checkIfUserExists(userId: userIdentifier)
                
                var success = false
                if userExists {
                    success = true
                } else {
                    success = await createUserData(userId: userIdentifier)
                }
                
                // 서버에 UserIdentifier가 저장되어 있는 경우에만 UserDefaults에 저장, 로그인 처리
                if success {
                    UserDefaults.standard.set(userIdentifier, forKey: "userId")
                } else {
                    // TODO: login 실패 처리
                }
                
            } catch {
                // TODO: 로그인 실패 처리
                print("로그인 실패: \(error.localizedDescription)")
            }
        }
    }
    
    // 카카오톡 로그인
    private func loginWithKakaoTalk() async throws -> OAuthToken {
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { token, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let token = token {
                    continuation.resume(returning: token)
                } else {
                    continuation.resume(throwing: NSError(domain: "LoginError", code: -1, userInfo: nil))
                }
            }
        }
    }
    
    // 웹으로 카카오 로그인
    private func loginWithKakaoAccount() async throws -> OAuthToken {
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { token, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let token = token {
                    continuation.resume(returning: token)
                } else {
                    continuation.resume(throwing: NSError(domain: "LoginError", code: -1, userInfo: nil))
                }
            }
        }
    }
    
    // 사용자 정보 가져오기
    private func fetchKakaoUser() async throws -> User {
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.me { user, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let user = user {
                    continuation.resume(returning: user)
                } else {
                    continuation.resume(throwing: NSError(domain: "UserFetchError", code: -1, userInfo: nil))
                }
            }
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
    
    private func saveToKeyChain(key: String, value: String) {
        guard let data = value.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func getFromKeychain(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        
        return nil
    }
    
    private func checkIfUserExists(userId: String) async throws -> Bool {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userId)
        let document = try await docRef.getDocument()
        return document.exists
    }
    
    private func createUserData(userId: String) async -> Bool {
        let data = ["userIdentifier": userId]
        do {
            try await db.collection("Users").document(userId).setData(data)
            return true
        } catch {
            print("Error writing document: \(error.localizedDescription)")
            return false
        }
    }

}

extension SocialLoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard currentNonce != nil else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            
            // 최초 로그인 시 fullName, email keychain에 저장
            if let fullName = appleIDCredential.fullName,
               let email = appleIDCredential.email {
                let formatter = PersonNameComponentsFormatter()
                let fullNameString = formatter.string(from: fullName)
                saveToKeyChain(key: "userName", value: fullNameString)
                saveToKeyChain(key: "userEmail", value: email)
            }
            
            Task {
                let userExists = try await checkIfUserExists(userId: userIdentifier)
                
                var success = false
                if userExists {
                    success = true
                } else {
                    success = await createUserData(userId: userIdentifier)
                }
                
                // 서버에 UserIdentifier가 저장되어 있는 경우에만 UserDefaults에 저장, 로그인 처리
                if success {
                    UserDefaults.standard.set(userIdentifier, forKey: "userId")
                } else {
                    // TODO: login 실패 처리
                }
            }
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        // TODO: login 실패 처리
        print("Faile to Apple Login: \(error.localizedDescription)")
    }
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
}
