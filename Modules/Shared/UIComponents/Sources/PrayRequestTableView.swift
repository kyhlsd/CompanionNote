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

public class PrayRequestTableView: UITableView, UITableViewDataSource, UITableViewDelegate  {

    public var prayRequests: [PrayRequest]
    
    public init(prayRequests: [PrayRequest]) {
        self.prayRequests = prayRequests
        super.init(frame: .zero, style: .plain)
        self.backgroundColor = .clear
        self.dataSource = self
        self.delegate = self
        self.register(PrayRequestTableViewCell.self, forCellReuseIdentifier: "PrayRequestCell")
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        prayRequests.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrayRequestCell") as! PrayRequestTableViewCell
        let prayRequest = prayRequests[indexPath.row]
        cell.configure(with: prayRequest)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPrayRequest = prayRequests[indexPath.row]
        print(selectedPrayRequest)
    }
}
