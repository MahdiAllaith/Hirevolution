//
//  CardCollectionViewCell.swift
//  Hirevolution
//
//  Created by BP-36-201-20 on 15/12/2024.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblCardTitle: UILabel!
    @IBOutlet weak var lblCardTitleTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgCardLibrary: UIImageView!
    override func awakeFromNib() {
            super.awakeFromNib()
            
            // Round the corners of the cell
            self.layer.cornerRadius = 10  // Set to desired radius
            self.layer.masksToBounds = true  // Ensure the content respects the corner radius
            
            // Optionally, you can add a border (if desired)
            self.layer.borderWidth = 1  // Set border width (optional)
            self.layer.borderColor = UIColor.black.cgColor  // Set border color (optional)
        // Set corner radius and background color for the label
                lblCardTitle.layer.cornerRadius = 6  // Apply corner radius to the label
                lblCardTitle.layer.masksToBounds = true  // Ensure that the corner radius is applied
                
        lblCardTitle.lineBreakMode = .byTruncatingTail  // Truncate text if too long
         
            
        }
    func setupCell(photo: UIImage, title: String) {
            imgCardLibrary.image = photo
            lblCardTitle.text = title
            
            // Update the trailing constraint based on the label's content

        }
    
    
}
