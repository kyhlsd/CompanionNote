//
//  DefaultFirestoreUseCaseTests.swift
//  CoreTests
//
//  Created by 김영훈 on 6/4/25.
//

import XCTest
@testable import Core

final class DefaultFirestoreUseCaseTests: XCTestCase {
    
    func test_checkIfUserExists_returnsTrue() async throws {
        // Given
        let mockService = MockFirestoreService()
        mockService.shouldUserExist = true
        let useCase = DefaultFirestoreUseCase(firestoreService: mockService)
        
        // When
        let exists = try await useCase.checkIfUserExists(userId: "testUser")
        
        // Then
        XCTAssertTrue(exists)
    }
    
    func test_checkIfUserExists_returnsFalse() async throws {
        let mockService = MockFirestoreService()
        mockService.shouldUserExist = false
        let useCase = DefaultFirestoreUseCase(firestoreService: mockService)
        
        let exists = try await useCase.checkIfUserExists(userId: "testUser")
        
        XCTAssertFalse(exists)
    }
    
    func test_createUserData_returnsTrue() async {
        let mockService = MockFirestoreService()
        mockService.shouldCreateUserSucceed = true
        let useCase = DefaultFirestoreUseCase(firestoreService: mockService)
        
        let result = await useCase.createUserData(userId: "testUser")
        
        XCTAssertTrue(result)
    }
    
    func test_createUserData_returnsFalse() async {
        let mockService = MockFirestoreService()
        mockService.shouldCreateUserSucceed = false
        let useCase = DefaultFirestoreUseCase(firestoreService: mockService)
        
        let result = await useCase.createUserData(userId: "testUser")
        
        XCTAssertFalse(result)
    }
}


final class MockFirestoreService: FirestoreServiceProtocol {
    var shouldUserExist = false
    var shouldCreateUserSucceed = true
    
    func checkIfUserExists(userId: String) async throws -> Bool {
        return shouldUserExist
    }
    
    func createUserData(userId: String) async -> Bool {
        return shouldCreateUserSucceed
    }
}
