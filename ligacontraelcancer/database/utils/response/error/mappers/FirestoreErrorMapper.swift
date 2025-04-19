import Foundation
import FirebaseFirestore

struct FirestoreErrorMapper: ErrorMappable {
    func mapError(_ error: Error) -> ErrorState {
        let nsError = error as NSError

        guard nsError.domain == FirestoreErrorDomain else {
            return .unknownError(nsError.localizedDescription)
        }

        guard let errorCode = FirestoreErrorCode.Code(rawValue: nsError.code) else {
            return .unknownError(nsError.localizedDescription)
        }

        switch errorCode {
        case .permissionDenied:
            return .unauthorized("No tienes permiso")
        case .notFound:
            return .notFound("Documento no encontrado")
        case .unavailable:
            return .serviceUnavailable("Servicio no disponible")
        case .deadlineExceeded:
            return .timeout("Tiempo de espera agotado")
        default:
            return .firestoreError("Error en Firestore")
        }
    }
}
