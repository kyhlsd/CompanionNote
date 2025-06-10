//
//  PrayRequestViewControllerTests.swift
//  FeatureTests
//
//  Created by 김영훈 on 5/30/25.
//

import XCTest
@testable import Features
@testable import Core

final class PrayRequestViewControllerTests: XCTestCase {
    
    var sut: PrayRequestViewController!

    override func setUp() {
        super.setUp()
        sut = PrayRequestViewController(viewModel: MockViewModel())
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
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
    }

    func test_completeButtonTapped_exitsDeleteMode() {
        // Given
        sut.isDeleteMode = true
        let completeButton = sut.completeBarButtonItem.customView as? UIButton

        // When
        completeButton?.sendActions(for: .touchUpInside)

        // Then
        XCTAssertFalse(sut.isDeleteMode)
        XCTAssertTrue(sut.navigationItem.rightBarButtonItems?.contains(sut.plusBarButtonItem) ?? false)
    }

    func test_didSelectItem_inDeleteMode_togglesCheckBox() {
        // Given
        sut.isDeleteMode = true
        sut.loadViewIfNeeded()
        
        // 데이터 소스: 딱 1개 아이템만 반환
        class SingleItemDataSource: NSObject, UICollectionViewDataSource {
            func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                return 1
            }
            
            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrayRequestCell", for: indexPath) as! PrayRequestCollectionViewCell
                cell.configure(with: PrayRequest.dummyDatas[0])
                return cell
            }
        }
        
        // 강한 참조를 유지하기 위한 변수
        let dataSource = SingleItemDataSource()
        sut.prayRequestCollectionView.dataSource = dataSource

        sut.prayRequestCollectionView.reloadData()
        sut.prayRequestCollectionView.layoutIfNeeded()
        RunLoop.main.run(until: Date()) // 셀 생성 보장

        let indexPath = IndexPath(row: 0, section: 0)

        // When
        sut.collectionView(sut.prayRequestCollectionView, didSelectItemAt: indexPath)

        // Then
        let cell = sut.prayRequestCollectionView.cellForItem(at: indexPath) as? PrayRequestCollectionViewCell
        XCTAssertTrue(cell!.checkBox.isChecked)
    }


    func test_didSelectCategory_logsCorrectCategory() {
        // Given
        let categories = ["전체"] + PrayCategory.allCases.map { $0.rawValue }

        // When
        sut.didSelectCategory(1)

        // Then
        // TODO: 로그 확인 대신 실제 필터 적용되면 해당 부분 테스트
    }
    
    final class MockViewModel: PrayRequestViewModelProtocol {
        
        func addPrayRequest(prayRequest: PrayRequest) async throws {}
        
        func fetchPrayRequests() async throws -> [Core.PrayRequest] {
            return []
        }
    }
}
