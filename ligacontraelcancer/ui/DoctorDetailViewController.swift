//
//  DoctorDetailViewController.swift
//  ligacontraelcancer
//
//  Created by DAMII on 30/04/25.
//

import UIKit

class DoctorDetailViewController: UIViewController {

    var doctor: Doctor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let doctor = doctor {
            print("Doctor seleccionado: \(doctor.title)")
        }
    }
    

}
