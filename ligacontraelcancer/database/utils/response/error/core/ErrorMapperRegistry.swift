import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct ErrorMapperRegistry {
    static func map(_ error: Error) -> ErrorState {
        let nsError = error as NSError

        if nsError.domain == AuthErrorDomain {
            return AuthErrorMapper().mapError(error)
        }

        if nsError.domain == FirestoreErrorDomain {
            return FirestoreErrorMapper().mapError(error)
        }

        if nsError.domain == StorageErrorDomain {
            return StorageErrorMapper().mapError(error)
        }

        if nsError.domain == NSURLErrorDomain {
            return NetworkErrorMapper().mapError(error)
        }
        
        if nsError.domain == RegisterErrorDomain.domain {
            return RegisterErrorMapper().mapError(error)
        }

        return DefaultErrorMapper().mapError(error)
    }
}

