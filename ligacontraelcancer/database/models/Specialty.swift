import Foundation
import FirebaseFirestore

struct Specialty: Codable, Identifiable {
    @DocumentID var id: String? = UUID().uuidString
    var nombre: String = ""
    var description: String = ""
    var image: String = ""
}
 
