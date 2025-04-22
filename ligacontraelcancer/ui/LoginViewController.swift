import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var viewContainer: UIView!
    
    let viewModel = LoginViewModel()
    let alerts = Alerts()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enableKeyboardAvoiding()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        viewContainer.layer.cornerRadius = 16
        passwordField.enablePasswordToggle()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func loginTapped(_ sender: UIButton){
        guard let email = emailField.text, !email.isEmpty,
        let password = passwordField.text, !password.isEmpty else {
            alerts.showErrorAlert(title: "Campos vacíos",
                                              message: "Por favor, completa todos los campos",
                                              viewController: self)
            return
        }
        
        Task{
            let result = await viewModel.login(
                email: emailField.text ?? "",
                password: passwordField.text ?? ""
            )
            
            switch result{
            case .success(let user):
                alerts.showSuccessAlert(title: "Bienvenido",
                    message: "Sesión iniciada como \(user.email ?? "Usuario")",
                    viewController: self) {
                        return self.storyboard?.instantiateViewController(withIdentifier: "initTabBarController") as? UITabBarController
                    }
            case .failure(let error):
                alerts.showErrorAlert(title: "Error",
                    message: error.message,
                    viewController: self)
            }
        }
    }
}
