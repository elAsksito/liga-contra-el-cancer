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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.emailField.endEditing(true)
        self.passwordField.endEditing(true)
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
    
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        passwordField.isSecureTextEntry.toggle()
        let imageName = passwordField.isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
