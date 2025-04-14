import Foundation
import FirebaseAuth

class AuthService{
    static let shared = AuthService()
    private init(){}
    
    func loginUser(email: String, password: String,
                   completion: @escaping (ResultState<User>) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error as NSError?{
//            completion(.failure(error))
            }
        }
    }
}
