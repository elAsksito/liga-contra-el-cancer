import UIKit
import Combine

class ProfileViewController: UIViewController {
    
    let viewModel = UserViewModel()
    let alerts = Alerts()
    let loadingOverlay = LoadingOverlay()
    
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    @IBAction func logOut(){
        viewModel.logout()
    }
    
    private func bindViewModel(){
        viewModel.$userState
            .receive(on: RunLoop.main)
            .sink{[weak self] state in
                guard let self = self else {return}
                
                switch state {
                case .idle:
                    self.loadingOverlay.hide()
                case .loading:
                    loadingOverlay.show(in: self.view)
                case .success(_):
                    self.loadingOverlay.hide()
                    alerts.showSuccessAlert(title: "Éxito", message: "Cierre de sesión exitoso", viewController: self){
                        return
                            self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as? LoginViewController
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

