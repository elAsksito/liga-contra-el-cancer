import UIKit
import Combine

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var viewContainer: UIView!
    
    let viewModel = LoginViewModel()
    let alerts = Alerts()
    let loadingOverlay = LoadingOverlay()
    
    var cancellables = Set<AnyCancellable>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enableKeyboardAvoiding()
        bindViewModel()
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
                                  message: "Por favor, complete todos los campos",
                                  viewController: self)
            return
        }
        
        viewModel.login(email: email, password: password)
    }
    
    private func bindViewModel(){
        viewModel.$loginState
            .receive(on: RunLoop.main)
            .sink{[weak self] state in
                guard let self = self else { return }
                
                switch state {
                case .idle:
                    self.loadingOverlay.hide()
                case .loading:
                    loadingOverlay.show(in: self.view)
                case .success(let user):
                    self.loadingOverlay.hide()
                    alerts.showSuccessAlert(title: "Bienvenido",
                                            message: "Sesión iniciada como \(user.email ?? "Usuario")",
                                            viewController: self) {
                                return self.storyboard?.instantiateViewController(withIdentifier: "initTabBarController") as? UITabBarController
                            }
                case .failure(let error):
                    self.loadingOverlay.hide()
                    alerts.showErrorAlert(title: "Error",
                                          message: error.message,
                                          viewController: self)
                }
            }
            .store(in: &cancellables)
    }
}
