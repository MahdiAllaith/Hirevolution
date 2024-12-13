import UIKit

class JobTrackingCell: UITableViewCell {
    @IBOutlet weak var lblJobStatus: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lblJobDescription: UILabel!
    @IBOutlet weak var lblJobName: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Adding black border to the cell
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 10 // Optional: Add rounded corners to the cell

        // Making the status image circular
        imgStatus.layer.masksToBounds = true
        imgStatus.layer.cornerRadius = imgStatus.frame.height / 2
    }

    // Set status image if lblJobStatus is "Applied"
    func updateStatusImage(status: String) {
        if status == "On-going" {
            imgStatus.backgroundColor = .orange
            imgStatus.image = UIImage(systemName: "circle.fill") // You can choose any system image
        } else {
            imgStatus.backgroundColor = .clear
            imgStatus.image = nil
        }
    }
}
