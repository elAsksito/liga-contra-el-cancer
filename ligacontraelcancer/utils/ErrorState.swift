import Foundation

enum ErrorState: Error {
    case networkError(String)
    case invalidCredentials(String)
    case userNotFound(String)
    case emailAlreadyInUse(String)
    case tooManyRequest(String)
    case serviceUnavaible(String)
    case unauthorized(String)
    case unknownError(String)
    case customError(String)

    var message: String {
        switch self {
        case .networkError(let msg),
             .invalidCredentials(let msg),
             .userNotFound(let msg),
             .emailAlreadyInUse(let msg),
             .tooManyRequest(let msg),
             .serviceUnavaible(let msg),
             .unauthorized(let msg),
             .unknownError(let msg),
             .customError(let msg):
            return msg
        }
    }
}
