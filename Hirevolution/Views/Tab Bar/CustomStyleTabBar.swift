//
//  CustomStyleTabBar.swift
//  Hirevolution
//
//  Created by Mac 14 on 19/11/2024.
//

import UIKit

class CustomStyleTabBar: UITabBar {

    override func layoutSubviews() {
        super.layoutSubviews()

        // Ensure the tab bar's frame is properly adjusted
        let height: CGFloat = 55
        self.frame.size.height = height + 20 // Extra 20 for padding
        self.frame.size.width = UIScreen.main.bounds.width - 30 // Horizontal padding
        self.frame.origin.x = 15
        self.frame.origin.y = 740

        // Apply corner radius and ensure it's not clipped
        self.layer.cornerRadius = 30
        self.layer.masksToBounds = false // Make sure corners are not clipped

        // Add border (using the "Blue" color if available, else default to yellow)
        if let blueColor = UIColor(named: "Blue")?.cgColor {
            self.layer.borderColor = blueColor
            self.layer.borderWidth = 2
        }

        // Apply shadow (using the "Blue" color if available, else default to yellow)
        if let shadowColor = UIColor(named: "Blue")?.withAlphaComponent(0.8).cgColor {
            self.layer.shadowColor = shadowColor
            self.layer.shadowOpacity = 1.0
            self.layer.shadowRadius = 50
            self.layer.shadowOffset = CGSize(width: 0, height: 40)
        }

        // Center the tab bar items horizontally within the tab bar
        let tabBarItems = self.subviews.filter { $0 is UIControl }
        let totalWidth = CGFloat(tabBarItems.count) * 50 // Assume each item has a width of 50 points
        let startingX = (self.bounds.width - totalWidth) / 2
        
        for (index, item) in tabBarItems.enumerated() {
            let xPosition = startingX + CGFloat(index) * 62 // Place items with 50 points spacing
            item.center = CGPoint(x: xPosition, y: 25) // Center the item
        }

        // Set the color of unclicked (unselected) tab bar items to gray
        
    }
}
