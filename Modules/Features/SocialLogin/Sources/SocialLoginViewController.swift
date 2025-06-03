//
//  SocialLoginViewController.swift
//  Features
//
//  Created by 김영훈 on 5/31/25.
//

import UIKit
import AuthenticationServices
import FirebaseCore
import FirebaseFirestore
import Core

public class SocialLoginViewController: UIViewController {

    let db = Firestore.firestore()
    
    private let logoImageView = UIImageView()
    
    private let appleLoginButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
    
    private let kakaoLoginButton = UIButton()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButtonActions()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        setupLogoImageView()
        setupKakaoLoginButton()
        
        view.addSubview(logoImageView)
        view.addSubview(appleLoginButton)
        view.addSubview(kakaoLoginButton)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        kakaoLoginButton.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        let socialLoginButtonsHeight: CGFloat = 48
        let socialLoginButtonsWidth: CGFloat = socialLoginButtonsHeight * 20.0 / 3.0
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: -100),
            logoImageView.heightAnchor.constraint(equalToConstant: socialLoginButtonsWidth),
            logoImageView.widthAnchor.constraint(equalToConstant: socialLoginButtonsWidth),
            
            appleLoginButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            appleLoginButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 80),
            appleLoginButton.heightAnchor.constraint(equalToConstant: socialLoginButtonsHeight),
            appleLoginButton.widthAnchor.constraint(equalToConstant: socialLoginButtonsWidth),
            
            kakaoLoginButton.topAnchor.constraint(equalTo: appleLoginButton.bottomAnchor, constant: 20),
            kakaoLoginButton.heightAnchor.constraint(equalToConstant: socialLoginButtonsHeight),
            kakaoLoginButton.widthAnchor.constraint(equalToConstant: socialLoginButtonsWidth),
            kakaoLoginButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor)
        ])
    }
    
    private func setupLogoImageView() {
        logoImageView.image = UIImage(named: "AppLogoImage", in: .module, with: nil)
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
        Task {
            do {
                guard let anchor = self.view.window else { return }
                let userIdentifier = try await AppleAuthManager.shared.loginAndGetUserId(presentationAnchor: anchor)
                
                let userExists = try await checkIfUserExists(userId: userIdentifier)
                let success = userExists ? true : await createUserData(userId: userIdentifier)
                
                // 서버에 UserIdentifier가 저장되어 있는 경우에만 UserDefaults에 저장, 로그인 처리
                if success {
                    UserDefaults.standard.set(userIdentifier, forKey: "userId")
                } else {
                    // TODO: login 실패 처리
                }
            } catch {
                // TODO: login 실패 처리
                print("애플 로그인 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func kakaoLoginButtonTapped() {
        Task {
            do {
                let userIdentifier = try await KaKaoAuthManager.shared.loginAndGetUserId()
                
                let userExists = try await checkIfUserExists(userId: userIdentifier)
                let success = userExists ? true : await createUserData(userId: userIdentifier)
                
                // 서버에 UserIdentifier가 저장되어 있는 경우에만 UserDefaults에 저장, 로그인 처리
                if success {
                    UserDefaults.standard.set(userIdentifier, forKey: "userId")
                } else {
                    // TODO: login 실패 처리
                }
                
            } catch {
                // TODO: 로그인 실패 처리
                print("카카오 로그인 실패: \(error.localizedDescription)")
            }
        }
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
