import Foundation
import FirebaseAuth

@MainActor
class LoginViewModel{
    func login(email: String,  password: String) async -> ResultState<FirebaseAuth.User> {
        return await AuthService.shared.loginUser(email: email, password: password)
    }
    
    
}
