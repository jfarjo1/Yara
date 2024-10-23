//
//  ModalPopupVC.swift
//  Yara
//
//  Created by Johnny Owayed on 23/10/2024.
//

//
//  ModalPopupViewController.swift
//  Simly
//

import UIKit

protocol ModalPopupViewDelegate: BaseModalPopupViewDelegate {
    func onTapButtonPressed(object: Any?)
}

class ModalPopupViewController: BasePopupViewController {
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var closeView: UIView!

    var obj: Any?
    var testText :String?
    var testImage :UIImage?
    var testDetails:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.font = CustomFont.semiBoldFont(size: 22)
        detailLabel.font = CustomFont.semiBoldFont(size: 15)
        doneButton.titleLabel?.font = CustomFont.boldFont(size: 16)
        
        doneButton.layer.cornerRadius = 22
        doneButton.setTitle("got_it".localized, for: .normal)
    
        
        _ = TapGestureRecognizer.addTapGesture(to: closeView) {
            self.dismiss(animated: true) {
                self.delegate?.onDismiss(type: self.popupType)
            }
        }
        
        if(testImage != nil){
            DispatchQueue.main.async {
                self.setupView(img: self.testImage!, title: self.testText!, detail: self.testDetails!)
            }
        }
    }
    
    func setupView(img: UIImage, title: String, detail: String, buttonTitle: String? = nil) {
        imgView.image = img
        titleLabel.text = testText ?? title
        detailLabel.text = detail

        if let buttonTitle = buttonTitle {
            doneButton.setTitle(buttonTitle, for: .normal)
        }
    }

    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true) {
            if let delegate = self.delegate as? ModalPopupViewDelegate {
                delegate.onTapButtonPressed(object: self.obj)
            }
        }
    }
}
