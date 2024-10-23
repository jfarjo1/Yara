//
//  BasePopupVC.swift
//  Yara
//
//  Created by Johnny Owayed on 19/10/2024.
//

import UIKit

protocol BaseModalPopupViewDelegate: AnyObject {
    func onDismiss(type: String)
}

extension BaseModalPopupViewDelegate {
    func onDismiss(type: String) {}
}

class BasePopupViewController: UIViewController {
    @IBOutlet var contentView: UIView!
    var alphaComponent = 0.22
    var dimmedViewColor = UIColor(hexString: "#222222")
    var originalYPositionOfPopUp: CGFloat = 0.0
    var botttomConstraint: CGFloat = 25.0

    weak var delegate: BaseModalPopupViewDelegate?
    var popupType: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Swipe down
        let pgrFullView = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        contentView.addGestureRecognizer(pgrFullView) // applying pan gesture on full main view
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        originalYPositionOfPopUp = self.view.frame.size.height - contentView.frame.size.height - botttomConstraint
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .transitionFlipFromBottom,
                       animations: {
            self.view.backgroundColor = self.dimmedViewColor.withAlphaComponent(self.alphaComponent)
            self.slideViewTo(self.contentView.frame.origin.x, self.originalYPositionOfPopUp)
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.backgroundColor = UIColor.clear
    }

    func slideViewTo(_ x: CGFloat, _ y: CGFloat) {
        contentView.frame.origin = CGPoint(x: x, y: y)
    }

    @objc func panGestureAction(_ panGesture: UIPanGestureRecognizer) {
        let minimumVelocityToHide: CGFloat = 750
        let minimumScreenRatioToHide: CGFloat = 0.50
        let animationDuration: TimeInterval = 0.2

        
        switch panGesture.state {
        // case .began, .changed:
        case .changed:
            // If pan started or is ongoing then slide the view to follow the finger
            let translation = panGesture.translation(in: view)
            //            print("translation.y: \(translation.y)")
            if translation.y > 0 { // only down movement to handle
                slideViewTo(contentView.frame.origin.x, originalYPositionOfPopUp + translation.y)
            }
        case .ended:
            // If pan ended, decide it we should close or reset the view based on the final position and the speed of the gesture
            let translation = panGesture.translation(in: view)
            let velocity = panGesture.velocity(in: view)
            let closing = (translation.y > contentView.frame.size.height * minimumScreenRatioToHide) || // checking on y position
                (velocity.y > minimumVelocityToHide) // checking on y velocity

            if closing {
                dismiss(animated: true) {
                    self.delegate?.onDismiss(type: self.popupType)
                }
            } else {
                // If not closing, reset the view to the top
                if translation.y > 0 {
                    UIView.animate(withDuration: animationDuration, animations: {
                        self.slideViewTo(self.contentView.frame.origin.x, self.originalYPositionOfPopUp)
                    })
                }
            }
        default:
            print(panGesture.state)
        }
    }
}
