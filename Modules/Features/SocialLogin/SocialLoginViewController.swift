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

public class SocialLoginViewController: UIViewController {
    
    var currentNonce: String?
    
    private let appleButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButtonActions()
    }
    
    private func setupUI() {
        view.addSubview(appleButton)
        
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            appleButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 100),
            appleButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -100),
            appleButton.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            appleButton.heightAnchor.constraint(equalToConstant: 64),
        ])
    }
    
    private func setupButtonActions() {
        appleButton.addAction(UIAction { [weak self] _ in
//            Task {
//                await self?.testFirestore()
//            }
            self?.testAppleLogin()
        }, for: .touchUpInside)
    }
    
    private func testFirestore() async {
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        
        do {
            _ = try await db.collection("Test").addDocument(data: [
            "first": "Ada",
            "last": "Lovelace",
            "born": 1815
          ])
        } catch {
          print("Error adding document: \(error)")
        }
    }
    
    private func testAppleLogin() {
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
}

extension SocialLoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard currentNonce != nil else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            // TODO: 로그인 처리, Firestore 저장
            print(userIdentifier)
            if let fullName = appleIDCredential.fullName,
               let email = appleIDCredential.email {
                let formatter = PersonNameComponentsFormatter()
                let fullNameString = formatter.string(from: fullName)
                saveToKeyChain(key: "userName", value: fullNameString)
                saveToKeyChain(key: "userEmail", value: email)
            }
            print(getFromKeychain(key: "userName"))
            print(getFromKeychain(key: "userEmail"))
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
