//
//  TapGesture.swift
//  Yara
//
//  Created by Johnny on 15/10/2024.
//


import Foundation
import UIKit

class TapGestureRecognizer: UITapGestureRecognizer {
    // MARK: - Properties

    private var action: () -> Void

    // MARK: - Initializers

    init(action: @escaping () -> Void) {
        self.action = action
        super.init(target: nil, action: nil)
        addTarget(self, action: #selector(execute))
    }

    // MARK: - Internal Methods

    @objc func execute() {
        action()
    }
}

extension TapGestureRecognizer {
    @discardableResult
    static func addTapGesture(to view: UIView?, action: @escaping () -> Void) -> Self? {
        guard let view = view else {
            return nil
        }

        let tapGestureRecognizer = TapGestureRecognizer {
            action()
        }

        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        return tapGestureRecognizer as? Self
    }
}
