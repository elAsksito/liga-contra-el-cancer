import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var viewContainer: UIView!
    
    let viewModel = LoginViewModel()
    
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
    
    
    @IBAction func loginTapped(_ sender: UIButton){
        guard let email = emailField.text, !email.isEmpty,
        let password = passwordField.text, !password.isEmpty else {
            showAlert(title: "Campos vacíos", message: "Por favor, completa todos los campos")
            return
        }
        
        Task{
            let result = await viewModel.login(
                email: emailField.text ?? "",
                password: passwordField.text ?? ""
            )
            
            switch result{
            case .success(let user):
                showAlert(title: "Bienvenido", message: "Sesión iniciada como \(user.email ?? "Usuario")")
            case .failure(let error):
                showAlert(title: "Error", message: error.message)
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default){ complete in
            if let initTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "initTabBarController") as? UITabBarController {
                initTabBarController.modalPresentationStyle = .fullScreen
                self.present(initTabBarController, animated: true, completion: nil)
            }
        })
            self.present(alert, animated: true)
    }
    
    @objc func togglePasswordVisibility(_ sender: UIButton) {
        passwordField.isSecureTextEntry.toggle()
        let imageName = passwordField.isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
