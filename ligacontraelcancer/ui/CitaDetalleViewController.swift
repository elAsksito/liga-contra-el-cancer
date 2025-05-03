import UIKit

class CitaDetalleViewController: UIViewController {
    
    
    
    @IBOutlet weak var consultorioLabel: UILabel!
    
    @IBOutlet weak var pacienteLabel: UILabel!
    
    @IBOutlet weak var especialidadLabel: UILabel!
    
    @IBOutlet weak var fechaLabel: UILabel!
    
    @IBOutlet weak var horaLabel: UILabel!
    
    var cita: AppointmentDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let detalle = cita {
            consultorioLabel.text = detalle.appointment.consultorio
            pacienteLabel.text = detalle.appointment.userId
            especialidadLabel.text = detalle.appointment.especialidadId
            fechaLabel.text = detalle.appointment.fecha
            horaLabel.text = detalle.appointment.hora
        }
        
    }
}
