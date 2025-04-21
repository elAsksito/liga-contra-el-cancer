import Foundation
import FirebaseAuth

@MainActor
class UserViewModel{
    func logout() -> ResultState<String> {
        return AuthService.shared.logOut()
    }
}
