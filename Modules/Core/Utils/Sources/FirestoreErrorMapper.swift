//
//  FirestoreErrorMapper.swift
//  Core
//
//  Created by 김영훈 on 6/10/25.
//

import FirebaseFirestore

public enum FirestoreErrorMessage: String {
    case permissionDenied = "권한이 없습니다. 다시 로그인 해주세요."
    case unauthenticated = "인증되지 않았습니다. 로그인 후 다시 시도해주세요."
    case notFound = "해당 문서를 찾을 수 없습니다."
    case unavailable = "서버가 일시적으로 사용할 수 없습니다. 잠시 후 다시 시도해주세요."
    case deadlineExceeded = "요청 시간이 초과되었습니다. 네트워크 상태를 확인해주세요."
    case unknown = "알 수 없는 오류가 발생했습니다. 다시 시도해주세요."
}

public enum FirestoreErrorMapper {
    public static func message(for error: Error) -> String {
        guard let nsError = error as NSError?,
              nsError.domain == FirestoreErrorDomain,
              let codeValue = FirestoreErrorCode.Code(rawValue: nsError.code) else {
            return error.localizedDescription
        }

        let code = FirestoreErrorCode(codeValue).code

        switch code {
        case .permissionDenied:
            return FirestoreErrorMessage.permissionDenied.rawValue
        case .unauthenticated:
            return FirestoreErrorMessage.unauthenticated.rawValue
        case .notFound:
            return FirestoreErrorMessage.notFound.rawValue
        case .unavailable:
            return FirestoreErrorMessage.unavailable.rawValue
        case .deadlineExceeded:
            return FirestoreErrorMessage.deadlineExceeded.rawValue
        default:
            return FirestoreErrorMessage.unknown.rawValue
        }
    }
}
