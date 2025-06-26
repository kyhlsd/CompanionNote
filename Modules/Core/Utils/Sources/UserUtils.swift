//
//  UserUtils.swift
//  Core
//
//  Created by 김영훈 on 6/26/25.
//

import FirebaseAuth

public enum UserUtils {
    public static func isLogin() async -> Bool {
        guard let user = Auth.auth().currentUser else {
            return false
        }

        do {
            _ = try await user.getIDToken()
            return true
        } catch {
            try? Auth.auth().signOut()
            return false
        }
    }
    
    public static func getUserIdentifier() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    public static func logout() {
        try? Auth.auth().signOut()
    }
}
