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
    let text: String
    
    public static let dummyDatas = [
            PrayRequest(date: Date(), title: "Title1", text: "Text1"),
            PrayRequest(date: Date(), title: "Title2", text: "Text2"),
            PrayRequest(date: Date(), title: "Title3", text: "Text3"),
    ]
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
        let size = collectionView.frame.width / 2
        return CGSize(width: size, height: size)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
