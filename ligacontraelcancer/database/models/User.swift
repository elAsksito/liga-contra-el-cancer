import Foundation
import FirebaseFirestore

struct User: Codable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    var name: String = ""
    var surname: String = ""
    var dni: String = ""
    var phone: String = ""
    var email: String = ""
    var rol: String = ""
    var specialties: String = ""
    var profileImageUrl: String = ""
    var status: String = "Activo"
}
