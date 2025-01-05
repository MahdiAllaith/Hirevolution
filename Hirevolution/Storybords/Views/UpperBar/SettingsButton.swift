//
//  SettingsButton.swift
//  Hirevolution
//
//  Created by Mac 14 on 27/11/2024.
//

import UIKit

class SettingsButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc func buttonTapped() {
        // Instantiate the Settings view controller
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let settingsVC = mainStoryboard.instantiateViewController(withIdentifier: "NavSettings")
        
        // Find the current view controller to present from
        if let currentVC = self.findParentViewController() {
            currentVC.present(settingsVC, animated: true, completion: nil)
        } else {
            print("Error: Could not find a view controller to present from")
        }
    }
    
    // Use a unique name for this method
    func findParentViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            responder = responder?.next
        }
        return nil
    }
}


