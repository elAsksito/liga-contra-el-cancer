import Foundation

struct Appointment : Codable {
    var id: String = ""
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
