import UIKit

extension UIStackView {
    func applyBorder(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        let backgroundView = UIView(frame: bounds)
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.layer.cornerRadius = cornerRadius
        backgroundView.layer.borderWidth = borderWidth
        backgroundView.layer.borderColor = borderColor.cgColor
        backgroundView.clipsToBounds = true
        insertSubview(backgroundView, at: 0)
    }
}

