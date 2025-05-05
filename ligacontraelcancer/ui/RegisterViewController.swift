import UIKit
import Combine

class RegisterViewController: UIViewController {

    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var dniField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var viewContainer: UIView!
    
    let viewModel = RegisterViewModel()
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
    
    @IBAction func registerTapped(_ sender: UIButton){
        guard let name = nameField.text, !name.isEmpty,
        let surname = surnameField.text, !surname.isEmpty,
        let dni = dniField.text, !dni.isEmpty,
        let email = emailField.text, !email.isEmpty,
        let password = passwordField.text, !password.isEmpty else{
            alerts.showErrorAlert(title: "Campos vacíos",
                                  message: "Por favor, completa todos los campos",
                                  viewController: self)
            return
        }
        viewModel.registerUser(name: name, surname: surname, dni: dni, email: email, password: password)
    }
    
    private func bindViewModel(){
        viewModel.$registerState
            .receive(on: RunLoop.main)
            .sink{[weak self] state in
                guard let self = self else { return }
                
                switch state{
                case .idle:
                    self.loadingOverlay.hide()
                case .loading:
                    loadingOverlay.show(in: self.view)
                case .success((_, _)):
                    alerts.showSuccessAlert(title: "Registro exitoso",
                        message: "Por favor inicie sesión para continuar",
                        viewController: self) {
                        return self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as? LoginViewController
                        }
                case .failure(let error):
                    alerts.showErrorAlert(title: "Error",
                        message: error.message,
                        viewController: self)
                    self.loadingOverlay.hide()
                }
            }
            .store(in: &cancellables)
    }
}
