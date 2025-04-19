import Foundation

enum RegisterErrorCode: Int {
    case weakPassword = 1001
    case dniAlreadyExists = 1002
    case unknownError = 1003
}

struct RegisterErrorMapper {
    
    func mapError(_ error: Error) -> ErrorState {
        let nsError = error as NSError
        
        switch nsError.code {
        case RegisterErrorCode.weakPassword.rawValue:
            return .customError("La contraseña debe tener al menos 6 caracteres, una mayúscula, una minúscula y un número.")
        case RegisterErrorCode.dniAlreadyExists.rawValue:
            return .customError("El DNI ya se encuentra registrado.")
        default:
            return .unknownError("Ha ocurrido un error inesperado. Intenta nuevamente.")
        }
    }
}
