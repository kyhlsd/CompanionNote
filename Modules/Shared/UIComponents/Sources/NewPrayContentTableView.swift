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
        self.register(AddPrayContentButtonCell.self, forCellReuseIdentifier: "AddPrayContentButtonCell")
    }
    
    public required init?(coder: NSCoder) {
             fatalError("init(coder:) has not been implemented")
         }
         
    public func numberOfSections(in tableView: UITableView) -> Int {
        return prayRequestContents.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == prayRequestContents.count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddPrayContentButtonCell") as! AddPrayContentButtonCell
            cell.delegate = self
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewPrayContentCell") as! NewPrayContentTableViewCell
        cell.delegate = self
        cell.configure(index: indexPath.section + 1)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        return spacer
    }
}

public protocol ViewHeightChangeDelegate: AnyObject {
    func onViewHeightChange()
}

extension NewPrayContentTableView: ViewHeightChangeDelegate {
    public func onViewHeightChange() {
        UIView.setAnimationsEnabled(false)
        self.beginUpdates()
        self.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
}

public protocol AddPrayContentButtonCellDelegate: AnyObject {
    func didTapAddPrayContentButton()
}

extension NewPrayContentTableView: AddPrayContentButtonCellDelegate {
    public func didTapAddPrayContentButton() {
        self.prayRequestContents.append(PrayRequestContent(subject: "", description: ""))
        DispatchQueue.main.async { [weak self] in
            self?.reloadData()
        }
    }
}
