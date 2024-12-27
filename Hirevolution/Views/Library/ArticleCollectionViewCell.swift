//
//  ArticleCollectionViewCell.swift
//  Hirevolution
//
//  Created by BP-36-201-20 on 15/12/2024.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var lblContent: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()
            
            // Ensure the label allows for multiple lines
            lblContent.numberOfLines = 0  // This allows the label to expand vertically as needed
            lblContent.lineBreakMode = .byWordWrapping  // Ensures words are wrapped properly
            lblContent.font = UIFont.systemFont(ofSize: 16)  // Adjust font size as needed
        self.layer.cornerRadius = 10  // Adjust the radius to make the cell more or less rounded
                    self.layer.masksToBounds = true  // Ensures the content (like text) stays within the rounded borders
                    self.layer.borderWidth = 1  // Optional: Add a border to the cell for better visibility
                    self.layer.borderColor = UIColor.lightGray.cgColor
        self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2) // Light gray with transparency
        
    }
    
    
}

