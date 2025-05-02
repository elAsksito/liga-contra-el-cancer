import UIKit

class DoctorDetailViewController: UIViewController {

    var doctor: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let doctor = doctor {
            print("Doctor seleccionado: \(doctor.name)")
        }
    }
    

}
