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
        let mockRepository = MockUserRepository()
        mockRepository.shouldUserExist = true
        let useCase = DefaultUserUseCase(userRepository: mockRepository)
        
        // When
        let exists = try await useCase.userExists(userId: "testUser")
        
        // Then
        XCTAssertTrue(exists)
    }
    
    func test_checkIfUserExists_returnsFalse() async throws {
        let mockRepository = MockUserRepository()
        mockRepository.shouldUserExist = false
        let useCase = DefaultUserUseCase(userRepository: mockRepository)
        
        let exists = try await useCase.userExists(userId: "testUser")
        
        XCTAssertFalse(exists)
    }
    
    func test_createUserData_returnsTrue() async {
        let mockRepository = MockUserRepository()
        mockRepository.shouldCreateUserSucceed = true
        let useCase = DefaultUserUseCase(userRepository: mockRepository)
        
        let result = await useCase.createUser(userId: "testUser")
        
        XCTAssertTrue(result)
    }
    
    func test_createUserData_returnsFalse() async {
        let mockRepository = MockUserRepository()
        mockRepository.shouldCreateUserSucceed = false
        let useCase = DefaultUserUseCase(userRepository: mockRepository)
        
        let result = await useCase.createUser(userId: "testUser")
        
        XCTAssertFalse(result)
    }
}


final class MockUserRepository: UserRepository {
    var shouldUserExist: Bool = false
    var shouldCreateUserSucceed: Bool = true

    func userExists(userId: String) async throws -> Bool {
        return shouldUserExist
    }

    func createUser(userId: String) async -> Bool {
        return shouldCreateUserSucceed
    }
}
