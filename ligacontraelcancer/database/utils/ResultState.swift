import Foundation

enum ResultState<T>{
    case success(T)
    case failure(ErrorState)
}


enum ErrorState{
    case networkError(String)
    case invalidCredentials(String)
    case userNotFound(String)
    case emailAlreadyInUse(String)
    case tooManyRequest(String)
    case serviceUnavaible(String)
    case unknownError(String)
    case customError(String)
}
