//
//  AddPrayRequestViewControllerTests.swift
//  FeatureTests
//
//  Created by 김영훈 on 5/29/25.
//

import XCTest
@testable import Features
@testable import Core

final class AddPrayRequestViewControllerTests: XCTestCase {
    
    var sut: AddPrayRequestViewController!
    
    override func setUp() {
        super.setUp()
        sut = AddPrayRequestViewController(viewModel: MockViewModel())
        sut.loadViewIfNeeded()  // viewDidLoad 호출
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_viewDidLoad_navigationBarSetup() {
        // navigationItem titleView가 UILabel인지 확인
        XCTAssertTrue(sut.navigationItem.titleView is UILabel)
        
        // rightBarButtonItem이 존재하는지 확인
        XCTAssertNotNil(sut.navigationItem.rightBarButtonItem)
        
        // 버튼이 비활성화 상태여야 함 (초기 상태)
        XCTAssertFalse(sut.navigationItem.rightBarButtonItem?.isEnabled ?? true)
    }
    
    func test_updateRightBarButtonEnabled_enablesAndDisablesButton() {
        // 초기 상태: 비활성화
        XCTAssertFalse(sut.navigationItem.rightBarButtonItem?.isEnabled ?? true)
        
        // isAllTextsValid가 true일 때 delegate 호출 후 버튼 활성화 확인
        sut.prayEditorView.isAllTextsValid = true
        sut.updateRightBarButtonEnabled()
        XCTAssertTrue(sut.navigationItem.rightBarButtonItem?.isEnabled ?? false)
        
        // 다시 false로 변경 시 비활성화 확인
        sut.prayEditorView.isAllTextsValid = false
        sut.updateRightBarButtonEnabled()
        XCTAssertFalse(sut.navigationItem.rightBarButtonItem?.isEnabled ?? true)
    }
    
    func test_dismissKeyboard_whenCalled_shouldEndEditing() {
        // 현재 뷰가 편집중이라면 편집 종료 시도
        sut.view.endEditing(true)
        
        // 테스트 환경에서 별도로 검증할 방법은 없으나, 코드가 호출되는지 확인용으로 메서드 호출
        sut.dismissKeyboard()
    }
    
    func test_handleKeyboardWillShow_and_HandleKeyboardWillHide() {
        // 키보드가 나타날 때 Notification 생성
        let keyboardHeight: CGFloat = 300
        let animationDuration: TimeInterval = 0.25
        
        let keyboardRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: keyboardHeight)
        let userInfo: [AnyHashable: Any] = [
            UIResponder.keyboardFrameEndUserInfoKey: keyboardRect,
            UIResponder.keyboardAnimationDurationUserInfoKey: animationDuration
        ]
        
        let showNotification = Notification(name: UIResponder.keyboardWillShowNotification, object: nil, userInfo: userInfo)
        sut.handleKeyboardWillShow(showNotification)
        
        // 키보드가 사라질 때 Notification 생성
        let hideNotification = Notification(name: UIResponder.keyboardWillHideNotification, object: nil, userInfo: [
            UIResponder.keyboardAnimationDurationUserInfoKey: animationDuration
        ])
        sut.handleKeyboardWillHide(hideNotification)
        
        // 테스트는 호출 시 에러 발생 안하는지 확인용
    }
    
    @MainActor
    func test_addPrayRequest_success_shouldPopViewController() async {
        let mockViewModel = MockViewModel()
        mockViewModel.shouldSucceed = true

        let sut = SpyAddPrayRequestViewController(viewModel: mockViewModel)
        let spyNav = SpyNavigationController(rootViewController: sut)
        sut.loadViewIfNeeded()

        // 강제적으로 입력값이 유효하다고 설정
        sut.prayEditorView.isAllTextsValid = true
        sut.updateRightBarButtonEnabled()

        // 버튼을 탭한 것처럼 시뮬레이션
        let button = sut.navigationItem.rightBarButtonItem?.customView as? UIButton
        button?.sendActions(for: .touchUpInside)

        // 비동기 작업 완료 대기
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertTrue(mockViewModel.addPrayRequestCalled)
        XCTAssertTrue(spyNav.didPopViewController)
        XCTAssertFalse(sut.errorPresented)
    }
    
    @MainActor
    func test_addPrayRequest_failure_shouldPresentErrorAlert() async {
        let mockViewModel = MockViewModel()
        mockViewModel.shouldSucceed = false

        let sut = SpyAddPrayRequestViewController(viewModel: mockViewModel)
        let spyNav = SpyNavigationController(rootViewController: sut)
        sut.loadViewIfNeeded()

        // 유효성 통과
        sut.prayEditorView.isAllTextsValid = true
        sut.updateRightBarButtonEnabled()

        let button = sut.navigationItem.rightBarButtonItem?.customView as? UIButton
        button?.sendActions(for: .touchUpInside)

        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertTrue(mockViewModel.addPrayRequestCalled)
        XCTAssertFalse(spyNav.didPopViewController)
        XCTAssertTrue(sut.errorPresented)
    }

    
    final class MockViewModel: PrayRequestViewModelProtocol {
        var shouldSucceed = true
        var addPrayRequestCalled = false
        
        func addPrayRequest(prayRequest: PrayRequest) async throws {
            addPrayRequestCalled = true
            if !shouldSucceed {
                throw NSError(domain: "TestError", code: 999, userInfo: nil)
            }
        }
    }
    
    final class SpyNavigationController: UINavigationController {
        private(set) var didPopViewController = false
        
        override func popViewController(animated: Bool) -> UIViewController? {
            didPopViewController = true
            return super.popViewController(animated: animated)
        }
    }
    
    final class SpyAddPrayRequestViewController: AddPrayRequestViewController {
        var errorPresented = false
        
        override func presentErrorAlert(for error: Error) {
            errorPresented = true
        }
    }

}
