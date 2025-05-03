import Foundation
import Combine
import FirebaseFirestore

@MainActor
class AppointmentViewModel: ObservableObject {
    
    @Published var appointmentState: ResultState<Appointment> = .idle
    @Published var allAppointmentsState: ResultState<[AppointmentDetail]> = .idle
    @Published var userAppointmentsState: ResultState<[AppointmentDetail]> = .idle
    @Published var doctorAppointmentsState: ResultState<[AppointmentDetail]> = .idle
    @Published var updateState: ResultState<String> = .idle
    @Published var deleteState: ResultState<String> = .idle
    private var listener: ListenerRegistration?
    
    func createAppointment(_ appointment: Appointment) {
        self.appointmentState = .loading
        
        Task {
            let result = await AppointmentService.shared.createAppointment(appointment)
            self.appointmentState = result
        }
    }
    
    func fetchAllAppointments() {
        self.allAppointmentsState = .loading
        
        Task {
            let result = await AppointmentService.shared.getAllAppointmentsWithDetails()
            self.allAppointmentsState = result
        }
    }
    
    func fetchAppointmentsByDoctorId(_ doctorId: String) {
        self.doctorAppointmentsState = .loading
        
        Task {
            let result = await AppointmentService.shared.getAppointmentsByDoctorId(doctorId)
            self.doctorAppointmentsState = result
        }
    }
    
    func updateAppointment(appointmentId: String, appointment: Appointment) {
        self.updateState = .loading
        
        Task {
            let result = await AppointmentService.shared.updateAppointment(appointmentId: appointmentId, with: appointment)
            self.updateState = result
        }
    }

    func deleteAppointment(appointmentId: String) {
        self.deleteState = .loading
        
        Task {
            let result = await AppointmentService.shared.deleteAppointment(appointmentId: appointmentId)
            self.deleteState = result
        }
    }
    
    func observeAppointmentsByUserId(_ userId: String) {
        self.userAppointmentsState = .loading

        AppointmentService.shared.fetchAppointmentsByUserId(userId) { [weak self] result in
            DispatchQueue.main.async {
                self?.userAppointmentsState = result
            }
        }
    }
    
    func removeListener() {
        listener?.remove()
        listener = nil
    }
}
