import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit

class UserService {
    
    static let shared = UserService()
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    private init () {}
    
    func getDoctors() async -> ResultState<[User]> {
        do{
            let result = try await db.collection("users")
                .whereField("rol", isEqualTo: "Doctor")
                .getDocuments()
            let users = result.documents.compactMap { try? $0.data(as: User.self) }
            return .success(users)
        } catch (let error as NSError) {
            return .failure(ErrorMapper.map(error))
        }
    }
    
    func getCurrentUser() async -> ResultState<User> {
        guard let uid = auth.currentUser?.uid else {
                return .failure(.unauthorized("Usuario no autenticado"))
        }
        do {
            let doc = try await db.collection("users").document(uid).getDocument()
            guard let user = try? doc.data(as: User.self) else {
                return .failure(.userNotFound("Usuario no encontrado en Firestore"))
            }
            return .success(user)
        } catch let error as NSError {
            return .failure(ErrorMapper.map(error))
        }
    }
    
    func updateUserProfile(userId: String, user: User, image: UIImage? = nil) async -> ResultState<String> {
        do {
            var updatedUser = user
            if let image = image {
                if let imageUrl = try await uploadProfileImage(userId: userId, image: image) {
                    updatedUser.profileImageUrl = imageUrl
                }
            }
            let encodedUser = try Firestore.Encoder().encode(updatedUser)
            try await db.collection("users").document(userId).setData(encodedUser)
            return .success("Perfil actualizado correctamente")
        } catch let error as NSError {
            return .failure(ErrorMapper.map(error))
        }
    }
    
    func registerDoctor(name: String, surname: String, dni: String, email: String, password: String, specialty: String) async -> ResultState<String> {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            guard let uid = result.user.uid as String? else {
                return .failure(.unknownError("UID no encontrado"))
            }

            let doctor = User(
                id: uid,
                name: name,
                surname: surname,
                dni: dni,
                phone: "",
                email: email,
                rol: "Doctor",
                specialties: specialty,
                profileImageUrl: "",
                status: "Activo"
            )

            try await saveUserInFirestore(doctor)
            return .success("Usuario registrado exitosamente")
        } catch let error as NSError {
            return .failure(ErrorMapper.map(error))
        }
    }
    
    func getDoctorsByStatus(status: String) async -> ResultState<[User]> {
        do {
            let snapshot = try await db.collection("users")
                .whereField("rol", isEqualTo: "Doctor")
                .whereField("status", isEqualTo: status)
                .getDocuments()
            let users = snapshot.documents.compactMap { try? $0.data(as: User.self) }
            return .success(users)
        } catch let error as NSError {
            return .failure(ErrorMapper.map(error))
        }
    }
    
    func disableUser(userId: String) async -> ResultState<String> {
        do {
            try await db.collection("users").document(userId)
                .updateData(["status": "Inactivo"])
            return .success("Usuario inhabilitado correctamente")
        } catch let error as NSError {
            return .failure(ErrorMapper.map(error))
        }
    }
    
    func getFirstDoctorBySpecialty(specialty: String) async -> ResultState<User> {
        do {
            let snapshot = try await db.collection("users")
                .whereField("rol", isEqualTo: "Doctor")
                .whereField("specialties", isEqualTo: specialty)
                .whereField("status", isEqualTo: "Activo")
                .limit(to: 1)
                .getDocuments()
                
            guard let doc = snapshot.documents.first,
                    let doctor = try? doc.data(as: User.self) else {
                return .failure(.userNotFound("No se encontró ningún doctor para esa especialidad"))
            }
            return .success(doctor)
        } catch let error as NSError {
            return .failure(ErrorMapper.map(error))
        }
    }
    
    func getDoctorNameById(id: String) async -> ResultState<String> {
        do {
            let doc = try await db.collection("users").document(id).getDocument()
            guard let user = try? doc.data(as: User.self) else {
                return .failure(.userNotFound("Doctor no encontrado"))
            }
            return .success(user.name)
        } catch let error as NSError {
            return .failure(ErrorMapper.map(error))
        }
    }
    
    private func saveUserInFirestore(_ user: User) async throws {
        let encodedUser = try Firestore.Encoder().encode(user)
        try await db.collection("users").document(user.id ?? UUID().uuidString).setData(encodedUser)
    }
    
    private func uploadProfileImage(userId: String, image: UIImage) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return nil }
        let ref = storage.reference().child("profileImages/\(userId).jpg")
        _ = try await ref.putDataAsync(imageData)
        return try await ref.downloadURL().absoluteString
    }
    
}
