//
//  PrayRequestDetailViewController.swift
//  Features
//
//  Created by 김영훈 on 5/22/25.
//

import UIKit

public protocol PushViewControllerDelegate: AnyObject {
    func pushViewController(with viewController: UIViewController)
}

class PrayRequestDetailViewController: UIViewController {

    private let prayRequest: PrayRequest
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("수정", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.addAction(UIAction() { [weak self] _ in
            guard let self = self else { return }
            self.editButtonTapped()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.addAction(UIAction() { [weak self] _ in
            guard let self = self else { return }
            self.completeButtonTapped()
        }, for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var prayContainerView = {
        let prayContainerView = PrayContainerView()
        prayContainerView.translatesAutoresizingMaskIntoConstraints = false
        return prayContainerView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IropkeBatangM", size: 20)
        let titleStrokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.systemBlue,
            .foregroundColor: UIColor.systemBlue,
            .strokeWidth: -4.0
        ]
        label.attributedText = NSAttributedString(
            string: prayRequest.title,
            attributes: titleStrokeTextAttributes
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var prayDetailTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PrayDetailTableViewCell.self, forCellReuseIdentifier: "PrayDetailCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "IropkeBatangM", size: 16)
        label.textColor = .gray
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        label.text = dateFormatter.string(from: prayRequest.date)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(with prayRequest: PrayRequest) {
        self.prayRequest = prayRequest
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        setupNavigationBar()
        setupUI()
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: -2.5
        ]
        titleLabel.attributedText = NSAttributedString(
            string: "기도 제목",
            attributes: strokeTextAttributes
        )
        
        titleLabel.font = UIFont(name: "IropkeBatangM", size: 22)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        navigationItem.titleView = titleLabel
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
    }

    private func setupUI() {
        view.addSubview(prayContainerView)
        prayContainerView.addSubview(titleLabel)
        prayContainerView.addSubview(dateLabel)
        prayContainerView.addSubview(prayDetailTableView)
        
        let sidePadding = Constants.sidePadding
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            prayContainerView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 4),
            prayContainerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -12),
            prayContainerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: sidePadding),
            prayContainerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -sidePadding),

            titleLabel.leadingAnchor.constraint(equalTo: prayContainerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: prayContainerView.trailingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: prayContainerView.topAnchor, constant: 12),

            dateLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: prayContainerView.trailingAnchor, constant: -12),
            
            prayDetailTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            prayDetailTableView.leadingAnchor.constraint(equalTo: prayContainerView.leadingAnchor, constant: 12),
            prayDetailTableView.trailingAnchor.constraint(equalTo: prayContainerView.trailingAnchor, constant: -12),
            prayDetailTableView.bottomAnchor.constraint(equalTo: prayContainerView.bottomAnchor, constant: -5)
        ])
    }
    
    private func editButtonTapped() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: completeButton)
        ]
    }
    
    private func completeButtonTapped() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: editButton)
        ]
    }
}

extension PrayRequestDetailViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayRequest.contents.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrayDetailCell") as! PrayDetailTableViewCell
        let prayRequestContent = prayRequest.contents[indexPath.row]
        cell.configure(with: prayRequestContent)
        return cell
    }
}
