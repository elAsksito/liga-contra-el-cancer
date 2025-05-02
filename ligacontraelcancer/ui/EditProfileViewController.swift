import UIKit
import Combine
import SDWebImage

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var surnameText: UITextField!
    @IBOutlet weak var dniText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    
    let viewModel = UserViewModel()
    let alerts = Alerts()
    let loadingOverlay = LoadingOverlay()
    let storedUserId = UserDefaults.standard.string(forKey: "userId") ?? ""
    
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enableKeyboardAvoiding()
        bindViewModel()
        loadUserInformation()
        redondearImagen()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func imagePicker(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func updateUserInformation() {
        guard case let .success(user) = viewModel.userById else {
            alerts.showErrorAlert(title: "Error", message: "No se pudo obtener el usuario actual.", viewController: self)
            return
        }

        var updatedUser = user
        updatedUser.name = nameText.text ?? user.name
        updatedUser.surname = surnameText.text ?? user.surname
        updatedUser.dni = dniText.text ?? user.dni
        updatedUser.phone = phoneText.text ?? user.phone

        let nuevaImagen = profileImage.image

        viewModel.updateUser(userId: storedUserId, updatedUser: updatedUser, image: nuevaImagen)
    }

    private func redondearImagen() {
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleAspectFill
    }

    // Delegado
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let imagenSeleccionada = info[.editedImage] as? UIImage {
            profileImage.image = imagenSeleccionada
        } else if let imagenOriginal = info[.originalImage] as? UIImage {
            profileImage.image = imagenOriginal
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Delegado
    
    private func loadUserInformation(){
        viewModel.getUserById(uid: storedUserId)
    }
    
    private func bindViewModel(){
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
                    self.surnameText.text = user.surname
                    self.dniText.text = user.dni
                    self.phoneText.text = user.phone
                    
                case .failure(let error):
                    self.loadingOverlay.hide()
                    alerts.showErrorAlert(title: "Error",
                                          message: error.message,
                                          viewController: self)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$updateState
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .idle:
                    break
                case .loading:
                    loadingOverlay.show(in: self.view)
                case .success(_):
                    loadingOverlay.hide()
                    alerts.showSuccessAlert(title: "Éxito",
                                            message: "Usted actualizó sus datos satisfactoriamente",
                                            viewController: self) {
                        
                        guard let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "initTabBarController") as? UITabBarController else {
                            return nil
                        }
                        
                        tabBarController.selectedIndex = 2
                        return tabBarController
                    }

                case .failure(let error):
                    loadingOverlay.hide()
                    alerts.showErrorAlert(title: "Error", message: error.message, viewController: self)
                }
            }
            .store(in: &cancellables)

    }
    
    
    
    
}
