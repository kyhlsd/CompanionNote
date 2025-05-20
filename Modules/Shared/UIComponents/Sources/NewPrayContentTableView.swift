//
//  NewPrayContainerTableViewController.swift
//  Shared
//
//  Created by 김영훈 on 5/20/25.
//

import UIKit

public class NewPrayContentTableView: UITableView, UITableViewDataSource, UITableViewDelegate {

    public var prayRequestContents: [PrayRequestContent]
        
    public init(prayRequestContents: [PrayRequestContent] = []) {
        self.prayRequestContents = prayRequestContents
        super.init(frame: .zero, style: .plain)
        self.backgroundColor = .clear
        self.separatorStyle = .none
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = 200
        self.dataSource = self
        self.delegate = self
        self.register(NewPrayContentTableViewCell.self, forCellReuseIdentifier: "NewPrayContentCell")
    }
    
    public required init?(coder: NSCoder) {
             fatalError("init(coder:) has not been implemented")
         }
         
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayRequestContents.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewPrayContentCell") as! NewPrayContentTableViewCell
        cell.delegate = self
        cell.configure(index: indexPath.row + 1)
        return cell
    }

}

protocol TextViewHeightChangeDelegate: AnyObject {
    func onTextViewHeightChange()
}

extension NewPrayContentTableView: TextViewHeightChangeDelegate {
    func onTextViewHeightChange() {
        UIView.setAnimationsEnabled(false)
        self.beginUpdates()
        self.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
}
