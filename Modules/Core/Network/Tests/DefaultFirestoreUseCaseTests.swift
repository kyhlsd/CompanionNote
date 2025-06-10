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
}


final class MockUserRepository: UserRepository {
    
    var shouldUserExist: Bool = false

    func userExists(userId: String) async throws -> Bool {
        return shouldUserExist
    }

    func createUser(userId: String) async throws {
        return
    }
}
