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
    
    func checkIfDocumentExists(collection: String, document: String) async throws -> Bool {
        let docRef = db.collection(collection).document(document)
        let document = try await docRef.getDocument()
        return document.exists
    }
    
    func setDocument<T: Encodable>(collection: String, document: String, data: T) async throws {
        try db.collection(collection).document(document).setData(from: data)
    }
    
    func setDocument(collection: String, document: String, data: [String: Any]) async throws {
        try await db.collection(collection).document(document).setData(data)
    }
    
    func updateDocument<T: Encodable>(collection: String, document: String, data: T) async throws {
        let encoder = Firestore.Encoder()
        let dict = try encoder.encode(data)
        try await db.collection(collection).document(document).updateData(dict)
    }
    
    func updateDocument(collection: String, document: String, data: [AnyHashable: Any]) async throws {
        try await db.collection(collection).document(document).updateData(data)
    }
    
    func fetchDocuments<T: Decodable>(collection: String, field: String, readableUsers: [String]) async throws -> [T] {
        let snapshot = try await db.collection(collection)
            .whereField(field, in: readableUsers)
            .getDocuments()
        let datas: [T] = try snapshot.documents.map { document in
            try document.data(as: T.self)
        }
        return datas
    }
    
    func deleteDocument(collection: String, document: String) async throws {
        try await db.collection(collection).document(document).delete()
    }
}

// MARK: Repositories
public protocol UserRepository {
    func userExists(userId: String) async throws -> Bool
    func createUser(userId: String) async throws
}

public protocol PrayRequestRepository {
    func addPrayRequest(prayRequest: PrayRequest) async throws
    func fetchPrayRequests(userId: String) async throws -> [PrayRequest]
    func updatePrayRequest(prayRequest: PrayRequest) async throws
    func updatePrayRequest(itemId: String, data: [AnyHashable: Any]) async throws
    func deletePrayRequest(document: String) async throws
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

    public func addPrayRequest(prayRequest: PrayRequest) async throws {
        try await firestoreService.setDocument(collection: "Prayers", document: prayRequest.uuid.uuidString, data: prayRequest)
    }
    
    public func fetchPrayRequests(userId: String) async throws -> [PrayRequest] {
        return try await firestoreService.fetchDocuments(collection: "Prayers", field: "creatorId", readableUsers: [userId])
    }
    
    public func updatePrayRequest(prayRequest: PrayRequest) async throws {
        try await firestoreService.updateDocument(collection: "Prayers", document: prayRequest.uuid.uuidString, data: prayRequest)
    }
        
    public func updatePrayRequest(itemId: String, data: [AnyHashable : Any]) async throws {
        try await firestoreService.updateDocument(collection: "Prayers", document: itemId, data: data)
    }
    
    public func deletePrayRequest(document: String) async throws {
        try await firestoreService.deleteDocument(collection: "Prayers", document: document)
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
    func addPrayRequest(prayRequest: PrayRequest) async throws
    func fetchPrayRequests(userId: String) async throws -> [PrayRequest]
    func updatePrayRequest(prayRequest: PrayRequest) async throws
    func updatePrayRequest(itemId: String, data: [AnyHashable: Any]) async throws
    func deletePrayRequest(document: String) async throws
}

public final class DefaultPrayRequestUseCase: PrayRequestUseCase {
    
    private let repository: PrayRequestRepository

    public init(repository: PrayRequestRepository) {
        self.repository = repository
    }

    public func addPrayRequest(prayRequest: PrayRequest) async throws {
        try await repository.addPrayRequest(prayRequest: prayRequest)
    }
    
    public func fetchPrayRequests(userId: String) async throws -> [PrayRequest] {
        return try await repository.fetchPrayRequests(userId: userId)
    }
    
    public func updatePrayRequest(prayRequest: PrayRequest) async throws {
        try await repository.updatePrayRequest(prayRequest: prayRequest)
    }
    
    public func updatePrayRequest(itemId: String, data: [AnyHashable : Any]) async throws {
        try await repository.updatePrayRequest(itemId: itemId, data: data)
    }
    
    public func deletePrayRequest(document: String) async throws {
        try await repository.deletePrayRequest(document: document)
    }
}

