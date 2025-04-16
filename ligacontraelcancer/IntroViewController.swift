import UIKit

class IntroViewController: UIViewController {

    @IBOutlet weak var logoWhiteImageView: UIImageView!
    var logoOriginalImageView: UIImageView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let whiteBackgroundView = UIView(frame: self.view.bounds)
        whiteBackgroundView.backgroundColor = .white
        self.view.insertSubview(whiteBackgroundView, belowSubview: logoWhiteImageView)

        let maskLayer = CAShapeLayer()
        let center = self.view.center

        let initialCirclePath = UIBezierPath(ovalIn: CGRect(x: center.x - 1, y: center.y - 1, width: 2, height: 2))
        let maxRadius = sqrt(pow(self.view.bounds.width, 2) + pow(self.view.bounds.height, 2))
        let finalCircleRect = CGRect(x: center.x - maxRadius, y: center.y - maxRadius, width: maxRadius * 2, height: maxRadius * 2)
        let finalCirclePath = UIBezierPath(ovalIn: finalCircleRect)

        maskLayer.path = initialCirclePath.cgPath
        whiteBackgroundView.layer.mask = maskLayer

        logoOriginalImageView = UIImageView(image: UIImage(named: "logo_liga_contra_el_cancer"))
        logoOriginalImageView.sizeToFit()
        logoOriginalImageView.center = self.view.center
        logoOriginalImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        logoOriginalImageView.alpha = 0
        self.view.addSubview(logoOriginalImageView)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

            UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseInOut], animations: {
                self.logoWhiteImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.logoWhiteImageView.alpha = 0
            })

            let maskAnimation = CABasicAnimation(keyPath: "path")
            maskAnimation.fromValue = initialCirclePath.cgPath
            maskAnimation.toValue = finalCirclePath.cgPath
            maskAnimation.duration = 1.5
            maskAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            maskAnimation.fillMode = .forwards
            maskAnimation.isRemovedOnCompletion = false
            maskLayer.add(maskAnimation, forKey: "revealCircle")

            UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseInOut], animations: {
                self.logoOriginalImageView.alpha = 1
                self.logoOriginalImageView.transform = CGAffineTransform.identity
            })

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.goToMain()
            }
        }
    }

    func goToMain() {
        if let initNavigationController = storyboard?.instantiateViewController(withIdentifier: "initNavigationController") as? UINavigationController {
            initNavigationController.modalPresentationStyle = .fullScreen
            present(initNavigationController, animated: true, completion: nil)
        }
    }
}
