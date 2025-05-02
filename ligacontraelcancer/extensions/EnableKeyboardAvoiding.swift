import UIKit

extension UIViewController {
    func enableKeyboardAvoiding() {
        NotificationCenter.default.addObserver(self, selector: #selector(_keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func _keyboardWillShow( notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let activeField = self.view.findFirstResponder() else { return }

        let fieldFrame = activeField.convert(activeField.bounds, to: self.view)

        let keyboardMinY = self.view.frame.height - keyboardFrame.height
        let fieldMaxY = fieldFrame.maxY

        if fieldMaxY > keyboardMinY {
            let moveDistance = fieldMaxY - keyboardMinY + 30

            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -moveDistance
            }
        }
    }

    @objc private func _keyboardWillHide( notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
}

extension UIView {
    func findFirstResponder() -> UIView? {
        if self.isFirstResponder { return self }

        for subview in self.subviews {
            if let responder = subview.findFirstResponder() {
                return responder
            }
        }

        return nil
    }
}
