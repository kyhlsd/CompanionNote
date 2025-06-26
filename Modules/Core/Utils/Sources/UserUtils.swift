//
//  UserUtils.swift
//  Core
//
//  Created by 김영훈 on 6/26/25.
//

import FirebaseAuth

public enum UserUtils {
    public static func isLogin() -> Bool {
        var result = false
        if let user = Auth.auth().currentUser {
            user.getIDToken { token, error in
                if let _ = error {
                    try? Auth.auth().signOut()
                } else {
                    result = true
                }
            }
        }
        return result
    }
    public static func getUserIdentifier() -> String? {
        return Auth.auth().currentUser?.uid
    }
}
