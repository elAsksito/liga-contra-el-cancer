import Foundation
import UIKit

struct Concealer{
    static func concealerViewController() -> UIViewController{
        let storyboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() else {
            fatalError("Cannot get Concealer")
        }
        
        return viewController
    }
}
