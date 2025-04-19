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
        return await ResultState.from {
            if !self.isValidPassword(password) {
                throw NSError(domain: RegisterErrorDomain.domain, code: RegisterErrorCode.weakPassword.rawValue, userInfo: nil)
            }

            let dniExiste = try await self.checkIfDNIExits(dni)
            if dniExiste {
                throw NSError(domain: RegisterErrorDomain.domain, code: RegisterErrorCode.dniAlreadyExists.rawValue, userInfo: nil)
            }

            let result = try await self.auth.createUser(withEmail: email, password: password)
            guard let user = result.user as FirebaseAuth.User? else {
                throw NSError(domain: AuthErrorDomain, code: AuthErrorCode.userNotFound.rawValue, userInfo: nil)
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

            try await self.saveUserInFirestore(lcUser)
            return ("Usuario registrado exitosamente", lcUser)
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

    private func checkIfDNIExits(_ dni: String) async throws -> Bool {
        let querySnapshot = try await firestore
            .collection("users")
            .whereField("dni", isEqualTo: dni)
            .getDocuments()
        return !querySnapshot.documents.isEmpty
    }

    private func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
}

