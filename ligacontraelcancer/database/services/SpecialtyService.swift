import Foundation
import FirebaseFirestore
import FirebaseFirestore
import FirebaseStorage
import UIKit

class SpecialtyService {
    
    static let shared = SpecialtyService()
    private init () {}
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    private var collection: CollectionReference {
        db.collection("specialties")
    }
    
    func saveSpecialty(_ specialty: Specialty, image: UIImage?) async -> ResultState<String> {
        do {
            let docRef = collection.document()
            let specialtyId = docRef.documentID

            var updatedSpecialty = specialty
            updatedSpecialty.id = specialtyId

            if let image = image {
                if let imageUrl = try await uploadImage(image: image, specialtyId: specialtyId) {
                    updatedSpecialty.image = imageUrl
                }
            }

            try docRef.setData(from: updatedSpecialty)
            return .success("Especialidad guardada correctamente con ID: \(specialtyId)")
        } catch let error as NSError {
            return .failure(ErrorMapper.map(error))
        }
    }

    func getSpecialtyById(_ id: String) async -> ResultState<Specialty> {
        do {
            let doc = try await collection.document(id).getDocument()
            if doc.exists{
                let specialty = try doc.data(as: Specialty.self)
                return .success(specialty)
            } else{
                return .failure(.customError("No se pudo obtener la especialidad"))
            }
        } catch let error as NSError {
            return .failure(ErrorMapper.map(error))
        }
    }

    func getAllSpecialties() async -> ResultState<[Specialty]> {
        do {
            let snapshot = try await collection.getDocuments()
            let specialties = snapshot.documents.compactMap { doc in
                try? doc.data(as: Specialty.self)
            }
            return .success(specialties)
        } catch let error as NSError {
            return .failure(ErrorMapper.map(error))
        }
    }

    func deleteSpecialty(_ id: String) async -> ResultState<String> {
        do {
            try await collection.document(id).delete()
            return .success("Especialidad eliminada correctamente")
        } catch let error as NSError {
            return .failure(ErrorMapper.map(error))
        }
    }

    private func uploadImage(image: UIImage, specialtyId: String) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return nil }
        let storageRef = storage.reference().child("specialties/\(specialtyId).jpg")
        _ = try await storageRef.putDataAsync(imageData)
        let url = try await storageRef.downloadURL()
        return url.absoluteString
    }
}
