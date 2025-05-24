//
//  PrayRequestContentTableView.swift
//  Shared
//
//  Created by 김영훈 on 3/28/25.
//

import UIKit

public class PrayRequestContentTableView: UITableView, UITableViewDataSource, UITableViewDelegate {

    public var prayRequestContents: [PrayRequestContent]
        
    public init(prayRequestContents: [PrayRequestContent] = []) {
        self.prayRequestContents = prayRequestContents
        super.init(frame: .zero, style: .plain)
        self.backgroundColor = .clear
        self.separatorStyle = .none
        self.dataSource = self
        self.delegate = self
        self.register(PrayRequestContentTableViewCell.self, forCellReuseIdentifier: "PrayRequestContentCell")
    }
    
    public required init?(coder: NSCoder) {
             fatalError("init(coder:) has not been implemented")
         }
         
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayRequestContents.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrayRequestContentCell") as! PrayRequestContentTableViewCell
        let prayRequestContent = prayRequestContents[indexPath.row]
        cell.configure(with: prayRequestContent)
        return cell
    }
    
    // 상위 CollectionView의 TouchEvent를 가로채는 것을 방지
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        if self.isScrollEnabled {
            return hitView
        }
        
        return nil
    }
}
