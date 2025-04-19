import Foundation

struct NetworkErrorMapper: ErrorMappable {
    func mapError(_ error: Error) -> ErrorState {
        let nsError = error as NSError

        if nsError.domain == NSURLErrorDomain {
            switch nsError.code {
            case NSURLErrorNotConnectedToInternet:
                return .networkError("No estás conectado a internet")
            case NSURLErrorTimedOut:
                return .timeout("La solicitud ha tardado demasiado")
            case NSURLErrorCannotFindHost:
                return .networkError("No se pudo encontrar el servidor")
            case NSURLErrorCannotConnectToHost:
                return .serviceUnavailable("No se puede conectar al servidor")
            case NSURLErrorNetworkConnectionLost:
                return .networkError("Conexión de red perdida")
            case NSURLErrorBadServerResponse:
                return .serviceUnavailable("Respuesta inválida del servidor")
            default:
                return .networkError("Error de red desconocido")
            }
        }

        if let responseCode = nsError.userInfo["StatusCode"] as? Int {
            switch responseCode {
            case 401:
                return .unauthorized("No autorizado")
            case 404:
                return .notFound("Recurso no encontrado")
            case 408:
                return .timeout("Tiempo de espera agotado")
            case 500...599:
                return .serviceUnavailable("Error del servidor")
            default:
                break
            }
        }

        return .unknownError(error.localizedDescription)
    }
}
