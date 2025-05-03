import Foundation
import FirebaseFirestore

class AppointmentService{
    
    static let shared = AppointmentService()
    private init(){}
    
    private let db = Firestore.firestore()
    private let collection = Firestore.firestore().collection("appointments")
    
    func createAppointment(_ appointment: Appointment) async -> ResultState<Appointment> {
        do {
            let docRef = try collection.addDocument(from: appointment)
            var updatedAppointment = appointment
            updatedAppointment.id = docRef.documentID
            try collection.document(docRef.documentID).setData(from: updatedAppointment)
            return .success(updatedAppointment)
        } catch let error as NSError {
            return .failure(ErrorMapper.map(error))
        }
    }
    
    func getAllAppointmentsWithDetails() async -> ResultState<[AppointmentDetail]> {
        do {
            let snapshot = try await collection.getDocuments()
            let appointments = try snapshot.documents.compactMap { doc -> Appointment? in
                var appointment = try doc.data(as: Appointment.self)
                appointment.id = doc.documentID
                return appointment
            }
            
            var appointmentDetails: [AppointmentDetail] = []
            
            for appointment in appointments {
                async let specialtyResult = SpecialtyService.shared.getSpecialtyById(appointment.especialidadId)
                async let doctorResult = UserService.shared.getDoctorNameById(id: appointment.doctorId)
                
                let (specialty, doctorName) = await (specialtyResult, doctorResult)
                
                let specialtyName = switch specialty {
                case .success(let s): s.nombre
                default: "Desconocido"
                }
                
                let doctorFullName = switch doctorName {
                case .success(let name): name
                default: "Desconocido"
                }
                
                let detail = AppointmentDetail(
                    appointment: appointment,
                    specialtyName: specialtyName,
                    doctorName: doctorFullName
                )
                appointmentDetails.append(detail)
            }
            
            return .success(appointmentDetails)
        } catch let error as NSError {
            return .failure(ErrorMapper.map(error))
        }
    }
    
    func getAppointmentsByDoctorId(_ doctorId: String) async -> ResultState<[AppointmentDetail]> {
        do {
            let query = collection.whereField("doctorId", isEqualTo: doctorId)
            let snapshot = try await query.getDocuments()
            
            let appointments = try snapshot.documents.compactMap { doc -> Appointment? in
                var appointment = try doc.data(as: Appointment.self)
                appointment.id = doc.documentID
                return appointment
            }
            
            var appointmentDetails: [AppointmentDetail] = []
            
            for appointment in appointments {
                async let specialtyResult = SpecialtyService.shared.getSpecialtyById(appointment.especialidadId)
                async let doctorResult = UserService.shared.getDoctorNameById(id: appointment.doctorId)
                
                let (specialty, doctorName) = await (specialtyResult, doctorResult)
                
                let specialtyName = switch specialty {
                case .success(let s): s.nombre
                default: "Desconocido"
                }
                
                let doctorFullName = switch doctorName {
                case .success(let name): name
                default: "Desconocido"
                }
                
                let detail = AppointmentDetail(
                    appointment: appointment,
                    specialtyName: specialtyName,
                    doctorName: doctorFullName
                )
                appointmentDetails.append(detail)
            }
            
            return .success(appointmentDetails)
        } catch let error as NSError {
            return .failure(ErrorMapper.map(error))
        }
    }
    
    func updateAppointment(appointmentId: String, with appointment: Appointment) async -> ResultState<String> {
        do {
            try collection.document(appointmentId).setData(from: appointment)
            return .success("Cita actualizada correctamente")
        } catch let error as NSError {
            return .failure(ErrorMapper.map(error))
        }
    }
    
    func deleteAppointment(appointmentId: String) async -> ResultState<String> {
        do {
            try await collection.document(appointmentId).delete()
            return .success("Cita eliminada correctamente")
        } catch let error as NSError {
            return .failure(ErrorMapper.map(error))
        }
    }
    
    func fetchAppointmentsByUserId(
        _ userId: String,
        completion: @escaping (ResultState<[AppointmentDetail]>) -> Void
    ) {
        completion(.loading)
        let query = collection.whereField("userId", isEqualTo: userId)

        query.addSnapshotListener { snapshot, error in
            if let error = error as NSError? {
                completion(.failure(ErrorMapper.map(error)))
                return
            }

            guard let snapshot = snapshot else {
                completion(.success([]))
                return
            }

            Task {
                do {
                    let appointments = try snapshot.documents.compactMap { doc -> Appointment? in
                        var appointment = try doc.data(as: Appointment.self)
                        appointment.id = doc.documentID
                        return appointment
                    }

                    var appointmentDetails: [AppointmentDetail] = []

                    for appointment in appointments {
                        async let specialtyResult = SpecialtyService.shared.getSpecialtyById(appointment.especialidadId)
                        async let doctorResult = UserService.shared.getDoctorNameById(id: appointment.doctorId)

                        let (specialty, doctorName) = await (specialtyResult, doctorResult)

                        let specialtyName = switch specialty {
                            case .success(let s): s.nombre
                            default: "Desconocido"
                        }

                        let doctorFullName = switch doctorName {
                            case .success(let d): d
                            default: "Desconocido"
                        }

                        appointmentDetails.append(AppointmentDetail(
                            appointment: appointment,
                            specialtyName: specialtyName,
                            doctorName: doctorFullName
                        ))
                    }

                    completion(.success(appointmentDetails))

                } catch {
                    completion(.failure(.unknownError("Error desconocido al procesar citas.")))
                }
            }
        }
    }
}
