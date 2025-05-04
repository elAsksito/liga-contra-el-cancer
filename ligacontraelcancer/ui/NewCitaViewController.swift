import UIKit
import Combine

class NewCitaViewController: UIViewController {
    
    
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

    func verificarHorario(horaSeleccionada: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        guard let hora = formatter.date(from: horaSeleccionada) else { return false }

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: hora)

        return !(hour < 10 || hour >= 18)
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
        
        var especialidadId = especialidad.id ?? ""
        
        if(doctorId == nil){
            doctorViewModel.getFirstDoctorBySpecialty(specialty: especialidadId)
        }
        
                
        let newAppointment = Appointment(
            consultorio: "Consultorio 1",
            especialidadId: especialidadId,
            userId: userId,
            doctorId: doctorId!,
            estado: "Pendiente",
            fecha: fecha,
            hora: hora,
            observaciones: "",
            receta: ""
        )
                
        appointmentViewModel.createAppointment(newAppointment)
    }
    
    private func bindDoctorViewModel(){
        doctorViewModel.$doctorBySpecialtyState
            .receive(on: RunLoop.main)
            .sink{[weak self] state in
                guard let self = self else {return}
                switch state{
                case .idle:
                    self.loadingOverlay.hide()
                case .loading:
                    loadingOverlay.show(in: self.view)
                case .success(let doctor):
                    self.loadingOverlay.hide()
                    doctorId = doctor.id
                case .failure(let error):
                    self.loadingOverlay.hide()
                    alerts.showErrorAlert(title: "Error",
                                          message: error.message,
                                          viewController: self)
                }
            }
            .store(in: &cancellables)
    }
    
}
