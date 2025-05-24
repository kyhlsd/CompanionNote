//
//  PrayRequestTableViewController.swift
//  Shared
//
//  Created by 김영훈 on 3/20/25.
//

import UIKit

public class PrayRequest {
    public let date: Date
    public var title: String
    public var contents: [PrayRequestContent]
    public let uuid: UUID
    
    public init(date: Date, title: String, contents: [PrayRequestContent], uuid: UUID = UUID()) {
        self.date = date
        self.title = title
        self.contents = contents
        self.uuid = uuid
    }
    
    public func updateData(title: String, contents: [PrayRequestContent]) {
        self.title = title
        self.contents = contents
    }
    
    public static let dummyDatas = [
        PrayRequest(date: Date(), title: "조 모임", contents: [
            PrayRequestContent(subject: "지수", description: "이번 한 주도 하나님 안에서 평안을 누리며 살 수 있도록"),
            PrayRequestContent(subject: "영훈", description: "시간을 지혜롭게 사용하기\n이번주 목표한 것들 성공/실패가 아니라 모두가 기쁜 마음으로 임할 수 있기를"),
            PrayRequestContent(subject: "하진", description: "기도 많이 하기, 말씀 많이 읽기, 찬양 많이 듣기"),
        ]),
        PrayRequest(date: Date(), title: "조 모임", contents: [
            PrayRequestContent(subject: "지수", description: "이번 한 주도 하나님 안에서 평안을 누리며 살 수 있도록"),
            PrayRequestContent(subject: "영훈", description: "시간을 지혜롭게 사용하기\n이번주 목표한 것들 성공/실패가 아니라 모두가 기쁜 마음으로 임할 수 있기를"),
            PrayRequestContent(subject: "하진", description: "기도 많이 하기, 말씀 많이 읽기, 찬양 많이 듣기"),
        ]),
        PrayRequest(date: Date(), title: "조 모임", contents: [
            PrayRequestContent(subject: "지수", description: "이번 한 주도 하나님 안에서 평안을 누리며 살 수 있도록"),
            PrayRequestContent(subject: "영훈", description: "시간을 지혜롭게 사용하기\n이번주 목표한 것들 성공/실패가 아니라 모두가 기쁜 마음으로 임할 수 있기를"),
            PrayRequestContent(subject: "하진", description: "기도 많이 하기, 말씀 많이 읽기, 찬양 많이 듣기"),
        ]),
        PrayRequest(date: Date(), title: "조 모임", contents: [
            PrayRequestContent(subject: "지수", description: "이번 한 주도 하나님 안에서 평안을 누리며 살 수 있도록"),
            PrayRequestContent(subject: "영훈", description: "시간을 지혜롭게 사용하기\n이번주 목표한 것들 성공/실패가 아니라 모두가 기쁜 마음으로 임할 수 있기를"),
            PrayRequestContent(subject: "하진", description: "기도 많이 하기, 말씀 많이 읽기, 찬양 많이 듣기"),
        ]),
    ]
}

public struct PrayRequestContent: Equatable {
    let subject: String
    let description: String
    
    public init(subject: String, description: String) {
        self.subject = subject
        self.description = description
    }
}

public class PrayRequestCollectionView: UICollectionView {

    public var prayRequests: [PrayRequest]
    public var isDeleteMode: Bool = false
    weak var pushViewControllerDelegate: PushViewControllerDelegate?
    
    public init(prayRequests: [PrayRequest]) {
        self.prayRequests = prayRequests
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.backgroundColor = .clear
        self.dataSource = self
        self.delegate = self
        self.register(PrayRequestCollectionViewCell.self, forCellWithReuseIdentifier: "PrayRequestCell")
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func enableDeleteMode() {
        for case let cell as PrayRequestCollectionViewCell in visibleCells {
            cell.enableDeleteMode()
        }
    }
    
    public func deletePrayRequests() {
        //TODO: 전체 순회할 필요없이 체크 박스 선택 시 뷰모델 배열에 uuid 추가하도록
        for case let cell as PrayRequestCollectionViewCell in visibleCells {
            if cell.getCheckedState(), let uuid = cell.getPrayRequestUUID() {
                print(uuid.uuidString)
            }
        }
    }
}

extension PrayRequestCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        prayRequests.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrayRequestCell", for: indexPath) as! PrayRequestCollectionViewCell
        let prayRequest = prayRequests[indexPath.row]
        cell.configure(with: prayRequest)
        if isDeleteMode {
            cell.enableDeleteMode()
        } else {
            cell.disableDeleteMode()
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 삭제 모드일 때 체크박스 토글
        if isDeleteMode {
            if let cell = collectionView.cellForItem(at: indexPath) as? PrayRequestCollectionViewCell {
                cell.toggleCheckBoxState()
            }
        } else { // 기본 모드일 때 상세보기
            let selectedPrayRequest = prayRequests[indexPath.row]
            let prayRequestDetailViewController = PrayRequestDetailViewController(with: selectedPrayRequest)
            pushViewControllerDelegate?.pushViewController(with: prayRequestDetailViewController)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameWidth = collectionView.frame.width
        let width = frameWidth < 600 ? frameWidth : frameWidth / 2
        return CGSize(width: width, height: 150)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
