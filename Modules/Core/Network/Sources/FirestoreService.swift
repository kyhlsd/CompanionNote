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
    
    func setDocumentInCollection<T: Encodable>(firstCollection: String, firstDocument: String, secondCollection: String, secondDocument: String, data: T) async throws {
        try db.collection(firstCollection).document(firstDocument).collection(secondCollection).document(secondDocument).setData(from: data)
    }
    
    func fetchDocumentsInCollection<T: Decodable>(firstCollection: String, document: String, secondCollection: String) async throws -> [T] {
        let docRef = db.collection(firstCollection).document(document).collection(secondCollection)
        let snapshot = try await docRef.getDocuments()
        let datas: [T] = try snapshot.documents.map { document in
            try document.data(as: T.self)
        }
        return datas
    }
}

// MARK: Repositories
public protocol UserRepository {
    func userExists(userId: String) async throws -> Bool
    func createUser(userId: String) async throws
}

public protocol PrayRequestRepository {
    func addPrayRequest(userId: String, prayRequest: PrayRequest) async throws
    func fetchPrayRequests(userId: String) async throws -> [PrayRequest]
    func updatePrayRequest(userId: String, prayRequest: PrayRequest) async throws
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
    
    public func fetchPrayRequests(userId: String) async throws -> [PrayRequest] {
        return try await firestoreService.fetchDocumentsInCollection(firstCollection: "Prayers", document: userId, secondCollection: "Prayers")
    }
    
    public func updatePrayRequest(userId: String, prayRequest: PrayRequest) async throws {
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
    func fetchPrayRequests(userId: String) async throws -> [PrayRequest]
    func updatePrayRequest(userId: String, prayRequest: PrayRequest) async throws
}

public final class DefaultPrayRequestUseCase: PrayRequestUseCase {
    private let repository: PrayRequestRepository

    public init(repository: PrayRequestRepository) {
        self.repository = repository
    }

    public func addPrayRequest(userId: String, prayRequest: PrayRequest) async throws {
        try await repository.addPrayRequest(userId: userId, prayRequest: prayRequest)
    }
    
    public func fetchPrayRequests(userId: String) async throws -> [PrayRequest] {
        return try await repository.fetchPrayRequests(userId: userId)
    }
    
    public func updatePrayRequest(userId: String, prayRequest: PrayRequest) async throws {
        try await repository.updatePrayRequest(userId: userId, prayRequest: prayRequest)
    }
}

