//
//  PrayRequestTableViewCell.swift
//  Shared
//
//  Created by 김영훈 on 3/20/25.
//

import UIKit
import Core
import Shared

protocol PrayRequestCellDelegate: AnyObject {
    func deleteItem(at cell: PrayRequestCollectionViewCell)
    func toggleIsPinned(at cell: PrayRequestCollectionViewCell)
}

final class PrayRequestCollectionViewCell: UICollectionViewCell {
    
    private let cellContainerView = CellContainerView()
    let categoryLabel = PaddedLabel()
    let titleLabel = UILabel()
    let prayItemTableView = UITableView(frame: .zero, style: .plain)
    let dateLabel = UILabel()
    let checkBox = CheckBox()
    let pinButton = UIButton()
    private let actionView = UIView()
    
    private var isSwiped = false
    private var originalCenter: CGPoint = .zero
    private let maxSwipeTranslation: CGFloat = 60
    
    weak var delegate: PrayRequestCellDelegate?
    
    var prayItems: [PrayItem] = []
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        clipsToBounds = true
        checkBox.isUserInteractionEnabled = false
        setupUI()
        setupSwipeGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetAction()
        delegate = nil
    }
    
    // MARK: Setups
    private func setupUI() {
        setupCategoryLabel()
        setupTitleLabel()
        setupPrayItemTableView()
        setupDateLabel()
        setupPinButton()
        setupActionView()
        
        backgroundColor = .clear
        selectedBackgroundView = UIView()
        
        contentView.addSubview(actionView)
        contentView.addSubview(cellContainerView)
        cellContainerView.addSubview(categoryLabel)
        cellContainerView.addSubview(titleLabel)
        cellContainerView.addSubview(dateLabel)
        cellContainerView.addSubview(checkBox)
        cellContainerView.addSubview(pinButton)
        cellContainerView.addSubview(prayItemTableView)
        
        actionView.translatesAutoresizingMaskIntoConstraints = false
        cellContainerView.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        prayItemTableView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        pinButton.translatesAutoresizingMaskIntoConstraints = false
        
        let innerPadding = Constants.innerPadding
        let scrolledCellBottomPadding = Constants.scrolledCellBottomPadding
        
        NSLayoutConstraint.activate([
            actionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            actionView.widthAnchor.constraint(equalToConstant: maxSwipeTranslation),
            actionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            actionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            cellContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            categoryLabel.leadingAnchor.constraint(equalTo: cellContainerView.leadingAnchor, constant: innerPadding),
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: cellContainerView.topAnchor, constant: innerPadding - 4), // Font 여백에 따른 조정
            
            dateLabel.trailingAnchor.constraint(equalTo: pinButton.leadingAnchor, constant: -4),
            dateLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            
            checkBox.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -innerPadding + 4), // Font 여백에 따른 조정
            checkBox.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            checkBox.heightAnchor.constraint(equalToConstant: 24),
            checkBox.widthAnchor.constraint(equalToConstant: 24),
            
            prayItemTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            prayItemTableView.leadingAnchor.constraint(equalTo: cellContainerView.leadingAnchor, constant: innerPadding),
            prayItemTableView.trailingAnchor.constraint(equalTo: cellContainerView.trailingAnchor, constant: -innerPadding),
            prayItemTableView.bottomAnchor.constraint(equalTo: cellContainerView.bottomAnchor, constant: -scrolledCellBottomPadding),
            
            pinButton.trailingAnchor.constraint(equalTo: checkBox.trailingAnchor),
            pinButton.bottomAnchor.constraint(equalTo: checkBox.bottomAnchor),
            pinButton.widthAnchor.constraint(equalTo: checkBox.widthAnchor),
            pinButton.heightAnchor.constraint(equalTo: checkBox.heightAnchor)
        ])
    }
    
    private func setupCategoryLabel() {
        categoryLabel.font = Shared.AppFonts.category
        categoryLabel.textColor = .white
        categoryLabel.textInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
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
    
    private func setupPinButton() {
        pinButton.setImage(UIImage(systemName: "pin"), for: .normal)
        pinButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            delegate?.toggleIsPinned(at: self)
        }, for: .touchUpInside)
    }
    
    private func setupActionView() {
        actionView.layer.maskedCorners = [
            .layerMaxXMinYCorner,
            .layerMaxXMaxYCorner
        ]
        actionView.layer.cornerRadius = 8
        actionView.clipsToBounds = true
        let button = UIButton()
        let image = UIImage(systemName: "trash")?
            .withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemRed
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            delegate?.deleteItem(at: self)
        }, for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        actionView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: actionView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: actionView.trailingAnchor),
            button.topAnchor.constraint(equalTo: actionView.topAnchor),
            button.bottomAnchor.constraint(equalTo: actionView.bottomAnchor)
        ])
    }
    
    private func setupSwipeGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        cellContainerView.addGestureRecognizer(panGesture)
    }
    
    // MARK: Gesture Actions
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: cellContainerView)
        switch gesture.state {
        case .began:
            originalCenter = cellContainerView.center
        case .changed:
            if isSwiped { // 이미 열려있으면 오른쪽으로만 밀어서 닫도록 허용
                if translation.x > 0 {
                    let limited = min(translation.x, maxSwipeTranslation)
                    cellContainerView.transform = CGAffineTransform(translationX: limited - maxSwipeTranslation, y: 0)
                }
            } else {
                // 열려있지 않으면 왼쪽으로만 허용
                if translation.x < 0 {
                    let limited = max(translation.x, -maxSwipeTranslation)
                    cellContainerView.transform = CGAffineTransform(translationX: limited, y: 0)
                }
            }
            
            updateCornerMask()
            
        case .ended, .cancelled:
            let threshold = maxSwipeTranslation / 2
            if isSwiped {
                // 열려있는 상태에서 오른쪽으로 절반 이상 밀면 닫힘
                if translation.x > threshold {
                    resetAction()
                } else {
                    openAction()
                }
            } else {
                // 닫힌 상태에서 왼쪽으로 충분히 밀면 열림
                if -translation.x > threshold {
                    openAction()
                } else {
                    resetAction()
                }
            }
        default:
            break
        }
    }
    
    private func openAction() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            cellContainerView.transform = CGAffineTransform(translationX: -maxSwipeTranslation, y: 0)
        }
        isSwiped = true
        updateCornerMask()
    }
    
    private func resetAction() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.cellContainerView.transform = .identity
        }
        isSwiped = false
        updateCornerMask(isSwiping: false)
    }
    
    private func updateCornerMask(isSwiping: Bool = true) {
        if isSwiping {
            cellContainerView.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMinXMaxYCorner
            ]
        } else {
            cellContainerView.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
            ]
        }
    }
    
    func configure(with prayRequest: PrayRequest) {
        categoryLabel.text = prayRequest.category.rawValue
        categoryLabel.backgroundColor = UIColor(named: prayRequest.category.colorIdentifier, in: .module, compatibleWith: nil)
        
        titleLabel.attributedText = NSAttributedString(
            string: prayRequest.title,
            attributes: Shared.FontTextAttributes.titleTextAttributes
        )
        
        dateLabel.text = DateFormatUtil.shortWithDayFormatter.string(from: prayRequest.date)
        
        prayItems = prayRequest.items
        
        DispatchQueue.main.async { [weak self] in
            self?.prayItemTableView.reloadData()
        }
    }
    
    func setChecked(_ isChecked: Bool) {
        checkBox.isChecked = isChecked
    }
    
    func setDeleteMode(_ enabled: Bool) {
        enabled ? enableDeleteMode() : disableDeleteMode()
    }
    
    func setPinButton(_ isPinned: Bool) {
        let image = UIImage(systemName: isPinned ? "pin.fill" : "pin")
        pinButton.imageView?.image = image
    }
    
    private func enableDeleteMode() {
        checkBox.isHidden = false
        pinButton.isHidden = true
    }
    
    private func disableDeleteMode() {
        checkBox.isHidden = true
        checkBox.isChecked = false
        pinButton.isHidden = false
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

extension PrayRequestCollectionViewCell: UIGestureRecognizerDelegate {
    // 수평 제스처만 허용
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = pan.velocity(in: self)
            return abs(velocity.x) > abs(velocity.y)
        }
        return true
    }
    
    // CollectionView 스크롤과 동시에 허용
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
