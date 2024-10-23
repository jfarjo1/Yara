//
//  TabBarController.swift
//  Yara
//
//  Created by Johnny on 14/10/2024.
//


import UIKit


class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        self.view.backgroundColor = .white
        
        if #available(iOS 13, *) {
            // iOS 13:
            let appearance = tabBar.standardAppearance
            appearance.configureWithOpaqueBackground()
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            tabBar.standardAppearance = appearance
        } else {
            // iOS 12 and below:
            tabBar.shadowImage = UIImage()
            tabBar.backgroundImage = UIImage()
        }
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //
    //        let helpCenterVC = HelpCenterUi.buildHelpCenterOverviewUi(withConfigs: [])
    //        //assigning name and icon to the viewcontroller which will appear on tab bar
    //        let icon = UITabBarItem(title: "", image: UIImage(named:"userF.png"), selectedImage: nil)
    //        helpCenterVC.tabBarItem = icon
    //        helpCenterVC.tabBarItem.tag = 3
    //        helpCenterVC.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -9, right: 0)
    //
    //        let vc3 = UINavigationController(rootViewController: helpCenterVC)
    //        var array = self.viewControllers
    //        //array?.append(helpCenterVC)
    //        array?.append(vc3)
    //        self.viewControllers = array
    //    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        TapticEngine.impact.feedback(.light)
        
        guard let idx = tabBar.items?.firstIndex(of: item),
              tabBar.subviews.count > idx + 1,
              let tabBarButton = tabBar.subviews[idx + 1] as? UIControl else {
            return
        }
        
        // Check if the item is already selected to avoid unnecessary animation
        guard selectedIndex != idx else { return }
        
        UIView.animate(withDuration: 0.3, delay : 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            tabBarButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                tabBarButton.transform = .identity
            }
        }
    }
    
    
}

extension TabBarController: UITabBarControllerDelegate {
    
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        tabBarController.tabBar.layer.borderWidth = 0
        tabBarController.tabBar.clipsToBounds = true
        
        return MyTransition(viewControllers: tabBarController.viewControllers)
    }
    
    
}

class MyTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let viewControllers: [UIViewController]?
    let transitionDuration: Double = 0.22
    
    init(viewControllers: [UIViewController]?) {
        self.viewControllers = viewControllers
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(transitionDuration)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let fromView = fromVC.view,
            let fromIndex = getIndex(forViewController: fromVC),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let toView = toVC.view,
            let toIndex = getIndex(forViewController: toVC)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        let frame = transitionContext.initialFrame(for: fromVC)
        var fromFrameEnd = frame
        var toFrameStart = frame
        fromFrameEnd.origin.x = toIndex > fromIndex ? frame.origin.x - frame.width : frame.origin.x + frame.width
        toFrameStart.origin.x = toIndex > fromIndex ? frame.origin.x + frame.width : frame.origin.x - frame.width
        toView.frame = toFrameStart
        
        DispatchQueue.main.async {
            transitionContext.containerView.addSubview(toView)
            UIView.animate(withDuration: self.transitionDuration, animations: {
                fromView.frame = fromFrameEnd
                toView.frame = frame
            }, completion: { success in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(success)
            })
        }
    }
    
    func getIndex(forViewController vc: UIViewController) -> Int? {
        guard let vcs = viewControllers else { return nil }
        for (index, thisVC) in vcs.enumerated() {
            if thisVC == vc { return index }
        }
        return nil
    }
}

