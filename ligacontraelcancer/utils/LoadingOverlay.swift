import UIKit

class LoadingOverlay {

    private var overlayView: UIView?
    private var activityIndicator: UIActivityIndicatorView?

    func show(in view: UIView) {
        guard overlayView == nil else { return }
        
        overlayView = UIView(frame: view.bounds)
        overlayView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView?.translatesAutoresizingMaskIntoConstraints = false

        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.color = .white
        activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator?.startAnimating()

        if let activityIndicator = activityIndicator, let overlayView = overlayView {
            overlayView.addSubview(activityIndicator)

            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor)
            ])
        }
        
        if let overlayView = overlayView {
            view.addSubview(overlayView)
            NSLayoutConstraint.activate([
                overlayView.topAnchor.constraint(equalTo: view.topAnchor),
                overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    }

    func hide() {
        overlayView?.removeFromSuperview()
        overlayView = nil
        activityIndicator?.stopAnimating()
        activityIndicator = nil
    }
}
