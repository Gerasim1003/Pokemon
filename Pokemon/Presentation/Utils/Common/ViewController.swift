//
//  ViewController.swift
//  Pokemon
//
//  Created by Gerasim Israyelyan on 29.10.21.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - Views
    
    private var loadingView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Public methods
    
    func showError(_ message: String?) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            self.setupLoadingView()            
        }
    }
    
    func hideLoading() {
        loadingView?.hide(animation: true, animationDuration: 0.25, completion: {
            self.loadingView?.removeFromSuperview()
            self.loadingView = nil
        })
    }
}

// MARK: - Private methods

private extension ViewController {
    private func setupLoadingView() {
        guard loadingView == nil else { return }
        loadingView = UIView(frame: .zero)
        loadingView?.translatesAutoresizingMaskIntoConstraints = false
        loadingView?.frame = view.bounds
        loadingView?.backgroundColor = .white
        view.addSubview(loadingView!)
        loadingView?.pinEdgesToSuperView()

        view.layoutSubviews()
        let activityIndicator = UIActivityIndicatorView(frame: .zero)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .medium
        activityIndicator.startAnimating()
        loadingView?.addSubview(activityIndicator)
        activityIndicator.pinCenterToSuperView()
    }
}
