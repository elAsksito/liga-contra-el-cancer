import UIKit

extension HomeViewController {
    
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch itemSegmentedControl.selectedSegmentIndex {
        case 0:
            let selectedEspecialidad = especialidadList[indexPath.row]
            performSegue(withIdentifier: "showEspecialidadDetails", sender: selectedEspecialidad)
           
        case 1:
            let selectedDoctor = doctorList[indexPath.row]
           performSegue(withIdentifier: "showDoctorDetails", sender: selectedDoctor)
        default:
            break
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
       case "showEspecialidadDetails":
           if let destinationVC = segue.destination as? EspecialidadDetailViewController {
               if let selectedEspecialidad = sender as? Specialty {
                    destinationVC.especialidad = selectedEspecialidad
                }
            }
            
        case "showDoctorDetails":
            if let destinationVC = segue.destination as? DoctorDetailViewController {
               if let selectedDoctor = sender as? User {
                    destinationVC.doctor = selectedDoctor
               }
            }
           
        default:
            break
       }
    }
}
