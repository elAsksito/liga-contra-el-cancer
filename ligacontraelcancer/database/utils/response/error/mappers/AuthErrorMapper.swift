import FirebaseAuth

struct AuthErrorMapper: ErrorMappable {
    func mapError(_ error: Error) -> ErrorState {
        let nsError = error as NSError

        guard nsError.domain == AuthErrorDomain else {
            return .unknownError(nsError.localizedDescription)
        }

        switch AuthErrorCode(rawValue: nsError.code) {
        case .userNotFound:
            return .userNotFound("Usuario no encontrado")
        case .invalidEmail, .wrongPassword:
            return .invalidCredentials("Correo o contraseña incorrectos")
        case .emailAlreadyInUse:
            return .emailAlreadyInUse("Correo ya está en uso")
        case .networkError:
            return .networkError("Error de red, intenta de nuevo")
        case .tooManyRequests:
            return .tooManyRequest("Demasiados intentos fallidos")
        default:
            return .unknownError("Error desconocido en Authenticator")
        }
    }
}
