//
//  PrayRequestDetailViewControllerTests.swift
//  FeatureTests
//
//  Created by 김영훈 on 5/30/25.
//

import XCTest
@testable import Features
@testable import Core

final class PrayRequestDetailViewControllerTests: XCTestCase {
    
    var prayRequest: PrayRequest!
    var sut: SpyPrayRequestDetailViewController!
    var mockViewModel: MockViewModel!
    var originPrayRequest = PrayRequest(
        date: Date(),
        title: "Test Title",
        items: [
            PrayItem(name: "Name1", content: "Content1"),
            PrayItem(name: "Name2", content: "Content2")
        ],
        category: .personal
    )
    
    override func setUp() {
        super.setUp()
        
        mockViewModel = MockViewModel()
        sut = SpyPrayRequestDetailViewController(with: originPrayRequest, viewModel: mockViewModel)
        // 강제로 viewDidLoad 호출해서 뷰 계층 생성
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        prayRequest = nil
        sut = nil
        mockViewModel = nil
        super.tearDown()
    }
    
    func test_initialUI_setupCorrectly() {
        // 네비게이션 아이템에 editBarButtonItem 존재 확인
        XCTAssertEqual(sut.navigationItem.rightBarButtonItem, sut.editBarButtonItem)
        
        // prayContainerView 숨겨져있지 않은지
        XCTAssertFalse(sut.prayContainerView.isHidden)
        
        // prayEditorContainerView는 숨겨져 있어야 함
        XCTAssertTrue(sut.prayEditorContainerView.isHidden)
        
        // 테이블뷰의 행 개수는 prayRequest.items.count와 동일
        XCTAssertEqual(sut.prayDetailTableView.numberOfRows(inSection: 0), originPrayRequest.items.count)
    }
    
    func test_editButtonTapped_changesUIToEditMode() {
        sut.editButtonTapped()
        
        // navigationItem 오른쪽 버튼이 completeBarButtonItem으로 변경
        XCTAssertEqual(sut.navigationItem.rightBarButtonItems?.first, sut.completeBarButtonItem)
        
        // prayContainerView는 숨김
        XCTAssertTrue(sut.prayContainerView.isHidden)
        
        // prayEditorContainerView는 보임
        XCTAssertFalse(sut.prayEditorContainerView.isHidden)
        
        // prayRequest 내용으로 prayEditorView configure
        XCTAssertEqual(sut.prayEditorView.titleTextField.text, sut.prayRequest.title)
        XCTAssertEqual(sut.prayEditorView.prayItemTextView.text, PrayItemUtils.convertFromPrayItem(with: sut.prayRequest.items))
    }
    
    @MainActor
    func test_completeButtonTapped_success_updatesPrayRequestAndUI() async {
        sut.editButtonTapped()
        
        // 가짜 편집된 PrayRequest 생성
        let editedTitle = "Edited Title"
        let editedItems = [PrayItem(name: "EditedName", content: "EditedContent")]
        let editedCategory = PrayCategory.church
        
        sut.prayEditorView.titleTextField.text = editedTitle
        sut.prayEditorView.prayItemTextView.text = PrayItemUtils.convertFromPrayItem(with: editedItems)
        sut.prayEditorView.categorySelectorView.selectedIndex = PrayCategory.allCases.firstIndex(of: editedCategory)!
        
        sut.completeButtonTapped()
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // prayRequest가 실제로 업데이트 되었는지 확인
        XCTAssertEqual(sut.prayRequest.title, editedTitle)
        XCTAssertEqual(sut.prayRequest.items, editedItems)
        XCTAssertEqual(sut.prayRequest.category, editedCategory)
        
        // viewModel 동작 확인
        XCTAssertTrue(mockViewModel.didUpdate)
        
        // UI 상태가 편집 모드에서 읽기 모드로 변경됨
        XCTAssertEqual(sut.navigationItem.rightBarButtonItems?.first, sut.editBarButtonItem)
        XCTAssertFalse(sut.prayContainerView.isHidden)
        XCTAssertTrue(sut.prayEditorContainerView.isHidden)
    }
    
    @MainActor
    func test_completeButtonTapped_failure_updatesPrayRequestAndUI() async {
        mockViewModel.shouldSucceed = false
        
        sut.editButtonTapped()
        
        // 가짜 편집된 PrayRequest 생성
        let editedTitle = "Edited Title"
        let editedItems = [PrayItem(name: "EditedName", content: "EditedContent")]
        let editedCategory = PrayCategory.church
        
        sut.prayEditorView.titleTextField.text = editedTitle
        sut.prayEditorView.prayItemTextView.text = PrayItemUtils.convertFromPrayItem(with: editedItems)
        sut.prayEditorView.categorySelectorView.selectedIndex = PrayCategory.allCases.firstIndex(of: editedCategory)!
        
        sut.completeButtonTapped()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // prayRequest가 업데이트 실패했는지 확인
        XCTAssertEqual(sut.prayRequest.title, originPrayRequest.title)
        XCTAssertEqual(sut.prayRequest.items, originPrayRequest.items)
        XCTAssertEqual(sut.prayRequest.category, originPrayRequest.category)
        
        // viewModel 동작 확인
        XCTAssertFalse(mockViewModel.didUpdate)
        XCTAssertFalse(mockViewModel.shouldUpdate)
        
        // UI 상태가 편집 모드에서 읽기 모드로 변경되지 않음
        XCTAssertEqual(sut.navigationItem.rightBarButtonItems?.first, sut.completeBarButtonItem)
        XCTAssertTrue(sut.prayContainerView.isHidden)
        XCTAssertFalse(sut.prayEditorContainerView.isHidden)
    }
    
    @MainActor
    func test_completeButtonTapped_failure_shouldPresentErrorAlert() async {
        mockViewModel.shouldSucceed = false
        
        sut.completeButtonTapped()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertTrue(sut.errorPresented)
    }
    
    func test_tableViewDataSource_numberOfRows() {
        let rows = sut.tableView(sut.prayDetailTableView, numberOfRowsInSection: 0)
        XCTAssertEqual(rows, originPrayRequest.items.count)
    }
    
    func test_tableViewDataSource_cellForRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(sut.prayDetailTableView, cellForRowAt: indexPath) as? PrayDetailTableViewCell
        
        // PrayDetailTableViewCell Configure
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.nameLabel.text, originPrayRequest.items[0].name)
        XCTAssertEqual(cell?.contentLabel.text, originPrayRequest.items[0].content)
    }
    
    func test_updateRightBarButtonEnabled_changesCompleteButtonState() {
        // 초기에는 비활성화 상태일 수도 있으니 명확히 설정
        sut.completeBarButtonItem.isEnabled = false
        
        // PrayEditorView가 isAllTextsValid = true라고 가정하여 delegate 호출
        sut.prayEditorView.isAllTextsValid = true
        sut.updateRightBarButtonEnabled()
        
        XCTAssertTrue(sut.completeBarButtonItem.isEnabled)
        
        sut.prayEditorView.isAllTextsValid = false
        sut.updateRightBarButtonEnabled()
        
        XCTAssertFalse(sut.completeBarButtonItem.isEnabled)
    }
    
    final class MockViewModel: PrayRequestViewModelProtocol {
        @Published var filteredPrayRequests = [Core.PrayRequest]()
        var prayRequestsPublisher: Published<[Core.PrayRequest]>.Publisher { $filteredPrayRequests }
        @Published var shouldUpdate = false
        var shouldUpdatePublisher: Published<Bool>.Publisher { $shouldUpdate }
        
        var shouldSucceed = true
        var didUpdate = false
        
        func addPrayRequest(prayRequest: PrayRequest) async throws {}
        
        func fetchPrayRequests() async throws {}
        
        func updatePrayRequest(prayRequest: Core.PrayRequest) async throws {
            if shouldSucceed {
                didUpdate = true
            } else {
                throw NSError(domain: "TestError", code: 999, userInfo: nil)
            }
        }
        
        func deletePrayRequests(prayRequestIds: [String]) async throws {}
        func deletePrayRequest(prayRequestId: UUID) async throws {}
        func setIsPinned(prayRequestId: UUID, isPinned: Bool) async throws {}
        
        func activeUpdateStatus() {
            shouldUpdate.toggle()
        }
        func updateSearchedResults(with searchText: String) {}
        func updateSelectedResults(with index: Int) {}
        func sortPrayRequests() {}
        func updatePrayRequests() {}
    }
    
    final class SpyPrayRequestDetailViewController: PrayRequestDetailViewController {
        var errorPresented = false
        
        override func presentErrorAlert(for error: Error, title: String) {
            errorPresented = true
        }
    }
}
