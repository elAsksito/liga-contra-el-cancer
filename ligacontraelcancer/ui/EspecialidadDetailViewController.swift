import UIKit

class EspecialidadDetailViewController: UIViewController {
    
    
    
    @IBOutlet weak var imageEspecialidad: UIImageView!
    @IBOutlet weak var nameEspecialidad: UILabel!
    
    var especialidad: Specialty?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let especialidad = especialidad {
            nameEspecialidad.text = especialidad.nombre
            imageEspecialidad.image = UIImage(named: especialidad.image)
        }
    }
    
}
