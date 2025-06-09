//
//  PrayRequestViewController.swift
//  Features
//
//  Created by 김영훈 on 3/20/25.
//

import UIKit
import Core
import Shared

final public class PrayRequestViewController: UIViewController {
    
    let plusBarButtonItem = UIBarButtonItem()
    let deleteBarButtonItem = UIBarButtonItem()
    let completeBarButtonItem = UIBarButtonItem()
    private let categorySelectorView = CategorySelectorView(categories: ["전체"] + PrayCategory.allCases.map { $0.rawValue }, isUnderlineVisible: true)
    private let praySearchBar = CustomSearchBar()
    let prayRequestCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let prayRequests = PrayRequest.dummyDatas
    var isDeleteMode = false
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupUI()
        setupButtonActions()
        setupDelegate()
        setupTapGesture()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarTapGesture()
        //TODO: firestore snapshot을 쓴다면 안해도 될지도. 테스트
        prayRequestCollectionView.reloadData()
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.prayRequestCollectionView.collectionViewLayout.invalidateLayout()
        })
    }
    
    // MARK: Setups
    private func setupNavigationBar() {
        setupPlusBarButtonItem()
        setupDeleteBarButtonItem()
        setupCompleteBarButtonItem()
        
        let titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedString(
            string: "기도 제목",
            attributes: Shared.FontTextAttributes.navBarTextAttributes
        )
        titleLabel.font = Shared.AppFonts.navBarTitle
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItems = [
            deleteBarButtonItem,
            plusBarButtonItem
        ]
    }
    
    private func setupPlusBarButtonItem() {
        let button = UIButton()
        let image = UIImage(systemName: "plus")?
            .withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
        button.setImage(image, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        let navBarButtonSize = Shared.Constants.navBarButtonSize
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: navBarButtonSize),
            button.heightAnchor.constraint(equalToConstant: navBarButtonSize)
        ])
        plusBarButtonItem.customView = button
    }
    
    private func setupDeleteBarButtonItem() {
        let button = UIButton()
        let image = UIImage(systemName: "trash")?
            .withConfiguration(UIImage.SymbolConfiguration(weight: .regular))
        button.setImage(image, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        let navBarButtonSize = Shared.Constants.navBarButtonSize
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: navBarButtonSize),
            button.heightAnchor.constraint(equalToConstant: navBarButtonSize)
        ])
        deleteBarButtonItem.customView = button
    }
    
    private func setupCompleteBarButtonItem() {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = Shared.AppFonts.navBarButtonText
        completeBarButtonItem.customView = button
    }
    
    private func setupUI() {
        setupPrayRequestCollectionVIew()
        
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        view.addSubview(categorySelectorView)
        view.addSubview(praySearchBar)
        view.addSubview(prayRequestCollectionView)
        
        categorySelectorView.translatesAutoresizingMaskIntoConstraints = false
        praySearchBar.translatesAutoresizingMaskIntoConstraints = false
        prayRequestCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let sidePadding = Constants.sidePadding
        let innerPadding = Constants.innerPadding
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            categorySelectorView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            categorySelectorView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: sidePadding),
            categorySelectorView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -sidePadding),
            categorySelectorView.heightAnchor.constraint(equalToConstant: 32),
            
            praySearchBar.topAnchor.constraint(equalTo: categorySelectorView.bottomAnchor, constant: innerPadding),
            praySearchBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: sidePadding),
            praySearchBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -sidePadding),
            
            prayRequestCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: sidePadding),
            prayRequestCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -sidePadding),
            prayRequestCollectionView.topAnchor.constraint(equalTo: praySearchBar.bottomAnchor, constant: innerPadding),
            prayRequestCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    
    private func setupPrayRequestCollectionVIew() {
        prayRequestCollectionView.backgroundColor = .clear
        prayRequestCollectionView.register(PrayRequestCollectionViewCell.self, forCellWithReuseIdentifier: "PrayRequestCell")
    }
    
    private func setupButtonActions() {
        // Plus Button
        if let button = plusBarButtonItem.customView as? UIButton {
            button.addAction(UIAction { [weak self] _ in
                self?.plusButtonTapped()
            }, for: .touchUpInside)
        }
        
        // DeleteButton
        if let button = deleteBarButtonItem.customView as? UIButton {
            button.addAction(UIAction { [weak self] _ in
                self?.deleteButtonTapped()
            }, for: .touchUpInside)
        }
        
        // CompleteButton
        if let button = completeBarButtonItem.customView as? UIButton {
            button.addAction(UIAction { [weak self] _ in
                self?.completeButtonTapped()
            }, for: .touchUpInside)
        }
    }
    
    private func setupDelegate() {
        prayRequestCollectionView.dataSource = self
        prayRequestCollectionView.delegate = self
        categorySelectorView.selectCategoryDelegate = self
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupNavBarTapGesture() {
        // 중복 추가 방지를 위해 먼저 제거
        if let recognizers = navigationController?.navigationBar.gestureRecognizers {
            recognizers
                .filter { $0.name == "NavBarKeyboardDismiss" }
                .forEach { navigationController?.navigationBar.removeGestureRecognizer($0) }
        }
        
        let navBarTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        navBarTapGesture.name = "NavBarKeyboardDismiss"
        navBarTapGesture.cancelsTouchesInView = false
        navigationController?.navigationBar.addGestureRecognizer(navBarTapGesture)
    }
    
    // MARK: Button Actions
    private func plusButtonTapped() {
        let addPrayRequestViewController = AddPrayRequestViewController(viewModel: PrayRequestViewModel())
        self.navigationController?.pushViewController(addPrayRequestViewController, animated: true)
    }
    
    private func deleteButtonTapped() {
        for case let cell as PrayRequestCollectionViewCell in prayRequestCollectionView.visibleCells {
            cell.enableDeleteMode()
        }
        isDeleteMode = true
        navigationItem.rightBarButtonItems = [
            completeBarButtonItem
        ]
    }
    
    private func completeButtonTapped() {
        //TODO: 전체 순회할 필요없이 체크 박스 선택 시 뷰모델 배열에 uuid 추가하도록
        for case let cell as PrayRequestCollectionViewCell in prayRequestCollectionView.visibleCells {
            if cell.getCheckedState(), let uuid = cell.getPrayRequestUUID() {
                print(uuid.uuidString)
            }
        }
        isDeleteMode = false
        prayRequestCollectionView.reloadData()
        navigationItem.rightBarButtonItems = [
            deleteBarButtonItem,
            plusBarButtonItem
        ]
    }
    
    // MARK: Gesture Actions
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: Extensions
extension PrayRequestViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // 터치된 뷰가 UISearchBar 또는 내부 구성 요소라면 동작하지 않도록
        if let touchedView = touch.view, touchedView.isDescendant(of: praySearchBar) {
            return false
        }
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // 터치 이벤트를 동시에 처리하도록 허용
    }
}

extension PrayRequestViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        prayRequests.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrayRequestCell", for: indexPath) as! PrayRequestCollectionViewCell
        let prayRequest = prayRequests[indexPath.row]
        cell.configure(with: prayRequest)
        if isDeleteMode {
            cell.enableDeleteMode()
        } else {
            cell.disableDeleteMode()
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 삭제 모드일 때 체크박스 토글
        if isDeleteMode {
            if let cell = collectionView.cellForItem(at: indexPath) as? PrayRequestCollectionViewCell {
                cell.toggleCheckBoxState()
            }
        } else { // 기본 모드일 때 상세보기
            let selectedPrayRequest = prayRequests[indexPath.row]
            let prayRequestDetailViewController = PrayRequestDetailViewController(with: selectedPrayRequest)
            self.navigationController?.pushViewController(prayRequestDetailViewController, animated: true)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameWidth = collectionView.frame.width
        let width = frameWidth < 600 ? frameWidth : (frameWidth - Constants.innerPadding) / 2
        return CGSize(width: width, height: 106)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.innerPadding
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.innerPadding
    }
}

extension PrayRequestViewController: SelectCategoryDelegate {
    public func didSelectCategory(_ index: Int) {
        let categories = ["전체"] + PrayCategory.allCases.map { $0.rawValue }
        print(categories[index])
    }
}
