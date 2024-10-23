//
//  Onb.swift
//  Yara
//
//  Created by Johnny on 13/10/2024.
//

import UIKit

class Onb: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    lazy var orderedViewControllers: [UIViewController] = {
        return [newViewController(identifier: "OnbOne"),
                newViewController(identifier: "OnbTwo")]
    }()
    
    var pageControl = UIPageControl()
    var forwardButton = UIButton(type: .custom)

    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        configurePageControl()
        configureForwardButton()
    }
    
    func configurePageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 70, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = orderedViewControllers.count
        pageControl.currentPage = 0

        pageControl.currentPageIndicatorTintColor = UIColor(white: 1.0, alpha: 1.0)
        
        pageControl.pageIndicatorTintColor = UIColor(white: 1.0, alpha: 0.5)

        self.view.addSubview(pageControl)
    }

    func configureForwardButton() {
        let buttonSize: CGFloat = 60
        let buttonYPosition = UIScreen.main.bounds.maxY - 70 - 30 - buttonSize
        
        forwardButton.frame = CGRect(x: (UIScreen.main.bounds.width - buttonSize) / 2,
                                     y: buttonYPosition,
                                     width: buttonSize,
                                     height: buttonSize)
        forwardButton.layer.cornerRadius = buttonSize / 2
        forwardButton.clipsToBounds = true
        forwardButton.backgroundColor = UIColor.white

        if let buttonImage = UIImage(named: "onb_forward_btn") {
            let btnImg:UIImage? = buttonImage
            forwardButton.setImage(btnImg, for: .normal)
            forwardButton.imageView?.contentMode = .scaleAspectFit
        } else {
            print("Image 'onb_forward_btn' not found")
        }

        forwardButton.addTarget(self, action: #selector(forwardButtonTapped), for: .touchUpInside)
        self.view.addSubview(forwardButton)
    }

    @objc func forwardButtonTapped() {
        guard let currentViewController = viewControllers?.first,
              let currentIndex = orderedViewControllers.firstIndex(of: currentViewController),
              currentIndex <= orderedViewControllers.count - 1 else {
            return
        }
        
        if (currentIndex == orderedViewControllers.count - 1) {
            pushToWelcomeScreen()
        }else{
            let nextViewController = orderedViewControllers[currentIndex + 1]
            
            DispatchQueue.main.async {
                self.setViewControllers([nextViewController],
                                        direction: .forward,
                                        animated: true,
                                        completion: nil)
            }
        }

    }
    
    func pushToWelcomeScreen() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let welcomeVC = sb.instantiateViewController(withIdentifier: "Welcome")
        navigationController?.pushViewController(welcomeVC, animated: true)
    }

    func newViewController(identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }

    // MARK: - Page View Controller Data Source Methods

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard orderedViewControllers.count > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }

    // MARK: - Page View Controller Delegate Methods

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let pageContentViewController = pageViewController.viewControllers?.first {
            if let index = orderedViewControllers.firstIndex(of: pageContentViewController) {
                pageControl.currentPage = index
            }
        }
    }
}

