import UIKit
import Combine

class NewCitaViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var especialidadTextField: UITextField!
    @IBOutlet weak var fechaTextField: UITextField!
    @IBOutlet weak var horaTextField: UITextField!
    
    var selectedSpecialtyForAppointment: Specialty?
    
    var especialidades: [Specialty] = []
    let specialtyViewModel = SpecialtyViewModel()
    let appointmentViewModel = AppointmentViewModel()
    let doctorViewModel = UserViewModel()
    
    let alerts = Alerts()
    let loadingOverlay = LoadingOverlay()
    
    var cancellables = Set<AnyCancellable>()
    let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
    
    var doctorId: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.enableKeyboardAvoiding()
        especialidadTextField.delegate = self
        fechaTextField.delegate = self
        horaTextField.delegate = self
        
        bindViewModel()
        bindDoctorViewModel()
        cargarEspecialidades()
        configurarPickerEspecialidad()
        configurarPickerHora()
        configurarPickerFecha()
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func validarHora(hora: Date) -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: hora)
        return hour >= 10 && hour < 18
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    @IBAction func registerAppointmentClicked(_ sender: Any) {
        guard let especialidad = selectedSpecialtyForAppointment,
              let fecha = fechaTextField.text, !fecha.isEmpty,
              let hora = horaTextField.text, !hora.isEmpty else {
            alerts.showErrorAlert(title: "Error", message: "Por favor, complete todos los campos.", viewController: self)
            return
        }

        if let doctorId = doctorId {
            let newAppointment = Appointment(
                consultorio: "Consultorio 1",
                especialidadId: especialidad.id ?? "",
                userId: self.userId,
                doctorId: doctorId,
                estado: "Pendiente",
                fecha: fecha,
                hora: hora,
                observaciones: "",
                receta: ""
            )
            appointmentViewModel.createAppointment(newAppointment)
        } else {
            doctorViewModel.getFirstDoctorBySpecialty(specialty: especialidad.id ?? "")
        }
    }
    
    private func bindDoctorViewModel(){
        doctorViewModel.$doctorBySpecialtyState
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .idle:
                    self.loadingOverlay.hide()
                case .loading:
                    self.loadingOverlay.show(in: self.view)
                case .success(let doctor):
                    self.loadingOverlay.hide()
                    self.doctorId = doctor.id

                    if let especialidad = self.selectedSpecialtyForAppointment,
                       let fecha = self.fechaTextField.text, !fecha.isEmpty,
                       let hora = self.horaTextField.text, !hora.isEmpty,
                       let doctorId = doctor.id {

                        let newAppointment = Appointment(
                            consultorio: "Consultorio 1",
                            especialidadId: especialidad.id ?? "",
                            userId: self.userId,
                            doctorId: doctorId,
                            estado: "Pendiente",
                            fecha: fecha,
                            hora: hora,
                            observaciones: "",
                            receta: ""
                        )

                        self.appointmentViewModel.createAppointment(newAppointment)
                    }
                case .failure(let error):
                    self.loadingOverlay.hide()
                    self.alerts.showErrorAlert(title: "Error",
                                               message: error.message,
                                               viewController: self)
                }
            }
            .store(in: &cancellables)
    }
}
