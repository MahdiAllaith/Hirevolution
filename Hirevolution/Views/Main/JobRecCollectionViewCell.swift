//
//  JobRecCollectionViewCell.swift
//  Hirevolution
//
//  Created by Guest User on 18/12/2024.
//

import UIKit

class JobRecCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgJobRec: UIImageView!
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblJobCompany: UILabel!
    @IBOutlet weak var lblJobDescription: UILabel!
    @IBOutlet weak var lblJobRole: UILabel!
    @IBOutlet weak var lblJobSalary: UILabel!
    @IBOutlet weak var lblJobLocation: UILabel!
    @IBOutlet weak var btnViewJobDetails: UIButton!
    
    override func awakeFromNib() {
           super.awakeFromNib()
           
           // Round the corners of the cell
           self.layer.cornerRadius = 10  // Adjust the radius to your liking
           self.layer.masksToBounds = true  // Ensure the content respects the corner radius 
               imgJobRec.layer.cornerRadius = 5  // Set the image corner radius
               imgJobRec.layer.masksToBounds = true
        // Round corners for labels
                lblJobRole.layer.cornerRadius = 5
                lblJobRole.layer.masksToBounds = true

                lblJobSalary.layer.cornerRadius = 5
                lblJobSalary.layer.masksToBounds = true

                lblJobLocation.layer.cornerRadius = 5
                lblJobLocation.layer.masksToBounds = true
        // Job Title: Allow text wrapping and adjust font size if needed
                lblJobTitle.lineBreakMode = .byWordWrapping
                lblJobTitle.numberOfLines = 0  // Allows multiple lines for Job Title

                lblJobTitle.adjustsFontSizeToFitWidth = true  // Shrink font size if needed to fit within the label width
                lblJobTitle.minimumScaleFactor = 0.5  // Shrink up to 50% of the original size if necessary

                // Job Description: Allow text wrapping and adjust font size if needed
                lblJobDescription.lineBreakMode = .byWordWrapping
                lblJobDescription.numberOfLines = 0  // Allows multiple lines for Job Description

                lblJobDescription.adjustsFontSizeToFitWidth = true  // Shrink font size if needed
                lblJobDescription.minimumScaleFactor = 0.5  // Shrink up to 50% of the original size if necessary
         
       }
}
