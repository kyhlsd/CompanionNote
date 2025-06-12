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
    @Published public var prayRequests = [PrayRequest]()
    public var prayRequestsPublisher: Published<[PrayRequest]>.Publisher { $prayRequests }
    @Published public var shouldFetch = true
    public var shouldFetchPublisher: Published<Bool>.Publisher { $shouldFetch }
    
    public init() {
        self.userIdentifier = UserDefaults.standard.string(forKey: "userId")
        let firestoreService = FirestoreService()
        let prayRequestRepository = PrayRequestRepositoryImpl(firestoreService: firestoreService)
        self.prayRequestUseCase = DefaultPrayRequestUseCase(repository: prayRequestRepository)
    }
    
    public func addPrayRequest(prayRequest: PrayRequest) async throws {
        guard let userIdentifier = userIdentifier else { return }
        try await prayRequestUseCase.addPrayRequest(userId: userIdentifier, prayRequest: prayRequest)
    }
    
    public func fetchPrayRequests() async throws {
        guard let userIdentifier = userIdentifier else { return }
        let fetched = try await prayRequestUseCase.fetchPrayRequests(userId: userIdentifier)
        totalPrayRequests = fetched
//        prayRequests = fetched.sorted { $0.date > $1.date }
    }
    
    public func updatePrayRequest(prayRequest: PrayRequest) async throws {
        guard let userIdentifier = userIdentifier else { return }
        try await prayRequestUseCase.updatePrayRequest(userId: userIdentifier, prayRequest: prayRequest)
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
    }
    
    public func activeFetchStatus() {
        shouldFetch.toggle()
    }
    
    public func updateSelectedResults(with index: Int) {
        let categories = ["전체"] + PrayCategory.allCases.map { $0.rawValue }
        guard categories.count > index, index >= 0 else { return }
        
        if index == 0 {
            selectedPrayRequests = totalPrayRequests
            return
        }
        
        let categoryRawValue = categories[index]
        let selected = totalPrayRequests.filter { $0.category.rawValue == categoryRawValue }
        selectedPrayRequests = selected
    }
    
    public func updateSearchedResults(with searchText: String) {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            prayRequests = selectedPrayRequests.sorted { $0.date > $1.date }
                    return
        }
        
        let filtered = selectedPrayRequests.filter {
            SearchPrayRequestUtils.matches(target: $0, keyword: searchText)
        }
        
        prayRequests = filtered.sorted { $0.date > $1.date }
    }
}

public protocol PrayRequestViewModelProtocol {
    func addPrayRequest(prayRequest: PrayRequest) async throws
    func fetchPrayRequests() async throws
    func updatePrayRequest(prayRequest: PrayRequest) async throws
    func deletePrayRequests(prayRequestIds: [String]) async throws
    var prayRequests: [PrayRequest] { get }
    var prayRequestsPublisher: Published<[PrayRequest]>.Publisher { get }
    func activeFetchStatus()
    var shouldFetchPublisher: Published<Bool>.Publisher { get }
    func updateSelectedResults(with index: Int)
    func updateSearchedResults(with searchText: String)
}
