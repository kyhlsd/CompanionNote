//
//  PrayRequestTableViewCell.swift
//  Shared
//
//  Created by 김영훈 on 3/20/25.
//

import UIKit
import Core
import Shared

final class PrayRequestCollectionViewCell: UICollectionViewCell {
    
    private var prayRequestUUID: UUID?
    
    private let cellContainerView = CellContainerView()
    private let titleLabel = UILabel()
    private let prayRequestContentTableView = UITableView(frame: .zero, style: .plain)
    private let dateLabel = UILabel()
    private let checkBox = CheckBox()
    
    private var dateLabelTrailingConstraint: NSLayoutConstraint!
    private var prayRequestContents: [PrayRequestContent] = []
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setups
    private func setupUI() {
        setupTitleLabel()
        setupPrayRequestContentTableView()
        setupDateLabel()
        setupCheckBox()
        
        backgroundColor = .clear
        selectedBackgroundView = UIView()
        
        contentView.addSubview(cellContainerView)
        cellContainerView.addSubview(titleLabel)
        cellContainerView.addSubview(dateLabel)
        cellContainerView.addSubview(checkBox)
        cellContainerView.addSubview(prayRequestContentTableView)
        
        cellContainerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        prayRequestContentTableView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            cellContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: cellContainerView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: cellContainerView.topAnchor, constant: 12),

            dateLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            
            checkBox.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -12),
            checkBox.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            checkBox.heightAnchor.constraint(equalToConstant: 24),
            checkBox.widthAnchor.constraint(equalToConstant: 24),

            prayRequestContentTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            prayRequestContentTableView.leadingAnchor.constraint(equalTo: cellContainerView.leadingAnchor, constant: 12),
            prayRequestContentTableView.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -12),
            prayRequestContentTableView.bottomAnchor.constraint(equalTo: cellContainerView.bottomAnchor, constant: -5)
        ])
        dateLabelTrailingConstraint = dateLabel.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -12)
        dateLabelTrailingConstraint.isActive = true
    }
    
    private func setupTitleLabel() {
        titleLabel.font = UIFont(name: "IropkeBatangM", size: 16)
        titleLabel.textColor = .systemBlue
    }
   
    private func setupPrayRequestContentTableView() {
        prayRequestContentTableView.isScrollEnabled = false
        prayRequestContentTableView.isUserInteractionEnabled = false
        prayRequestContentTableView.backgroundColor = .clear
        prayRequestContentTableView.separatorStyle = .none
        prayRequestContentTableView.dataSource = self
        prayRequestContentTableView.delegate = self
        prayRequestContentTableView.register(PrayRequestContentTableViewCell.self, forCellReuseIdentifier: "PrayRequestContentCell")
    }
    
    private func setupDateLabel() {
        dateLabel.font = UIFont(name: "IropkeBatangM", size: 14)
        dateLabel.textColor = .gray
    }
    
    private func setupCheckBox() {
        checkBox.isHidden = true
    }
    
    func configure(with prayRequest: PrayRequest) {
        let titleStrokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.systemBlue,
            .foregroundColor: UIColor.systemBlue,
            .strokeWidth: -4.0
        ]
        titleLabel.attributedText = NSAttributedString(
            string: prayRequest.title,
            attributes: titleStrokeTextAttributes
        )
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateLabel.text = dateFormatter.string(from: prayRequest.date)
        
        prayRequestContents = prayRequest.contents
        DispatchQueue.main.async {
            self.prayRequestContentTableView.reloadData()
        }
        
        self.prayRequestUUID = prayRequest.uuid
    }
    
    func enableDeleteMode() {
        checkBox.isHidden = false
        dateLabelTrailingConstraint.isActive = false
        dateLabelTrailingConstraint = dateLabel.trailingAnchor.constraint(equalTo: checkBox.leadingAnchor, constant: -12)
        dateLabelTrailingConstraint.isActive = true
    }
    
    func disableDeleteMode() {
        checkBox.isHidden = true
        checkBox.isChecked = false
        dateLabelTrailingConstraint.isActive = false
        dateLabelTrailingConstraint = dateLabel.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -12)
        dateLabelTrailingConstraint.isActive = true
    }
    
    func toggleCheckBoxState() {
        checkBox.isChecked.toggle()
    }
    
    func getCheckedState() -> Bool {
        return checkBox.isChecked
    }
    
    func getPrayRequestUUID() -> UUID? {
        return self.prayRequestUUID
    }
}

// MARK: Extensions
extension PrayRequestCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayRequestContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrayRequestContentCell") as! PrayRequestContentTableViewCell
        let prayRequestContent = prayRequestContents[indexPath.row]
        cell.configure(with: prayRequestContent)
        return cell
    }
}
