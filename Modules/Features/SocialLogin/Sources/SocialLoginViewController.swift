//
//  SocialLoginViewController.swift
//  Features
//
//  Created by 김영훈 on 5/31/25.
//

import UIKit
import AuthenticationServices
import Core
import Shared

public class SocialLoginViewController: UIViewController {
    
    private let appleSignInUseCase: AppleSignInUseCase
    private let kakaoSignInUseCase: KakaoSignInUseCase
    private let userUseCase: UserUseCase
    private let userDefaults: UserDefaults
    
    public init(
        appleSignInUseCase: AppleSignInUseCase,
        kakaoSignInUseCase: KakaoSignInUseCase,
        userUseCase: UserUseCase,
        userDefaults: UserDefaults = .standard
    ) {
        self.appleSignInUseCase = appleSignInUseCase
        self.kakaoSignInUseCase = kakaoSignInUseCase
        self.userUseCase = userUseCase
        self.userDefaults = userDefaults
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let logoImageView = UIImageView()
    
    private let appleLoginButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
    
    private let kakaoLoginButton = UIButton()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupButtonActions()
    }
    
    // MARK: Setups
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
    
    // MARK: Button Actions
    func appleLoginButtonTapped() {
        Task {
            do {
                guard let anchor = self.view.window else { return }
                let userIdentifier = try await appleSignInUseCase.execute(presentationAnchor: anchor)
                
                // 서버에 UserIdentifier가 저장되어 있는 경우에만 UserDefaults에 저장, 로그인 처리
                let userExists = try await userUseCase.userExists(userId: userIdentifier)
                if userExists {
                    try await userUseCase.createUser(userId: userIdentifier)
                    userDefaults.set(userIdentifier, forKey: "userId")
                    presentTabBarController()
                }
            } catch {
                presentLoginFailAlert()
            }
        }
    }
    
    func kakaoLoginButtonTapped() {
        Task {
            do {
                let userIdentifier = try await kakaoSignInUseCase.execute()
                
                // 서버에 UserIdentifier가 저장되어 있는 경우에만 UserDefaults에 저장, 로그인 처리
                let userExists = try await userUseCase.userExists(userId: userIdentifier)
                if userExists {
                    try await userUseCase.createUser(userId: userIdentifier)
                    userDefaults.set(userIdentifier, forKey: "userId")
                    presentTabBarController()
                }
            } catch {
                presentLoginFailAlert()
            }
        }
    }
    
    private func presentLoginFailAlert() {
        let alert = UIAlertController(
            title: nil,
            message: "로그인에 실패했습니다.\n다시 시도해주세요.",
            preferredStyle: .alert
        )
        
        let title = NSAttributedString(
            string: "로그인 실패",
            attributes: [
                .foregroundColor: UIColor.red,
                .font: UIFont.boldSystemFont(ofSize: 17)
            ]
        )
        
        alert.setValue(title, forKey: "attributedTitle")
        alert.addAction(UIAlertAction(title: "닫기", style: .default))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    private func presentTabBarController() {
        let firstViewController = UINavigationController(rootViewController: PrayRequestViewController(viewModel: PrayRequestViewModel()))
        let secondViewController = UIViewController()
        firstViewController.tabBarItem = UITabBarItem(title: "신앙 일기", image: UIImage(systemName: "map"), tag: 0)
        secondViewController.tabBarItem = UITabBarItem(title: "기도 제목", image: UIImage(systemName: "map"), tag: 1)
        setupTabBarController(with: [firstViewController, secondViewController])
    }
    
    // TabBarController 설정 함수
    private func setupTabBarController(with viewControllers: [UIViewController]) {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = viewControllers
        
        tabBarController.tabBar.isTranslucent = false
        
        let appearance = CustomTabBarAppearance.makeAppearance()
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance
        
        tabBarController.delegate = self
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            DispatchQueue.main.async {
                UIView.transition(with: window,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    window.rootViewController = tabBarController
                },
                                  completion: nil)
            }
        }
    }
}

// MARK: Extensions
extension SocialLoginViewController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navigationController = viewController as? UINavigationController {
            navigationController.viewControllers = [navigationController.viewControllers.first].compactMap { $0 }
        }
    }
}
