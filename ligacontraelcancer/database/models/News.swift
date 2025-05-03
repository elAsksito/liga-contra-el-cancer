import Foundation
import FirebaseFirestore

struct News: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String = ""
    var description: String = ""
    var image: String = ""
    var status: String = "Activa"
}
