import FirebaseAuth
import FirebaseFirestore

class RegisterService {
    static let shared = RegisterService()
    private init() {}

    private let auth = Auth.auth()
    private let firestore = Firestore.firestore()

    func registerUser(
        name: String,
        surname: String,
        dni: String,
        email: String,
        password: String
    ) async -> ResultState<(String, User)> {
        do {
            
            if !isValidPassword(password){
                return .failure(.customError("La contraseña debe tener al menos 6 caracteres, una mayúscula, una minúscula y un número"))
            }
            
            let dniExiste = try await checkIfDNIExits(dni)
            if dniExiste{
                return .failure(.customError("El DNI ya se encuentra registrado"))
            }
            
            let result = try await auth.createUser(withEmail: email, password: password)
            guard let user = result.user as FirebaseAuth.User? else {
                return .failure(.unknownError("No se pudo obtener el UID del usuario"))
            }

            let lcUser = User(
                id: user.uid,
                name: name,
                surname: surname,
                dni: dni,
                phone: "",
                email: email,
                rol: "Paciente",
                specialties: "",
                profileImageUrl: "",
                status: "Activo"
            )

            try await saveUserInFirestore(lcUser)
            return .success(("Usuario registrado exitosamente", lcUser))

        } catch let error as NSError {
            return .failure(mapAuthError(error))
        }
    }

    private func saveUserInFirestore(_ user: User) async throws {
        let userDict: [String: Any] = [
            "id": user.id ?? "",
            "name": user.name,
            "surname": user.surname,
            "dni": user.dni,
            "phone": user.phone,
            "email": user.email,
            "rol": user.rol,
            "specialties": user.specialties,
            "profileImageUrl": user.profileImageUrl,
            "status": user.status
        ]

        try await firestore.collection("users").document(user.id ?? "").setData(userDict)
    }
    
    private func checkIfDNIExits(_ dni: String) async throws -> Bool{
        let querySnapshot = try await firestore
            .collection("users")
            .whereField("dni", isEqualTo: dni)
            .getDocuments()
        return !querySnapshot.documents.isEmpty
    }
    
    private func isValidPassword(_ password: String) -> Bool{
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }

    private func mapAuthError(_ error: NSError) -> ErrorState {
        switch error.code {
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return .emailAlreadyInUse("El correo ya está en uso.")
        case AuthErrorCode.weakPassword.rawValue:
            return .customError("La contraseña es muy débil")
        case AuthErrorCode.networkError.rawValue:
            return .networkError("Error de red, verifica tu conexión")
        default:
            return .unknownError("Ha ocurrido un error inesperado. Intenta nuevamente.")
        }
    }
}
