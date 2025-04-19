import Foundation
import FirebaseAuth

class AuthService {
    static let shared = AuthService()
    private init() {}

    func loginUser(email: String, password: String) async -> ResultState<FirebaseAuth.User> {
        return await ResultState.from {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            guard let user = result.user as FirebaseAuth.User? else {
                throw NSError(domain: "AuthErrorDomain", code: AuthErrorCode.userNotFound.rawValue, userInfo: nil)
            }
            return user
        }
    }
}
