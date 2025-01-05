//
//  AddJobNavBar.swift
//  Hirevolution
//
//  Created by Mac 14 on 19/11/2024.
//

import UIKit

class AddJobNavBar: UINavigationBar {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Adjust the positioning of the items (title, back button, etc.)
        for subview in subviews {
            // Align all subviews (title, buttons) to the bottom of the navigation bar
            if let titleLabel = subview as? UILabel {
                titleLabel.frame.origin.y = self.bounds.height - titleLabel.bounds.height - 10 // Adjust vertical position for title label
            }

            if let backButton = subview as? UIButton {
                backButton.frame.origin.y = self.bounds.height - backButton.bounds.height - 10 // Adjust vertical position for back button
            }

            if let barButtonItemView = subview as? UIView {
                // Adjust for any other bar button items (like a right or left button)
                barButtonItemView.frame.origin.y = self.bounds.height - barButtonItemView.bounds.height - 10
            }
        }
    }

   
}





