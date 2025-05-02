import UIKit

class CitaDetalleViewController: UIViewController {
    
    
    
    @IBOutlet weak var consultorioLabel: UILabel!
    
    @IBOutlet weak var pacienteLabel: UILabel!
    
    @IBOutlet weak var especialidadLabel: UILabel!
    
    @IBOutlet weak var fechaLabel: UILabel!
    
    @IBOutlet weak var horaLabel: UILabel!
    
    var cita: Appointment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let cita = cita {
            consultorioLabel.text = cita.consultorio
            pacienteLabel.text = cita.userId
            especialidadLabel.text = cita.especialidadId
            fechaLabel.text = cita.fecha
            horaLabel.text = cita.hora
        }
        
    }
}
