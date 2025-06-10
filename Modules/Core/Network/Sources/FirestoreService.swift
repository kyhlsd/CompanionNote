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
    
    public func setDocument(collection: String, document: String, data: [String: Any]) async throws {
        try await db.collection(collection).document(document).setData(data)
    }
    
    public func setDocumentInCollection<T: Encodable>(firstCollection: String, firstDocument: String, secondCollection: String, secondDocument: String, data: T) async throws {
        try db.collection(firstCollection).document(firstDocument).collection(secondCollection).document(secondDocument).setData(from: data)
    }
}

// MARK: Repositories
public protocol UserRepository {
    func userExists(userId: String) async throws -> Bool
    func createUser(userId: String) async throws
}

public protocol PrayRequestRepository {
    func addPrayRequest(userId: String, prayRequest: PrayRequest) async throws
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

    public func createUser(userId: String) async throws {
        let data = ["userIdentifier": userId]
        try await firestoreService.setDocument(collection: "Users", document: userId, data: data)
    }
}

public final class PrayRequestRepositoryImpl: PrayRequestRepository {
    private let firestoreService: FirestoreService

    public init(firestoreService: FirestoreService) {
        self.firestoreService = firestoreService
    }

    public func addPrayRequest(userId: String, prayRequest: PrayRequest) async throws {
        try await firestoreService.setDocumentInCollection(firstCollection: "Prayers", firstDocument: userId, secondCollection: "Prayers", secondDocument: prayRequest.uuid.uuidString, data: prayRequest)
    }
}

// MARK: UseCases
public protocol UserUseCase {
    func userExists(userId: String) async throws -> Bool
    func createUser(userId: String) async throws
}

public final class DefaultUserUseCase: UserUseCase {
    private let userRepository: UserRepository

    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }

    public func userExists(userId: String) async throws -> Bool {
        return try await userRepository.userExists(userId: userId)
    }

    public func createUser(userId: String) async throws {
        return try await userRepository.createUser(userId: userId)
    }
}

public protocol PrayRequestUseCase {
    func addPrayRequest(userId: String, prayRequest: PrayRequest) async throws
}

public final class DefaultPrayRequestUseCase: PrayRequestUseCase {
    private let repository: PrayRequestRepository

    public init(repository: PrayRequestRepository) {
        self.repository = repository
    }

    public func addPrayRequest(userId: String, prayRequest: PrayRequest) async throws {
        try await repository.addPrayRequest(userId: userId, prayRequest: prayRequest)
    }
}

