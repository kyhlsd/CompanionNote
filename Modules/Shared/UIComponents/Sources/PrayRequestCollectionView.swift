//
//  PrayRequestTableViewController.swift
//  Shared
//
//  Created by 김영훈 on 3/20/25.
//

import UIKit

public struct PrayRequest {
    let date: Date
    let title: String
    let contents: [PrayRequestContent]
    
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
    ]
}

public struct PrayRequestContent {
    let subject: String
    let description: String
}

public class PrayRequestCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {

    public var prayRequests: [PrayRequest]
    
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
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        prayRequests.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrayRequestCell", for: indexPath) as! PrayRequestCollectionViewCell
        let prayRequest = prayRequests[indexPath.row]
        cell.configure(with: prayRequest)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPrayRequest = prayRequests[indexPath.row]
        print(selectedPrayRequest)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameWidth = collectionView.frame.width
        let width = frameWidth < 600 ? frameWidth : frameWidth / 2
        return CGSize(width: width, height: 165)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
