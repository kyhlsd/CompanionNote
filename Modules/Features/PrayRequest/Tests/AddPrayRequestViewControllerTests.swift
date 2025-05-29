//
//  AddPrayRequestViewControllerTests.swift
//  FeatureTests
//
//  Created by 김영훈 on 5/29/25.
//

import XCTest
@testable import Features

final class AddPrayRequestViewControllerTests: XCTestCase {
    
    var sut: AddPrayRequestViewController!
    
    override func setUp() {
        super.setUp()
        sut = AddPrayRequestViewController()
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
}
