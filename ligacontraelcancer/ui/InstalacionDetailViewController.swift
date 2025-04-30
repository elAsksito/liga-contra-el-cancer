import UIKit

class InstalacionDetailViewController: UIViewController {

    var instalacion: Instalacion?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let instalacion = instalacion {
            // Mostrar los detalles de la especialidad
            print("Instalacion seleccionada: \(instalacion.title)")
            // Aquí puedes actualizar las etiquetas, imágenes, etc., con los detalles de la especialidad
        }
    }
    
}
