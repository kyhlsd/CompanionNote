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
    
    public func checkIfDocumentExists(collection: String, document: String) async throws -> Bool {
        let docRef = db.collection(collection).document(document)
        let document = try await docRef.getDocument()
        return document.exists
    }
    
    public func setDocument<T: Encodable>(collection: String, document: String, data: T) async throws {
        try db.collection(collection).document(document).setData(from: data)
    }
    
    public func setDocument(collection: String, documentId: String, data: [String: Any]) async throws {
        try await db.collection(collection).document(documentId).setData(data)
    }
}

// MARK: Repositories
public protocol UserRepository {
    func userExists(userId: String) async throws -> Bool
    func createUser(userId: String) async -> Bool
}

public protocol PrayRequestRepository {
    func addPrayRequest(userId: String, prayRequest: PrayRequest) async
}

// MARK: RepositoryImplements
public final class UserRepositoryImpl: UserRepository {
    private let firestoreService: FirestoreService

    public init(firestoreService: FirestoreService) {
        self.firestoreService = firestoreService
    }

    public func userExists(userId: String) async throws -> Bool {
        return try await firestoreService.checkIfDocumentExists(collection: "Users", document: userId)
    }

    public func createUser(userId: String) async -> Bool {
        let data = ["userIdentifier": userId]
        do {
            try await firestoreService.setDocument(collection: "Users", documentId: userId, data: data)
            return true
        } catch {
            print("Failed to create user: \(error)")
            return false
        }
    }
}

public final class PrayRequestRepositoryImpl: PrayRequestRepository {
    private let firestoreService: FirestoreService

    public init(firestoreService: FirestoreService) {
        self.firestoreService = firestoreService
    }

    public func addPrayRequest(userId: String, prayRequest: PrayRequest) async {
        do {
            try await firestoreService.setDocument(collection: "Prayers", document: userId, data: prayRequest)
        } catch {
            print("Failed to add prayer request: \(error)")
        }
    }
}

// MARK: UseCases
public protocol UserUseCase {
    func userExists(userId: String) async throws -> Bool
    func createUser(userId: String) async -> Bool
}

public final class DefaultUserUseCase: UserUseCase {
    private let userRepository: UserRepository

    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    public func userExists(userId: String) async throws -> Bool {
        return try await userRepository.userExists(userId: userId)
    }

    public func createUser(userId: String) async -> Bool {
        return await userRepository.createUser(userId: userId)
    }
}

public protocol PrayRequestUseCase {
    func addPrayRequest(userId: String, prayRequest: PrayRequest) async
}

public final class DefaultPrayRequestUseCase: PrayRequestUseCase {
    private let repository: PrayRequestRepository

    public init(repository: PrayRequestRepository) {
        self.repository = repository
    }

    public func addPrayRequest(userId: String, prayRequest: PrayRequest) async {
        await repository.addPrayRequest(userId: userId, prayRequest: prayRequest)
    }
}

