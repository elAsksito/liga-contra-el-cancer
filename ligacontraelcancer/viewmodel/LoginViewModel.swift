import Combine
import Foundation
import FirebaseAuth

@MainActor
class LoginViewModel : ObservableObject {
    
    @Published var loginState: ResultState<FirebaseAuth.User> = .idle
    
    func login(email: String,  password: String) {
        self.loginState = .loading
        
        Task{
            let result = await AuthService.shared.loginUser(email: email, password: password)
            self.loginState = result
        }
    }
}
