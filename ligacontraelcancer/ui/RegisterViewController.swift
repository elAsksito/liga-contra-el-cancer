import UIKit

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var dniField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var viewContainer: UIView!
    
    let viewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        viewContainer.layer.cornerRadius = 16
        
        let eyeButton = UIButton(type: .custom)
            eyeButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            eyeButton.tintColor = .gray
            eyeButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
            eyeButton.center = CGPoint(x: paddingView.bounds.midX, y: paddingView.bounds.midY)
            paddingView.addSubview(eyeButton)
        
        passwordField.rightView = paddingView
        passwordField.rightViewMode = .always
    }
    
    @IBAction func registerTapped(_ sender: UIButton){
        guard let name = nameField.text, !name.isEmpty,
        let surname = surnameField.text, !surname.isEmpty,
        let dni = dniField.text, !dni.isEmpty,
        let email = emailField.text, !email.isEmpty,
        let password = passwordField.text, !password.isEmpty else{
            showAlert(title: "Campos vacíos", message: "Por favor, completa todos los campos")
            return
        }
        
        Task{
            let result = await viewModel.registerUser(
                name: name,
                surname: surname,
                dni: dni,
                email: email,
                password: password)
            
            switch result{
            case .success( _):
                showAlert(title: "Registro exitoso", message: "Por favor inicie sesión para continuar")
            case .failure(let error):
                showErrorAlert(title: "Error", message: error.message)
            }
            
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
    
    private func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        passwordField.isSecureTextEntry.toggle()
        let imageName = passwordField.isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
