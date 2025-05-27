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
    private let categoryLabel = PaddedLabel()
    private let titleLabel = UILabel()
    private let prayItemTableView = UITableView(frame: .zero, style: .plain)
    private let dateLabel = UILabel()
    private let checkBox = CheckBox()
    
    private var dateLabelTrailingConstraint: NSLayoutConstraint!
    private var prayItems: [PrayItem] = []
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setups
    private func setupUI() {
        setupCategoryLabel()
        setupTitleLabel()
        setupPrayItemTableView()
        setupDateLabel()
        setupCheckBox()
        
        backgroundColor = .clear
        selectedBackgroundView = UIView()
        
        contentView.addSubview(cellContainerView)
        cellContainerView.addSubview(categoryLabel)
        cellContainerView.addSubview(titleLabel)
        cellContainerView.addSubview(dateLabel)
        cellContainerView.addSubview(checkBox)
        cellContainerView.addSubview(prayItemTableView)
        
        cellContainerView.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        prayItemTableView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        
        let innerPadding = Constants.innerPadding
        let scrolledCellBottomPadding = Constants.scrolledCellBottomPadding
        
        NSLayoutConstraint.activate([
            cellContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            categoryLabel.leadingAnchor.constraint(equalTo: cellContainerView.leadingAnchor, constant: innerPadding),
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: cellContainerView.topAnchor, constant: innerPadding - 4), // Font 여백에 따른 조정

            dateLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            
            checkBox.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -innerPadding + 4), // Font 여백에 따른 조정
            checkBox.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            checkBox.heightAnchor.constraint(equalToConstant: 24),
            checkBox.widthAnchor.constraint(equalToConstant: 24),

            prayItemTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            prayItemTableView.leadingAnchor.constraint(equalTo: cellContainerView.leadingAnchor, constant: innerPadding),
            prayItemTableView.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -innerPadding),
            prayItemTableView.bottomAnchor.constraint(equalTo: cellContainerView.bottomAnchor, constant: -scrolledCellBottomPadding)
        ])
        dateLabelTrailingConstraint = dateLabel.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -innerPadding)
        dateLabelTrailingConstraint.isActive = true
    }
    
    private func setupCategoryLabel() {
        categoryLabel.font = Shared.AppFonts.category
        categoryLabel.textColor = .white
        categoryLabel.textInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        categoryLabel.backgroundColor = .systemBlue
        categoryLabel.layer.cornerRadius = 6
        categoryLabel.clipsToBounds = true
    }
    
    private func setupTitleLabel() {
        titleLabel.font = Shared.AppFonts.body
    }
   
    private func setupPrayItemTableView() {
        prayItemTableView.isScrollEnabled = false
        prayItemTableView.isUserInteractionEnabled = false
        prayItemTableView.backgroundColor = .clear
        prayItemTableView.separatorStyle = .none
        prayItemTableView.dataSource = self
        prayItemTableView.delegate = self
        prayItemTableView.register(PrayItemTableViewCell.self, forCellReuseIdentifier: "PrayItemTableViewCell")
    }
    
    private func setupDateLabel() {
        dateLabel.font = Shared.AppFonts.detail
        dateLabel.textColor = .gray
    }
    
    private func setupCheckBox() {
        checkBox.isHidden = true
    }
    
    func configure(with prayRequest: PrayRequest) {
        
        categoryLabel.text = prayRequest.category.rawValue
        
        titleLabel.attributedText = NSAttributedString(
            string: prayRequest.title,
            attributes: Shared.FontTextAttributes.titleTextAttributes
        )
        
        dateLabel.text = DateFormatUtil.shortWithDayFormatter.string(from: prayRequest.date)
        
        prayItems = prayRequest.items
        
        DispatchQueue.main.async {
            self.prayItemTableView.reloadData()
        }
        
        self.prayRequestUUID = prayRequest.uuid
    }
    
    func enableDeleteMode() {
        checkBox.isHidden = false
        dateLabelTrailingConstraint.isActive = false
        dateLabelTrailingConstraint = dateLabel.trailingAnchor.constraint(equalTo: checkBox.leadingAnchor, constant: -4)
        dateLabelTrailingConstraint.isActive = true
    }
    
    func disableDeleteMode() {
        checkBox.isHidden = true
        checkBox.isChecked = false
        dateLabelTrailingConstraint.isActive = false
        let innerPadding = Constants.innerPadding
        dateLabelTrailingConstraint = dateLabel.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -innerPadding)
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
        return prayItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrayItemTableViewCell") as! PrayItemTableViewCell
        let prayItem = prayItems[indexPath.row]
        cell.configure(with: prayItem)
        return cell
    }
}
