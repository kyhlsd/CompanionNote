//
//  PrayRequestViewModel.swift
//  Features
//
//  Created by 김영훈 on 6/8/25.
//

import Foundation
import Core
import Combine

final public class PrayRequestViewModel: PrayRequestViewModelProtocol {
    let userIdentifier: String?
    let prayRequestUseCase: PrayRequestUseCase
    
    private var totalPrayRequests = [PrayRequest]()
    private var selectedPrayRequests = [PrayRequest]()
    private var searchedPrayRequests = [PrayRequest]()
    @Published public var filteredPrayRequests = [PrayRequest]()
    public var prayRequestsPublisher: Published<[PrayRequest]>.Publisher { $filteredPrayRequests }
    @Published public var shouldUpdate = true
    public var shouldUpdatePublisher: Published<Bool>.Publisher { $shouldUpdate }
    
    public init() {
        self.userIdentifier = UserDefaults.standard.string(forKey: "userId")
        let firestoreService = FirestoreService()
        let prayRequestRepository = PrayRequestRepositoryImpl(firestoreService: firestoreService)
        self.prayRequestUseCase = DefaultPrayRequestUseCase(repository: prayRequestRepository)
    }
    
    public func addPrayRequest(prayRequest: PrayRequest) async throws {
        guard let userIdentifier = userIdentifier else { return }
        try await prayRequestUseCase.addPrayRequest(userId: userIdentifier, prayRequest: prayRequest)
        totalPrayRequests.append(prayRequest)
    }
    
    public func fetchPrayRequests() async throws {
        guard let userIdentifier = userIdentifier else { return }
        let fetched = try await prayRequestUseCase.fetchPrayRequests(userId: userIdentifier)
        totalPrayRequests = fetched
    }
    
    public func updatePrayRequest(prayRequest: PrayRequest) async throws {
        guard let userIdentifier = userIdentifier else { return }
        try await prayRequestUseCase.updatePrayRequest(userId: userIdentifier, prayRequest: prayRequest)
        if let index = totalPrayRequests.firstIndex(where: { $0 == prayRequest}) {
            totalPrayRequests[index] = prayRequest
        }
        if let index = filteredPrayRequests.firstIndex(where: { $0 == prayRequest }) {
            filteredPrayRequests[index] = prayRequest
        }
    }
    
    public func deletePrayRequests(prayRequestIds: [String]) async throws {
        guard let userIdentifier = userIdentifier else { return }
        try await withThrowingTaskGroup(of: Void.self) { group in
            for id in prayRequestIds {
                group.addTask {
                    try await self.prayRequestUseCase.deletePrayRequest(userId: userIdentifier, document: id)
                }
            }
            try await group.waitForAll()
        }
        totalPrayRequests.removeAll { prayRequestIds.contains($0.uuid.uuidString) }
    }
    
    public func deletePrayRequest(prayRequestId: UUID) async throws {
        guard let userIdentifier = userIdentifier else { return }
        try await self.prayRequestUseCase.deletePrayRequest(userId: userIdentifier, document: prayRequestId.uuidString)
        totalPrayRequests.removeAll { $0.uuid == prayRequestId }
    }
    
    public func setIsPinned(prayRequestId: UUID, isPinned: Bool) async throws {
        guard let userIdentifier = userIdentifier else { return }
        try await self.prayRequestUseCase.updatePrayRequestFields(userId: userIdentifier, itemId: prayRequestId.uuidString, data: ["isPinned": isPinned])
        if let index = totalPrayRequests.firstIndex(where: { $0.uuid == prayRequestId}) {
            totalPrayRequests[index].isPinned = isPinned
        }
        if let index = filteredPrayRequests.firstIndex(where: { $0.uuid == prayRequestId}) {
            filteredPrayRequests[index].isPinned = isPinned
        }
    }
    
    public func activeUpdateStatus() {
        shouldUpdate.toggle()
    }
    
    public func updateSelectedResults(with index: Int) {
        let categories = ["전체"] + PrayCategory.allCases.map { $0.rawValue }
        guard categories.count > index, index >= 0 else { return }
        
        if index == 0 {
            selectedPrayRequests = totalPrayRequests
            return
        }
        
        let categoryRawValue = categories[index]
        selectedPrayRequests = totalPrayRequests.filter { $0.category.rawValue == categoryRawValue }
    }
    
    public func updateSearchedResults(with searchText: String) {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            searchedPrayRequests = totalPrayRequests
                    return
        }
        
        searchedPrayRequests = totalPrayRequests.filter {
            SearchPrayRequestUtils.matches(target: $0, keyword: searchText)
        }
    }
    
    public func sortPrayRequests() {
        filteredPrayRequests.sort { sortCondition(firstItem: $0, secondItem: $1) }
    }
    
    private func sortCondition(firstItem: PrayRequest, secondItem: PrayRequest) -> Bool {
        if firstItem.isPinned == secondItem.isPinned {
            return firstItem.date > secondItem.date
        } else {
            return firstItem.isPinned && !secondItem.isPinned
        }
    }
    
    public func updatePrayRequests() {
        filteredPrayRequests = searchedPrayRequests.filter { selectedPrayRequests.contains($0) }
            .sorted { sortCondition(firstItem: $0, secondItem: $1)}
    }
}

public protocol PrayRequestViewModelProtocol {
    func addPrayRequest(prayRequest: PrayRequest) async throws
    func fetchPrayRequests() async throws
    func updatePrayRequest(prayRequest: PrayRequest) async throws
    func deletePrayRequests(prayRequestIds: [String]) async throws
    func deletePrayRequest(prayRequestId: UUID) async throws
    func setIsPinned(prayRequestId: UUID, isPinned: Bool) async throws
    var filteredPrayRequests: [PrayRequest] { get set }
    var prayRequestsPublisher: Published<[PrayRequest]>.Publisher { get }
    func activeUpdateStatus()
    var shouldUpdatePublisher: Published<Bool>.Publisher { get }
    func updateSelectedResults(with index: Int)
    func updateSearchedResults(with searchText: String)
    func sortPrayRequests()
    func updatePrayRequests()
}
