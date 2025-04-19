enum ErrorState: Error {
    case networkError(String)
    case invalidCredentials(String)
    case userNotFound(String)
    case emailAlreadyInUse(String)
    case tooManyRequest(String)
    case serviceUnavailable(String)
    case firestoreError(String)
    case storageError(String)
    case unauthorized(String)
    case notFound(String)
    case timeout(String)
    case unknownError(String)
    case customError(String)

    var message: String {
        switch self {
        case .networkError(let msg),
             .invalidCredentials(let msg),
             .userNotFound(let msg),
             .emailAlreadyInUse(let msg),
             .tooManyRequest(let msg),
             .serviceUnavailable(let msg),
             .firestoreError(let msg),
             .storageError(let msg),
             .unauthorized(let msg),
             .notFound(let msg),
             .timeout(let msg),
             .unknownError(let msg),
             .customError(let msg):
            return msg
        }
    }
}
