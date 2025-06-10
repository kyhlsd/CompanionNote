//
//  PrayRequestViewModel.swift
//  Features
//
//  Created by 김영훈 on 6/8/25.
//

import Foundation
import Core

final public class PrayRequestViewModel: PrayRequestViewModelProtocol {
    let userIdentifier: String?
    let prayRequestUseCase: PrayRequestUseCase
    
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
    
    public func fetchPrayRequests() async throws -> [Core.PrayRequest] {
        guard let userIdentifier = userIdentifier else { return [] }
        return try await prayRequestUseCase.fetchPrayRequests(userId: userIdentifier)
    }
}

public protocol PrayRequestViewModelProtocol {
    func addPrayRequest(prayRequest: PrayRequest) async throws
    func fetchPrayRequests() async throws -> [PrayRequest]
}
