//
//  CardAlertView.swift
//  Yara
//
//  Created by Johnny Owayed on 26/10/2024.
//

import UIKit
import SwiftMessages

class CardAlertView: MessageView {
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func cancelButton_onClick(_ sender: UIButton) {
        SwiftMessages.hide(id: self.id)
    }
}
