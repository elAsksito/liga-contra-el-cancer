import UIKit
import Combine

class CitaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {


    @IBOutlet weak var citasTableView: UITableView!
    
    let appointmentViewModel = AppointmentViewModel()
    let userViewModel = UserViewModel()
    let specialtyViewModel = SpecialtyViewModel()
    let alerts = Alerts()
    let loadingOverlay = LoadingOverlay()
    
    var cancellables = Set<AnyCancellable>()
    var userStored: User?

    var citasList: [Appointment] = []
    var especialidades: [Specialty] = []

    var especialidadTextField: UITextField?
    var fechaTextField: UITextField?
    var horaTextField: UITextField?

    var vieneDeDetalle = false

    override func viewDidLoad() {
        super.viewDidLoad()
        citasTableView.dataSource = self
        citasTableView.delegate = self
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if vieneDeDetalle {
            let alerta = UIAlertController(title: "Recuerda", message: "No te olvides de llegar 20 minutos antes a tu cita", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Entendido", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
            vieneDeDetalle = false
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citasList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "citaCell", for: indexPath) as! CitaTableViewCell
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.white.cgColor
        let cita = citasList[indexPath.row]

        cell.consultorioLabel.text = cita.consultorio
        cell.pacienteLabel.text = cita.userId
        cell.especialidadLabel.text = cita.especialidadId
        cell.fechaLabel.text = cita.fecha
        cell.horaLabel.text = cita.hora

        return cell
    }

    @IBAction func registrarCitasButton(_ sender: Any) {
        mostrarAlertaCita(titulo: "Registrar Cita", cita: nil, index: nil)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editar = UIContextualAction(style: .normal, title: "Editar") { _, _, complete in
            let cita = self.citasList[indexPath.row]
            self.mostrarAlertaCita(titulo: "Editar Cita", cita: cita, index: indexPath.row)
            complete(true)
        }

        //editar.backgroundColor = .systemGreen

        let eliminar = UIContextualAction(style: .destructive, title: "Eliminar") { _, _, complete in
            let alert = UIAlertController(title: "Confirmar Eliminación", message: "¿Deseas eliminar esta cita?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive) { _ in
                self.citasList.remove(at: indexPath.row)
                self.citasTableView.deleteRows(at: [indexPath], with: .automatic)
            })
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
            self.present(alert, animated: true)
            complete(false)
        }

        return UISwipeActionsConfiguration(actions: [editar, eliminar])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cita = citasList[indexPath.row]
        let main = UIStoryboard(name: "Main", bundle: nil)
        let vcDetalle = main.instantiateViewController(withIdentifier: "citaDetalleView") as! CitaDetalleViewController
        vcDetalle.cita = cita
        self.vieneDeDetalle = true
        navigationController?.pushViewController(vcDetalle, animated: true)
    }
}
