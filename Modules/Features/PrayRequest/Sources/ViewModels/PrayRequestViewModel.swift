//
//  PrayRequestViewModel.swift
//  Features
//
//  Created by 김영훈 on 6/8/25.
//

import Foundation
import Core

final class PrayRequestViewModel {
    let userIdentifier: String?
    let prayRequestUseCase: PrayRequestUseCase
    
    init() {
        self.userIdentifier = UserDefaults.standard.string(forKey: "userId")
        let firestoreService = FirestoreService()
        let prayRequestRepository = PrayRequestRepositoryImpl(firestoreService: firestoreService)
        self.prayRequestUseCase = DefaultPrayRequestUseCase(repository: prayRequestRepository)
    }
    
    func addPrayRequest(prayRequest: PrayRequest) async {
        guard let userIdentifier = userIdentifier else { return }
        
        await prayRequestUseCase.addPrayRequest(userId: userIdentifier, prayRequest: prayRequest)
    }
}
