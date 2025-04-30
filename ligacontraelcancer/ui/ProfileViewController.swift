import UIKit
import Combine
import SDWebImage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var bottomView: UIView!
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var roleText: UILabel!
    @IBOutlet weak var dniText: UILabel!
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var phoneText: UILabel!
    
    @IBOutlet weak var phoneTitleText: UILabel!
    
    
    let viewModel = UserViewModel()
    let alerts = Alerts()
    let loadingOverlay = LoadingOverlay()
    
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        loadUserInformation()
        redondearImagen()
        
        let cornerRadius: CGFloat = 20.0
        bottomView.layer.cornerRadius = cornerRadius
        bottomView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    @IBAction func logOut(){
        viewModel.logout()
    }
    
    private func redondearImagen() {
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
    }
    
    private func loadUserInformation(){
        let storedUserId = UserDefaults.standard.string(forKey: "userId") ?? ""
        viewModel.getUserById(uid: storedUserId)
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
        
        viewModel.$userById
            .receive(on: RunLoop.main)
            .sink{[weak self] state in
                guard let self = self else {return}
                switch state {
                case .idle:
                    self.loadingOverlay.hide()
                case .loading:
                    loadingOverlay.show(in: self.view)
                case .success(let user):
                    self.loadingOverlay.hide()
                    
                    let placeholder = UIImage(systemName: "person.crop.circle.fill")
                        if let url = URL(string: user.profileImageUrl) {
                            self.profileImage.sd_setImage(with: url, placeholderImage: placeholder)
                        } else {
                            self.profileImage.image = placeholder
                        }

                    self.nameText.text = user.name
                    self.roleText.text = user.rol
                    self.dniText.text = user.dni
                    self.emailText.text = user.email
                    if user.phone.isEmpty {
                        self.phoneTitleText.isHidden = true
                        self.phoneText.isHidden = true
                    } else {
                        self.phoneTitleText.isHidden = false
                        self.phoneText.text = user.phone
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
