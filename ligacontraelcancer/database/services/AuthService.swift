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
            return .failure(ErrorMapper.map(error))
        }
    }
    
    func logOut() -> ResultState<String>{
        do{
            try Auth.auth().signOut()
            return .success("Cierre de sesión exitoso")
        } catch {
            return .failure(.unknownError("Error al cerrar sesión"))
        }
    }
}
