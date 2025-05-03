import Foundation
import FirebaseFirestore

struct Appointment : Codable, Identifiable {
    @DocumentID var id: String?
    var consultorio: String = ""
    var especialidadId: String = ""
    var userId: String = ""
    var doctorId: String = ""
    var estado: String = "Pendiente"
    var fecha: String = ""
    var hora: String = ""
    var observaciones: String = ""
    var receta: String = ""
}
