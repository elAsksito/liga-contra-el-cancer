import FirebaseStorage
import Foundation

struct StorageErrorMapper: ErrorMappable {
    func mapError(_ error: Error) -> ErrorState {
        let nsError = error as NSError

        guard nsError.domain == StorageErrorDomain else {
            return .unknownError(nsError.localizedDescription)
        }

        switch StorageErrorCode(rawValue: nsError.code) {
        case .objectNotFound:
            return .notFound("Archivo no encontrado")
        case .unauthorized:
            return .unauthorized("No tienes acceso a este recurso")
        case .unknown:
            return .unknownError("Error desconocido en Storage")
        default:
            return .storageError("Error de almacenamiento")
        }
    }
}
