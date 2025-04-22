import Combine
import Foundation

@MainActor
class RegisterViewModel : ObservableObject {
    
    @Published var registerState: ResultState<(String, User)> = .idle
    
    func registerUser(
        name: String,
        surname: String,
        dni: String,
        email: String,
        password: String
    ) {
        self.registerState = .loading
        
        Task {
            let result = await RegisterService.shared.registerUser(
                name: name,
                surname: surname,
                dni: dni,
                email: email,
                password: password)
            self.registerState = result
        }
    }
}
