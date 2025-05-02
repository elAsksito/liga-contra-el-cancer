import UIKit

extension SceneDelegate{
    func showConcealer(){
        guard let windowScene = window?.windowScene else{
            return
        }
        
        let concealerViewController = Concealer.concealerViewController()
        concealerWindow = UIWindow(windowScene: windowScene)
        concealerWindow?.rootViewController = concealerViewController
        concealerWindow?.makeKeyAndVisible()
    }
    
    func hideConcealer(){
        concealerWindow?.isHidden = true
        concealerWindow = nil
    }
}
