//
//  PrayRequestViewControllerTests.swift
//  FeatureTests
//
//  Created by 김영훈 on 5/30/25.
//

import XCTest
@testable import Features
@testable import Core
import Combine

final class PrayRequestViewControllerTests: XCTestCase {
    
    var sut: SpyPrayRequestViewController!
    var mockViewModel: MockViewModel!
    
    override func setUp() {
        super.setUp()
        mockViewModel = MockViewModel()
        sut = SpyPrayRequestViewController(viewModel: mockViewModel)
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        mockViewModel = nil
        super.tearDown()
    }

    func test_plusButtonTapped_pushesAddPrayRequestVC() {
        // Given
        let navigationController = UINavigationController(rootViewController: sut)
        sut.loadViewIfNeeded()
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.1))

        // When
        let plusButton = sut.plusBarButtonItem.customView as? UIButton
        plusButton?.sendActions(for: .touchUpInside)

        // Then
        let pushedVC = navigationController.topViewController
        XCTAssertTrue(pushedVC is AddPrayRequestViewController)
    }

    func test_deleteButtonTapped_entersDeleteMode() {
        // When
        let deleteButton = sut.deleteBarButtonItem.customView as? UIButton
        deleteButton?.sendActions(for: .touchUpInside)

        // Then
        XCTAssertTrue(sut.navigationItem.rightBarButtonItems?.contains(sut.completeBarButtonItem) ?? false)
        XCTAssertEqual(sut.navigationItem.leftBarButtonItem, sut.cancelBarButtonItem)
        XCTAssertEqual(sut.navigationItem.titleView, sut.editBarLabel)
    }
    
    @MainActor
    func test_cancelButtonTapped_escapeDeleteMode() async {
        // Given
        sut.deleteIds = ["test1"]
        sut.isDeleteMode = true
        
        // When
        let cancelButton = sut.cancelBarButtonItem.customView as? UIButton
        cancelButton?.sendActions(for: .touchUpInside)
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertFalse(mockViewModel.didDelete)
        XCTAssertTrue(sut.deleteIds.isEmpty)
        XCTAssertFalse(sut.isDeleteMode)
        XCTAssertTrue(sut.navigationItem.rightBarButtonItems?.contains(sut.plusBarButtonItem) ?? false)
        XCTAssertEqual(sut.navigationItem.leftBarButtonItem, sut.titleBarLabelItem)
        XCTAssertNil(sut.navigationItem.titleView)
    }

    @MainActor
    func test_completeButtonTapped_successDelete() async {
        // Given
        mockViewModel.shouldSucceed = true
        sut.isDeleteMode = true
        sut.deleteIds = ["test1, test2, test3"]

        // When
        sut.deletePrayRequests()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertTrue(mockViewModel.didDelete)
        XCTAssertFalse(sut.isDeleteMode)
        XCTAssertTrue(sut.navigationItem.rightBarButtonItems?.contains(sut.plusBarButtonItem) ?? false)
        XCTAssertEqual(sut.navigationItem.leftBarButtonItem, sut.titleBarLabelItem)
        XCTAssertNil(sut.navigationItem.titleView)
    }
    
    @MainActor
    func test_completeButtonTapped_failDelete() async {
        // Given
        mockViewModel.shouldSucceed = false
        sut.isDeleteMode = true
        sut.deleteIds = ["test1, test2, test3"]
        sut.navigationItem.rightBarButtonItems = [sut.completeBarButtonItem]
        sut.navigationItem.leftBarButtonItem = sut.cancelBarButtonItem
        sut.navigationItem.titleView = sut.editBarLabel
        
        // When
        sut.deletePrayRequests()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then
        XCTAssertFalse(mockViewModel.didDelete)
        XCTAssertTrue(sut.isDeleteMode)
        XCTAssertTrue(sut.navigationItem.rightBarButtonItems?.contains(sut.completeBarButtonItem) ?? false)
        XCTAssertEqual(sut.navigationItem.leftBarButtonItem, sut.cancelBarButtonItem)
        XCTAssertEqual(sut.navigationItem.titleView, sut.editBarLabel)
        XCTAssertTrue(sut.errorPresented)
    }

    func test_didSelectCategory_logsCorrectCategory() {
        // Given
        let firstItem = PrayRequest(date: Date(), title: "Test1", items: [], category: .church)
        let secondItem = PrayRequest(date: Date(), title: "Test2", items: [], category: .personal)
        mockViewModel.totalPrayRequests = [firstItem, secondItem]

        // When
        sut.didSelectCategory(1)

        // Then
        XCTAssertTrue(mockViewModel.selectedPrayRequests.contains {
            $0.uuid == firstItem.uuid
        })
        XCTAssertFalse(mockViewModel.selectedPrayRequests.contains {
            $0.uuid == secondItem.uuid
        })
    }
    
    @MainActor
    func test_fetchPrayRequests_failure_shouldPresentErrorAlert() async {
        let mockViewModel = MockViewModel()
        mockViewModel.shouldSucceed = false
        
        let sut = SpyPrayRequestViewController(viewModel: mockViewModel)
        sut.loadViewIfNeeded()
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertTrue(sut.errorPresented)
    }
    
    func test_searchPrayRequest() {
        // Given
        let firstItem = PrayRequest(date: Date(), title: "Test1", items: [], category: .church)
        let secondItem = PrayRequest(date: Date(), title: "Test2", items: [], category: .church)
        mockViewModel.totalPrayRequests = [firstItem, secondItem]

        // When
        sut.searchBar(sut.praySearchBar, textDidChange: "test2")
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.4))

        // Then
        XCTAssertFalse(mockViewModel.prayRequests.contains { item in
            item.uuid == firstItem.uuid
        })
        XCTAssertTrue(mockViewModel.prayRequests.contains { item in
            item.uuid == secondItem.uuid
        })
    }
    
    final class MockViewModel: PrayRequestViewModelProtocol {
        var totalPrayRequests = [Core.PrayRequest]()
        var selectedPrayRequests = [Core.PrayRequest]()
        @Published var prayRequests = [Core.PrayRequest]()
        var prayRequestsPublisher: Published<[Core.PrayRequest]>.Publisher { $prayRequests }
        @Published var shouldFetch = true
        var shouldFetchPublisher: Published<Bool>.Publisher { $shouldFetch }
        
        var shouldSucceed = true
        
        func addPrayRequest(prayRequest: PrayRequest) async throws {}
        
        func fetchPrayRequests() async throws {
            if shouldSucceed {
                prayRequests = [Core.PrayRequest.dummyDatas[0]]
            } else {
                throw NSError(domain: "TestError", code: 999, userInfo: nil)
            }
        }
        
        func updatePrayRequest(prayRequest: Core.PrayRequest) async throws {}
        
        var didDelete = false
        
        func deletePrayRequests(prayRequestIds: [String]) async throws {
            if shouldSucceed {
                didDelete = true
            } else {
                throw NSError(domain: "TestError", code: 999, userInfo: nil)
            }
        }
        func deletePrayRequest(prayRequestId: UUID) async throws {}
        func setIsPinned(prayRequestId: String, isPinned: Bool) async throws {}
        func activeFetchStatus() {}
        func updateSearchedResults(with searchText: String) {
            guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                prayRequests = totalPrayRequests.sorted { $0.date > $1.date }
                        return
            }
            
            let filtered = totalPrayRequests.filter {
                SearchPrayRequestUtils.matches(target: $0, keyword: searchText)
            }
            
            prayRequests = filtered.sorted { $0.date > $1.date }
        }
        func updateSelectedResults(with index: Int) {
            let categories = ["전체"] + PrayCategory.allCases.map { $0.rawValue }
            guard categories.count > index, index >= 0 else { return }
            
            if index == 0 {
                selectedPrayRequests = totalPrayRequests
                return
            }
            
            let categoryRawValue = categories[index]
            let selected = totalPrayRequests.filter { $0.category.rawValue == categoryRawValue }
            selectedPrayRequests = selected
        }
    }
    
    final class SpyPrayRequestViewController: PrayRequestViewController {
        var errorPresented = false
        
        override func presentErrorAlert(for error: Error, title: String) {
            errorPresented = true
        }
    }
}
