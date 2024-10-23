//
//  UIViewController+extension.swift
//  Yara
//
//  Created by Johnny Owayed on 14/10/2024.
//
import UIKit

extension UIViewController {
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if let navigationController = navigationController, navigationController.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if let tabBarController = tabBarController, tabBarController.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
    func showLoader() -> UIActivityIndicatorView {
        
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating()
        self.view.addSubview(loadingIndicator)
        loadingIndicator.center = self.view.center
        
        return loadingIndicator
    }
    
    func hideLoader(loader: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            loader.stopAnimating()
        }
        
    }
}
