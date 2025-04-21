import UIKit

class Alerts {
    
    // MARK: - Success Alert
    func showSuccessAlert(title: String,
                          message: String,
                          viewController: UIViewController,
                          actionTitle: String = "OK",
                          destinationViewController: (() -> UIViewController?)? = nil) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: actionTitle, style: .default) { _ in
            if let destinationVC = destinationViewController?() {
                destinationVC.modalPresentationStyle = .fullScreen
                viewController.present(destinationVC, animated: true, completion: nil)
            }
        })

        viewController.present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(title: String,
                        message: String,
                        viewController: UIViewController,
                        actionTitle: String = "OK") {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
