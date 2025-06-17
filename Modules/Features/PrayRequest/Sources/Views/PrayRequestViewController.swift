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
    enum Section {
        case main
    }
    
    let viewModel: PrayRequestViewModelProtocol
    private var searchTextSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    let titleBarLabelItem = UIBarButtonItem()
    let editBarLabel = UILabel()
    let plusBarButtonItem = UIBarButtonItem()
    let deleteBarButtonItem = UIBarButtonItem()
    let completeBarButtonItem = UIBarButtonItem()
    let cancelBarButtonItem = UIBarButtonItem()
    private let categorySelectorView = CategorySelectorView(categories: ["전체"] + PrayCategory.allCases.map { $0.rawValue }, isUnderlineVisible: true)
    let praySearchBar = CustomSearchBar()
    private var dataSource: UICollectionViewDiffableDataSource<Section, PrayRequest>?
    let prayRequestCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let emptyView = UIView()
    private let emptyImageView = UIImageView()
    private let indicatorView = IndicatorView()
    
    var isDeleteMode = false
    var deleteIds = [String]()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupUI()
        setupDataSource()
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
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNavBarTapGesture()
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: any UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.prayRequestCollectionView.collectionViewLayout.invalidateLayout()
        })
    }
    
    // MARK: Setups
    private func setupNavigationBar() {
        setupTitleBarLabelItem()
        setupEditBarLabel()
        setupPlusBarButtonItem()
        setupDeleteBarButtonItem()
        setupCompleteBarButtonItem()
        setupCancelBarButtonItem()
        
        navigationItem.leftBarButtonItem = titleBarLabelItem
        navigationItem.rightBarButtonItems = [
            deleteBarButtonItem,
            plusBarButtonItem
        ]
    }
    
    private func setupTitleBarLabelItem() {
        let label = UILabel()
        label.attributedText = NSAttributedString(
            string: "기도 제목",
            attributes: Shared.FontTextAttributes.navBarLeftTitleAttributes
        )
        label.font = Shared.AppFonts.navBarLeftTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        
        titleBarLabelItem.customView = label
    }
    
    private func setupEditBarLabel() {
        editBarLabel.attributedText = NSAttributedString(
            string: "편집",
            attributes: Shared.FontTextAttributes.navBarCenterTitleAttributes
        )
        editBarLabel.font = Shared.AppFonts.navBarCenterTitle
        editBarLabel.translatesAutoresizingMaskIntoConstraints = false
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
    
    private func setupCancelBarButtonItem() {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.titleLabel?.font = Shared.AppFonts.navBarButtonText
        cancelBarButtonItem.customView = button
    }
    
    private func setupUI() {
        setupPrayRequestCollectionVIew()
        setupEmptyView()
        
        view.backgroundColor = UIColor(named: "BackgroundColor")
        
        view.addSubview(categorySelectorView)
        view.addSubview(praySearchBar)
        view.addSubview(prayRequestCollectionView)
        view.addSubview(emptyView)
        view.addSubview(indicatorView)
        
        categorySelectorView.translatesAutoresizingMaskIntoConstraints = false
        praySearchBar.translatesAutoresizingMaskIntoConstraints = false
        prayRequestCollectionView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        let sidePadding = Constants.sidePadding
        let scrollBarPadding = Constants.scrollBarPadding
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
            prayRequestCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -sidePadding + scrollBarPadding),
            prayRequestCollectionView.topAnchor.constraint(equalTo: praySearchBar.bottomAnchor, constant: innerPadding),
            prayRequestCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            emptyView.leadingAnchor.constraint(equalTo: prayRequestCollectionView.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: prayRequestCollectionView.trailingAnchor),
            emptyView.topAnchor.constraint(equalTo: prayRequestCollectionView.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: prayRequestCollectionView.bottomAnchor),
            
            indicatorView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
        ])
    }
    
    private func setupPrayRequestCollectionVIew() {
        prayRequestCollectionView.backgroundColor = .clear
        prayRequestCollectionView.register(PrayRequestCollectionViewCell.self, forCellWithReuseIdentifier: "PrayRequestCell")
    }
    
    private func setupEmptyView() {
        let label = UILabel()
        label.text = "기도 제목이 없습니다\n상단의 +버튼으로 추가할 수 있습니다"
        label.font = AppFonts.body
        label.textAlignment = .center
        label.numberOfLines = 0
        
        emptyImageView.image = UIImage(named: "EmptyImage", in: .module, with: nil)
        emptyImageView.contentMode = .scaleAspectFit
        
        emptyView.addSubview(emptyImageView)
        emptyView.addSubview(label)
        emptyView.isHidden = true
        
        emptyImageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyImageView.widthAnchor.constraint(equalTo: emptyView.widthAnchor, multiplier: 0.7),
            emptyImageView.heightAnchor.constraint(equalTo: emptyImageView.widthAnchor),
            emptyImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -56),
            
            label.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            label.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor)
        ])
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, PrayRequest>(collectionView: prayRequestCollectionView) { [weak self] collectionView, indexPath, item in
            guard let self = self else { return UICollectionViewCell() }
                    
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrayRequestCell", for: indexPath) as! PrayRequestCollectionViewCell
            let prayRequest = viewModel.prayRequests[indexPath.row]
            cell.configure(with: prayRequest)
            cell.setChecked(self.deleteIds.contains(item.uuid.uuidString))
            cell.setDeleteMode(self.isDeleteMode)
            cell.setPinButton(item.isPinned)
            cell.delegate = self
            return cell
        }
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
        
        // CancelButton
        if let button = cancelBarButtonItem.customView as? UIButton {
            button.addAction(UIAction { [weak self] _ in
                self?.cancelButtonTapped()
            }, for: .touchUpInside)
        }
    }
    
    private func setupDelegate() {
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
    
    private func removeNavBarTapGesture() {
        if let recognizers = navigationController?.navigationBar.gestureRecognizers {
            recognizers
                .filter { $0.name == "NavBarKeyboardDismiss" }
                .forEach { navigationController?.navigationBar.removeGestureRecognizer($0) }
        }
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
        isDeleteMode = true
        for case let cell as PrayRequestCollectionViewCell in prayRequestCollectionView.visibleCells {
            cell.setDeleteMode(true)
        }
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            navigationItem.leftBarButtonItem = cancelBarButtonItem
            navigationItem.rightBarButtonItems = [
                completeBarButtonItem
            ]
            navigationItem.titleView = editBarLabel
        }
    }
    
    private func completeButtonTapped() {
        if deleteIds.isEmpty {
            isDeleteMode = false
            for case let cell as PrayRequestCollectionViewCell in prayRequestCollectionView.visibleCells {
                cell.setDeleteMode(false)
            }
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let self = self else { return }
                navigationItem.leftBarButtonItem = titleBarLabelItem
                navigationItem.rightBarButtonItems = [
                    deleteBarButtonItem,
                    plusBarButtonItem
                ]
                navigationItem.titleView = nil
            }
        } else {
            presentDeleteAlert()
        }
    }
    
    private func cancelButtonTapped() {
        Task { [weak self] in
            guard let self = self else { return }
            
            deleteIds = []
            isDeleteMode = false
            
            for case let cell as PrayRequestCollectionViewCell in prayRequestCollectionView.visibleCells {
                cell.setDeleteMode(false)
            }
            
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let self = self else { return }
                navigationItem.leftBarButtonItem = titleBarLabelItem
                navigationItem.rightBarButtonItems = [
                    deleteBarButtonItem,
                    plusBarButtonItem
                ]
                navigationItem.titleView = nil
            }
        }
    }
    
    // MARK: Gesture Actions
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: Bindings
    private func bindViewModel() {
        viewModel.prayRequestsPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.applySnapshot()
                    self.emptyView.isHidden = !self.viewModel.prayRequests.isEmpty
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
    
    private func fetchData() {
        Task { [weak self] in
            guard let self = self else { return }
            indicatorView.startAnimating()
            do {
                try await viewModel.fetchPrayRequests()
                
                viewModel.updateSelectedResults(with: categorySelectorView.selectedIndex)
                viewModel.updateSearchedResults(with: praySearchBar.text ?? "")
            } catch {
                presentErrorAlert(for: error, title: "불러오기 실패")
            }
            indicatorView.stopAnimating()
        }
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PrayRequest>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.prayRequests)
        dataSource?.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func presentDeleteAlert() {
        let alert = UIAlertController(
            title: "항목 삭제",
            message: "삭제 항목은 되돌릴 수 없습니다.\n\(deleteIds.count)개 항목을 삭제하시겠습니까?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.deletePrayRequests()
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
    
    func deletePrayRequests() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                self.indicatorView.startAnimating()
                try await self.viewModel.deletePrayRequests(prayRequestIds: self.deleteIds)
                for case let cell as PrayRequestCollectionViewCell in self.prayRequestCollectionView.visibleCells {
                    cell.setDeleteMode(false)
                }
                self.deleteIds.removeAll()
                self.isDeleteMode = false
                
                UIView.animate(withDuration: 0.2) { [weak self] in
                    guard let self = self else { return }
                    navigationItem.leftBarButtonItem = titleBarLabelItem
                    navigationItem.rightBarButtonItems = [
                        deleteBarButtonItem,
                        plusBarButtonItem
                    ]
                    navigationItem.titleView = nil
                }
            }
            catch {
                presentErrorAlert(for: error, title: "삭제 실패")
            }
            indicatorView.stopAnimating()
        }
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
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
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

extension PrayRequestViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PrayRequestCollectionViewCell,
        let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        cell.setChecked(deleteIds.contains(item.uuid.uuidString))
        cell.setDeleteMode(isDeleteMode)
        cell.setPinButton(item.isPinned)
        cell.delegate = self
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        
        // 삭제 모드일 때 체크박스 토글
        if isDeleteMode, let cell = collectionView.cellForItem(at: indexPath) as? PrayRequestCollectionViewCell {
            
            let id = item.uuid.uuidString
            
            if deleteIds.contains(id) {
                deleteIds.removeAll { $0 == id }
                cell.setChecked(false)
            } else {
                deleteIds.append(id)
                cell.setChecked(true)
            }
        } else { // 기본 모드일 때 상세보기
            let selectedPrayRequest = viewModel.prayRequests[indexPath.row]
            let prayRequestDetailViewController = PrayRequestDetailViewController(with: selectedPrayRequest, viewModel: viewModel)
            prayRequestDetailViewController.delegate = self
            self.navigationController?.pushViewController(prayRequestDetailViewController, animated: true)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameWidth = collectionView.frame.width
        let width = frameWidth < 600 ? frameWidth - Constants.scrollBarPadding : (frameWidth - Constants.scrollBarPadding - Constants.innerPadding) / 2
        return CGSize(width: width, height: 110)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.innerPadding
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.innerPadding
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {

        let frameWidth = collectionView.frame.width

        // 현재 셀 너비 계산 로직과 동일하게 맞춤
        let itemWidth: CGFloat
        let numberOfItemsInRow: Int

        if frameWidth < 600 {
            itemWidth = frameWidth - Constants.scrollBarPadding
            numberOfItemsInRow = 1
        } else {
            itemWidth = (frameWidth - Constants.scrollBarPadding - Constants.innerPadding) / 2
            numberOfItemsInRow = 2
        }

        let totalItemWidth = CGFloat(numberOfItemsInRow) * itemWidth
        let totalSpacingWidth = CGFloat(max(numberOfItemsInRow - 1, 0)) * Constants.innerPadding

        let totalContentWidth = totalItemWidth + totalSpacingWidth

        // 남는 공간을 좌우 inset으로 나눔
        let inset = max((frameWidth - totalContentWidth), 0)

        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: inset)
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

extension PrayRequestViewController: PrayRequestCellDelegate {

    func deleteItem(at cell: PrayRequestCollectionViewCell) {
        guard let indexPath = prayRequestCollectionView.indexPath(for: cell),
              let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        let id = item.uuid.uuidString

        Task { [weak self] in
            guard let self = self else { return }
            do {
                indicatorView.startAnimating()
                try await viewModel.deletePrayRequest(prayRequestId: item.uuid)
                
                deleteIds.removeAll { $0 == id }
            } catch {
                presentErrorAlert(for: error, title: "삭제 실패")
            }
            indicatorView.stopAnimating()
        }
    }
    
    func toggleIsPinned(at cell: PrayRequestCollectionViewCell) {
        guard let indexPath = prayRequestCollectionView.indexPath(for: cell),
              let item = dataSource?.itemIdentifier(for: indexPath) else { return }
        let id = item.uuid.uuidString
        let toggledIsPinned = !item.isPinned
        
        Task { [weak self] in
            guard let self = self else { return }
            do {
                indicatorView.startAnimating()
                try await viewModel.setIsPinned(prayRequestId: id, isPinned: toggledIsPinned)
                cell.setPinButton(toggledIsPinned)
                item.isPinned = toggledIsPinned
            } catch {
                presentErrorAlert(for: error, title: "상단 고정 실패")
            }
            indicatorView.stopAnimating()
        }
    }
}

extension PrayRequestViewController: SetIsPinnedDelegate {
    func setIsPinned(prayRequest: PrayRequest) {
        guard let indexPath = dataSource?.indexPath(for: prayRequest), let cell = prayRequestCollectionView.cellForItem(at: indexPath) as? PrayRequestCollectionViewCell else { return }
        cell.setPinButton(prayRequest.isPinned)

    }
}
