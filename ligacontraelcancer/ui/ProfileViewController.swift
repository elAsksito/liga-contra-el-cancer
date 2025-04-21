//
//  ProfileViewController.swift
//  ligacontraelcancer
//
//  Created by DAMII on 21/04/25.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let userViewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logOut(){
        let result = userViewModel.logout()
        
        switch result {
        case .success(_):
            showAlert(title: "Éxito", message: "Cierre de sesión exitoso")
        case .failure(let error):
            showAlert(title: "Error", message: error.message)
            
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default){ complete in
            if let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as? LoginViewController {
                loginViewController.modalPresentationStyle = .fullScreen
                self.present(loginViewController, animated: true, completion: nil)
            }
        })
        self.present(alert, animated: true)
    }
}
