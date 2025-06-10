//
//  PrayRequestViewModel.swift
//  Features
//
//  Created by 김영훈 on 6/8/25.
//

import Foundation
import Core

final class PrayRequestViewModel: PrayRequestViewModelProtocol {
    let userIdentifier: String?
    let prayRequestUseCase: PrayRequestUseCase
    
    init() {
        self.userIdentifier = UserDefaults.standard.string(forKey: "userId")
        let firestoreService = FirestoreService()
        let prayRequestRepository = PrayRequestRepositoryImpl(firestoreService: firestoreService)
        self.prayRequestUseCase = DefaultPrayRequestUseCase(repository: prayRequestRepository)
    }
    
    func addPrayRequest(prayRequest: PrayRequest) async throws {
        guard let userIdentifier = userIdentifier else { return }
        try await prayRequestUseCase.addPrayRequest(userId: userIdentifier, prayRequest: prayRequest)
    }
}

protocol PrayRequestViewModelProtocol {
    func addPrayRequest(prayRequest: PrayRequest) async throws
}
