import UIKit

struct Especialidad {
    let title: String
    let portadaE: String
}

struct Doctor{
    let title: String
    let portadaD: String
}

struct Instalacion {
    let title: String
    let portadaI: String
}

class ItemViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var itemsCollectionView: UICollectionView!
    @IBOutlet weak var itemSegmentedControl: UISegmentedControl!
    
    var especialidadList: [Especialidad] = []  // Este array contendrá los datos a mostrar en el CollectionView
    var doctorList: [Doctor] = []  // Este array contendrá los datos a mostrar en el CollectionView
    var instalacionList: [Instalacion] = []  // Este array contendrá los datos a mostrar en el CollectionView
    var currentTitles: [String] = []
    var currentImages: [String] = []
    
    
    let paddingInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
    let numberOfItemsPerRow: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Configuración del collectionView
        itemsCollectionView.dataSource = self
        itemsCollectionView.delegate = self

        //Listado de Imagenes de Cada Pestania
        //ESPECIALIDAD
        especialidadList.append(Especialidad(title: "Oncologia", portadaE: "oncologia"))
        especialidadList.append(Especialidad(title: "Ginecologia", portadaE: "ginecologia"))
        especialidadList.append(Especialidad(title: "Radioterapia", portadaE: "radioterapia"))
        especialidadList.append(Especialidad(title: "Cirugia Quirurgica", portadaE: "cirugiaquir"))
        especialidadList.append(Especialidad(title: "Urologia", portadaE: "urologia"))
        especialidadList.append(Especialidad(title: "Pediatria", portadaE: "pediatria"))
        //DOCTORES
        doctorList.append(Doctor(title: "Antonio Sanchez", portadaD: "anto"))
        doctorList.append(Doctor(title: "Sergio Diaz", portadaD: "ser"))
        doctorList.append(Doctor(title: "Cesar Flores", portadaD: "cesr"))
        doctorList.append(Doctor(title: "Allan Sagastegui", portadaD: "alla"))
        doctorList.append(Doctor(title: "Nicolas Poma", portadaD: "doct"))
        doctorList.append(Doctor(title: "Einer Chavez", portadaD: "einer"))
        doctorList.append(Doctor(title: "Juan Salaz", portadaD: "doctor"))
        //INSTALACIONES
        instalacionList.append(Instalacion(title: "Centro de Lima", portadaI: "centroLima"))
        instalacionList.append(Instalacion(title: "Trujillo", portadaI: "trujillo"))
        instalacionList.append(Instalacion(title: "Pueblo Libre", portadaI: "puebloLibre"))
        instalacionList.append(Instalacion(title: "Arequipa", portadaI: "ligaArequipa"))
        instalacionList.append(Instalacion(title: "La Risalda", portadaI: "laRisalda"))
        instalacionList.append(Instalacion(title: "Surquillo", portadaI: "ligaSurq"))
        
        // Inicial por defecto
        currentTitles.removeAll()
        currentImages.removeAll()
        for item in especialidadList {
            currentTitles.append(item.title)
            currentImages.append(item.portadaE)
        }
        
    }
    @IBAction func segmentedControlChanged(_ sender: Any) {
        currentTitles.removeAll()
        currentImages.removeAll()
        
        switch itemSegmentedControl.selectedSegmentIndex {
           case 0:
               for item in especialidadList {
                   currentTitles.append(item.title)
                   currentImages.append(item.portadaE)
               }
           case 1:
               for item in doctorList {
                   currentTitles.append(item.title)
                   currentImages.append(item.portadaD)
               }
           case 2:
               for item in instalacionList {
                   currentTitles.append(item.title)
                   currentImages.append(item.portadaI)
               }
           default:
               break
           }
        itemsCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellItem", for: indexPath) as! ItemCollectionViewCell
        cell.titleLbl.text = currentTitles[indexPath.row]
        cell.itemImageView.image = UIImage(named: currentImages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return paddingInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingLateralSpace = paddingInset.left + paddingInset.right
        let internalSpace = (numberOfItemsPerRow - 1 ) * 10
        let availableWidth = collectionView.bounds.width - paddingLateralSpace - internalSpace
        let widthPerItem = availableWidth / numberOfItemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }

} //FIN DE LA CLASE PRINCIPAL

extension ItemViewController {
    
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Usamos un switch para manejar los diferentes casos según el segmento seleccionado
        switch itemSegmentedControl.selectedSegmentIndex {
        case 0: // Especialidades
            let selectedEspecialidad = especialidadList[indexPath.row]
            performSegue(withIdentifier: "showEspecialidadDetail", sender: selectedEspecialidad)
           
        case 1: // Doctores
            let selectedDoctor = doctorList[indexPath.row]
           performSegue(withIdentifier: "showDoctorDetail", sender: selectedDoctor)
            
        case 2: // Instalaciones
           let selectedInstalacion = instalacionList[indexPath.row]
           performSegue(withIdentifier: "showInstalacionDetail", sender: selectedInstalacion)
            
        default:
            break
        }
    }
    
    // Este método es para preparar los datos antes del segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Usamos un switch para manejar los diferentes segues
        switch segue.identifier {
       case "showEspecialidadDetail":
           if let destinationVC = segue.destination as? EspecialidadDetailViewController {
               if let selectedEspecialidad = sender as? Especialidad {
                    destinationVC.especialidad = selectedEspecialidad
                }
            }
            
        case "showDoctorDetail":
            if let destinationVC = segue.destination as? DoctorDetailViewController {
               if let selectedDoctor = sender as? Doctor {
                    destinationVC.doctor = selectedDoctor
               }
            }
            
        case "showInstalacionDetail":
           if let destinationVC = segue.destination as? InstalacionDetailViewController {
               if let selectedInstalacion = sender as? Instalacion {
                   destinationVC.instalacion = selectedInstalacion
                }
            }
           
        default:
            break
       }
    }
}
