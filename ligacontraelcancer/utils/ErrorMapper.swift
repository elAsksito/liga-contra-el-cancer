import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct ErrorMapper {

    static func map(_ error: NSError) -> ErrorState {
        switch error.domain {
        case AuthErrorDomain:
            return mapAuthError(error)
        case FirestoreErrorDomain:
            return mapFirestoreError(error)
        case StorageErrorDomain:
            return mapStorageError(error)
        default:
            return .unknownError("Ha ocurrido un error inesperado. Intenta nuevamente.")
        }
    }

    private static func mapAuthError(_ error: NSError) -> ErrorState {
        switch error.code {
        case AuthErrorCode.invalidEmail.rawValue:
            return .invalidCredentials("Correo inválido.")
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return .emailAlreadyInUse("Este correo ya está registrado.")
        case AuthErrorCode.userNotFound.rawValue:
            return .userNotFound("No se encontró una cuenta con este correo.")
        case AuthErrorCode.wrongPassword.rawValue:
            return .invalidCredentials("Contraseña incorrecta.")
        case AuthErrorCode.weakPassword.rawValue:
            return .customError("La contraseña es muy débil.")
        case AuthErrorCode.userDisabled.rawValue:
            return .customError("Esta cuenta ha sido deshabilitada.")
        case AuthErrorCode.tooManyRequests.rawValue:
            return .tooManyRequest("Demasiados intentos fallidos. Intenta más tarde.")
        case AuthErrorCode.networkError.rawValue:
            return .networkError("Verifica tu conexión a internet.")
        case AuthErrorCode.operationNotAllowed.rawValue:
            return .customError("Esta operación no está permitida.")
        case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
            return .customError("Ya existe una cuenta con diferentes credenciales.")
        case AuthErrorCode.invalidCredential.rawValue:
            return .customError("Credenciales inválidas.")
        case AuthErrorCode.credentialAlreadyInUse.rawValue:
            return .customError("La credencial ya está en uso.")
        case AuthErrorCode.userTokenExpired.rawValue:
            return .customError("Sesión expirada. Inicia sesión nuevamente.")
        case AuthErrorCode.invalidUserToken.rawValue:
            return .customError("Token inválido. Intenta iniciar sesión otra vez.")
        default:
            return .unknownError("Error inesperado de autenticación.")
        }
    }

    private static func mapFirestoreError(_ error: NSError) -> ErrorState {
        guard let code = FirestoreErrorCode.Code(rawValue: error.code) else {
            return .unknownError("Error desconocido en la base de datos: \(error.localizedDescription)")
        }
        switch code {
        case .cancelled:
            return .customError("La operación fue cancelada por el cliente.")
        case .unknown:
            return .unknownError("Ocurrió un error desconocido en Firestore.")
        case .invalidArgument:
            return .customError("Se proporcionó un argumento inválido.")
        case .deadlineExceeded:
            return .customError("La operación excedió el tiempo de espera.")
        case .notFound:
            return .customError("El documento solicitado no fue encontrado.")
        case .alreadyExists:
            return .customError("Ya existe un documento con esa información.")
        case .permissionDenied:
            return .customError("No tienes los permisos necesarios.")
        case .resourceExhausted:
            return .customError("Recursos agotados. Intenta nuevamente más tarde.")
        case .failedPrecondition:
            return .customError("No se cumplen las condiciones requeridas.")
        case .aborted:
            return .customError("La operación fue abortada.")
        case .outOfRange:
            return .customError("Se ingresó un valor fuera del rango permitido.")
        case .unimplemented:
            return .customError("Esta función aún no está implementada.")
        case .internal:
            return .customError("Ocurrió un error interno en Firestore.")
        case .unavailable:
            return .serviceUnavaible("El servicio no está disponible en este momento.")
        case .dataLoss:
            return .customError("Se ha producido una pérdida de datos.")
        case .unauthenticated:
            return .invalidCredentials("No has iniciado sesión.")
        case .OK:
            return .unknownError("Error desconocido")
        @unknown default:
            return .unknownError("Error desconocido de Firestore. Código: \(error.code)")
        }
    }

    private static func mapStorageError(_ error: NSError) -> ErrorState {
        guard let code = StorageErrorCode(rawValue: error.code) else {
            return .unknownError("Error desconocido al subir/descargar archivo.")
        }
        switch code {
        case .objectNotFound:
            return .customError("Archivo no encontrado en el servidor.")
        case .unauthorized:
            return .customError("No tienes permisos para acceder al archivo.")
        case .cancelled:
            return .customError("Subida/cancelación cancelada.")
        case .unknown:
            return .unknownError("Error inesperado en Storage.")
        case .bucketNotFound:
            return .customError("No se encontró el bucket de almacenamiento.")
        case .projectNotFound:
            return .customError("No se encontró el proyecto de Firebase.")
        case .quotaExceeded:
            return .customError("Límite de almacenamiento excedido.")
        case .retryLimitExceeded:
            return .customError("Se superó el límite de reintentos.")
        case .nonMatchingChecksum:
            return .customError("El archivo fue dañado durante la transferencia.")
        case .invalidArgument:
            return .customError("Argumento inválido en la operación de archivo.")
        default:
            return .unknownError("Error no especificado en Firebase Storage.")
        }
    }
}
