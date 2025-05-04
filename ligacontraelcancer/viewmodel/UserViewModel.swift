import Combine
import UIKit
import Foundation
import FirebaseAuth

@MainActor
class UserViewModel{
    
    @Published var userState: ResultState<String> = .idle
    @Published var userById: ResultState<User> = .idle
    @Published var updateState: ResultState<String> = .idle
    @Published var getDoctorsState: ResultState<[User]> = .idle
    @Published var doctorBySpecialtyState: ResultState<User> = .idle
    
    func logout() {
        self.userState = .loading
        let result = AuthService.shared.logOut()
        self.userState = result
    }
    
    func getUserById(uid: String){
        self.userById = .loading
        
        Task {
            let result =  await UserService.shared.getUserById(userId: uid)
            self.userById = result
        }
        
    }
    
    func updateUser(userId: String, updatedUser: User, image: UIImage? = nil) {
            self.updateState = .loading
            
            Task {
                let result = await UserService.shared.updateUserProfile(userId: userId, user: updatedUser, image: image)
                self.updateState = result
            }
    }
    
    func getAllDoctors(){
        self.getDoctorsState = .loading
        
        Task{
            let result = await UserService.shared.getDoctors()
            self.getDoctorsState = result
        }
    }
    
    func getFirstDoctorBySpecialty(specialty: String) {
        self.doctorBySpecialtyState = .loading
        Task {
            let result = await UserService.shared.getFirstDoctorBySpecialty(specialty: specialty)
            self.doctorBySpecialtyState = result
        }
    }
}
