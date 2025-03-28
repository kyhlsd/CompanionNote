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
    
}
