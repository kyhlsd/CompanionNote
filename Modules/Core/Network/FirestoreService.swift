//
//  FirestoreManager.swift
//  Core
//
//  Created by 김영훈 on 6/4/25.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

public final class FirestoreService {

    public init() {}
    
    private let db = Firestore.firestore()
    
    public func checkIfUserExists(userId: String) async throws -> Bool {
        let docRef = db.collection("users").document(userId)
        let document = try await docRef.getDocument()
        return document.exists
    }
    
    public func createUserData(userId: String) async -> Bool {
        let data = ["userIdentifier": userId]
        do {
            try await db.collection("Users").document(userId).setData(data)
            return true
        } catch {
            print("Error writing document: \(error.localizedDescription)")
            return false
        }
    }
}

protocol FirestoreUseCase {
    func checkIfUserExists(userId: String) async throws -> Bool
    func createUserData(userId: String) async throws -> Bool
}

public final class DefaultFirestoreUseCase: FirestoreUseCase {
    private let firestoreService: FirestoreService
    
    public init(firestoreService: FirestoreService = FirestoreService()) {
        self.firestoreService = firestoreService
    }
    
    public func checkIfUserExists(userId: String) async throws -> Bool {
        return try await firestoreService.checkIfUserExists(userId: userId)
    }
    
    public func createUserData(userId: String) async -> Bool {
        return await firestoreService.createUserData(userId: userId)
    }
}
