import UIKit

class EspecialidadDetailViewController: UIViewController {
    
    @IBOutlet weak var imageEspecialidad: UIImageView!
    @IBOutlet weak var nameEspecialidad: UILabel!
    @IBOutlet weak var descripcionEspecialidad: UILabel!
    
    var especialidad: Specialty?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEspecialidadData()
    }
    
    private func setEspecialidadData(){
        if let especialidad = especialidad {
            nameEspecialidad.text = especialidad.nombre
            descripcionEspecialidad.text = especialidad.description
            
            let placeholder = UIImage(systemName: "photo.fill")
            if let url = URL(string: especialidad.image) {
                imageEspecialidad.sd_setImage(with: url, placeholderImage: placeholder)
            } else {
                imageEspecialidad.image = placeholder
                imageEspecialidad.tintColor = .black
            }
        }
    }
}
