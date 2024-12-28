//
//  JobTrackCell.swift
//  Hirevolution
//
//  Created by user244481 on 12/15/24.
//

import UIKit

class JobTrackCell: UITableViewCell {

    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblJobStatus: UILabel!
    @IBOutlet weak var lblJobDescription: UILabel!
    @IBOutlet weak var lblJobName: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Set up the button's action handler
        
          }
          
        
          
      

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Add a black border to the cell
           self.layer.borderColor = UIColor.black.cgColor
           self.layer.borderWidth = 1.0
           self.layer.cornerRadius = 8.0  // Optional: Round the corners a bit
           
           // Optional: You can add shadow to the cells for better effect
           self.layer.shadowColor = UIColor.black.cgColor
           self.layer.shadowOffset = CGSize(width: 0, height: 1)
           self.layer.shadowOpacity = 0.2
           self.layer.shadowRadius = 3.0
        
    }

}
