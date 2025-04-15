import Foundation
import FirebaseAuth

class AuthService {
    static let shared = AuthService()
    private init() {}

    func loginUser(email: String, password: String) async -> ResultState<FirebaseAuth.User> {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            guard let user = result.user as FirebaseAuth.User? else {
                return .failure(.unknownError("No se pudo obtener el usuario"))
            }
            return .success(user)
        } catch let error as NSError {
            return .failure(mapAuthError(error))
        }
    }

    private func mapAuthError(_ error: NSError) -> ErrorState {
        switch error.code {
        case AuthErrorCode.userNotFound.rawValue:
            return .userNotFound("Usuario no encontrado")
        case AuthErrorCode.invalidEmail.rawValue,
             AuthErrorCode.wrongPassword.rawValue:
            return .invalidCredentials("Correo o contraseña incorrectos")
        case AuthErrorCode.networkError.rawValue:
            return .networkError("Error de red, verifica tu conexión")
        case AuthErrorCode.userDisabled.rawValue:
            return .customError("La cuenta ha sido deshabilitada")
        case AuthErrorCode.tooManyRequests.rawValue:
            return .customError("Demasiados intentos, intenta más tarde")
        default:
            return .unknownError("Ha ocurrido un error inesperado. Intenta nuevamente.")
        }
    }
}
