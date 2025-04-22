import UIKit

extension UITextField {
    func enablePasswordToggle() {
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        eyeButton.tintColor = .gray
        eyeButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        eyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
        eyeButton.center = CGPoint(x: paddingView.bounds.midX, y: paddingView.bounds.midY)
        paddingView.addSubview(eyeButton)

        self.rightView = paddingView
        self.rightViewMode = .always
        self.isSecureTextEntry = true
    }

    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        self.isSecureTextEntry.toggle()
        let imageName = self.isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
        
        if let existingText = self.text, isSecureTextEntry {
            self.deleteBackward()
            self.insertText(existingText)
        }
    }
}
