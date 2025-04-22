import Combine
import Foundation
import FirebaseAuth

@MainActor
class UserViewModel{
    
    @Published var userState: ResultState<String> = .idle
    
    func logout() {
        self.userState = .loading
        let result = AuthService.shared.logOut()
        self.userState = result
    }
}
