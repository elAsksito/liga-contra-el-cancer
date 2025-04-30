//
//  EspecialidadDetailViewController.swift
//  ligacontraelcancer
//
//  Created by DAMII on 30/04/25.
//

import UIKit

class EspecialidadDetailViewController: UIViewController {
    
    
    
    @IBOutlet weak var imageEspecialidad: UIImageView!
    @IBOutlet weak var nameEspecialidad: UILabel!
    
    var especialidad: Especialidad?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let especialidad = especialidad {
            nameEspecialidad.text = especialidad.title
            imageEspecialidad.image = UIImage(named: especialidad.portadaE)
        }
    }
    
}
