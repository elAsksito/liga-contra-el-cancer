import UIKit
import Combine

class CitaDetalleViewController: UIViewController {
    
    
    
    @IBOutlet weak var viewConteiner: UIView!
    @IBOutlet weak var doctorLabel: UILabel!
    @IBOutlet weak var especialidadLabel: UILabel!
    @IBOutlet weak var fechaLabel: UILabel!
    @IBOutlet weak var horaLabel: UILabel!
    
    var cita: AppointmentDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewConteiner.layer.cornerRadius = 16
        if let detalle = cita {
            doctorLabel.text = detalle.doctorName
            especialidadLabel.text = detalle.specialtyName
            fechaLabel.text = detalle.appointment.fecha
            horaLabel.text = detalle.appointment.hora
        }
    }
}
