//
//  PrayRequestViewController.swift
//  Features
//
//  Created by 김영훈 on 3/20/25.
//

import UIKit
import Core
import Shared
import Combine

public class PrayRequestViewController: UIViewController {
    
    let viewModel: PrayRequestViewModelProtocol
    private var searchTextSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    let plusBarButtonItem = UIBarButtonItem()
    let deleteBarButtonItem = UIBarButtonItem()
    let completeBarButtonItem = UIBarButtonItem()
    private let categorySelectorView = CategorySelectorView(categories: ["전체"] + PrayCategory.allCases.map { $0.rawValue }, isUnderlineVisible: true)
    let praySearchBar = CustomSearchBar()
    let prayRequestCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var isDeleteMode = false
    var deleteIds = [String]()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupUI()
        setupButtonActions()
        setupDelegate()
        setupTapGesture()
        setupBinding()
    }
    
    public init(viewModel: PrayRequestViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarTapGesture()
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
        praySearchBar.delegate = self
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
    
    private func setupBinding() {
        bindViewModel()
        bindSearchBar()
    }
    
    // MARK: Button Actions
    private func plusButtonTapped() {
        let addPrayRequestViewController = AddPrayRequestViewController(viewModel: viewModel)
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
        Task {
            do {
                if !deleteIds.isEmpty {
                    try await viewModel.deletePrayRequests(prayRequestIds: deleteIds)
                }
                deleteIds = []
                
                isDeleteMode = false
                navigationItem.rightBarButtonItems = [
                    deleteBarButtonItem,
                    plusBarButtonItem
                ]
                
                viewModel.activeFetchStatus()
            } catch {
                presentErrorAlert(for: error, title: "삭제 실패")
            }
        }
    }
    
    // MARK: Gesture Actions
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func fetchData() {
        Task {
            do {
                try await viewModel.fetchPrayRequests()
                
                viewModel.updateSelectedResults(with: categorySelectorView.selectedIndex)
                viewModel.updateSearchedResults(with: praySearchBar.text ?? "")
            } catch {
                presentErrorAlert(for: error, title: "불러오기 실패")
            }
        }
    }
    
    // MARK: Bindings
    private func bindViewModel() {
        viewModel.prayRequestsPublisher
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.prayRequestCollectionView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        viewModel.shouldFetchPublisher
            .sink { [weak self] _ in
                self?.fetchData()
            }
            .store(in: &cancellables)
    }
    
    private func bindSearchBar() {
        searchTextSubject
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.viewModel.updateSearchedResults(with: searchText)
            }
            .store(in: &cancellables)
    }
    
    // MARK: Error Alert
    func presentErrorAlert(for error: Error, title: String) {
        let message = FirestoreErrorMapper.message(for: error)
        
        let alert = UIAlertController(
            title: nil,
            message: message,
            preferredStyle: .alert
        )
        
        let title = NSAttributedString(
            string: title,
            attributes: [
                .foregroundColor: UIColor.red,
                .font: UIFont.boldSystemFont(ofSize: 17)
            ]
        )
        
        alert.setValue(title, forKey: "attributedTitle")
        alert.addAction(UIAlertAction(title: "닫기", style: .default))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
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
        viewModel.prayRequests.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrayRequestCell", for: indexPath) as! PrayRequestCollectionViewCell
        let prayRequest = viewModel.prayRequests[indexPath.row]
        cell.configure(with: prayRequest)
        cell.checkBox.isUserInteractionEnabled = false
        if isDeleteMode, let id = cell.getPrayRequestUUID()?.uuidString {
            cell.checkBox.isChecked = deleteIds.contains(id)
            cell.enableDeleteMode()
        } else {
            cell.disableDeleteMode()
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PrayRequestCollectionViewCell else { return }

        if isDeleteMode, let id = cell.getPrayRequestUUID()?.uuidString {
            cell.checkBox.isChecked = deleteIds.contains(id)
            cell.enableDeleteMode()
        } else {
            cell.disableDeleteMode()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 삭제 모드일 때 체크박스 토글
        if isDeleteMode,
           let cell = collectionView.cellForItem(at: indexPath) as? PrayRequestCollectionViewCell,
           let id = cell.getPrayRequestUUID()?.uuidString {
            
            cell.toggleCheckBoxState()
            
            if deleteIds.contains(id) {
                deleteIds.removeAll { $0 == id }
            } else {
                deleteIds.append(id)
            }
        } else { // 기본 모드일 때 상세보기
            let selectedPrayRequest = viewModel.prayRequests[indexPath.row]
            let prayRequestDetailViewController = PrayRequestDetailViewController(with: selectedPrayRequest, viewModel: viewModel)
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
        viewModel.updateSelectedResults(with: index)
        viewModel.updateSearchedResults(with: praySearchBar.text ?? "")
    }
}

extension PrayRequestViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        searchTextSubject.send(trimmed)
    }
}
