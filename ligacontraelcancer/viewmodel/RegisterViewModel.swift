import Foundation

@MainActor
class RegisterViewModel{
    func registerUser(
        name: String,
        surname: String,
        dni: String,
        email: String,
        password: String
    ) async -> ResultState<(String, User)>{
        return await RegisterService.shared.registerUser(
            name: name,
            surname: surname,
            dni: dni,
            email: email,
            password: password)
    }
}
