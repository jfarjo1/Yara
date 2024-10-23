//
//  UINavigationController.swift
//  Yara
//
//  Created by Johnny Owayed on 15/10/2024.
//

import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
    func fadeTo(_ viewController: UIViewController) {
//        view.backgroundColor = .white
//        view.layer.backgroundColor = UIColor.white.cgColor
//        let transition: CATransition = CATransition()
//        transition.duration = 0.3
//        transition.type = CATransitionType.fade
//        view.layer.add(transition, forKey: nil)
        viewController.hidesBottomBarWhenPushed = true
        self.pushViewController(viewController, animated: true)
    }
    
    func popWithFade() {
//        view.backgroundColor = .white
//        view.layer.backgroundColor = UIColor.white.cgColor
//        let transition: CATransition = CATransition()
//        transition.duration = 0.3
//        transition.type = CATransitionType.fade
//        view.layer.add(transition, forKey: nil)
        self.popViewController(animated: true)
    }
}
