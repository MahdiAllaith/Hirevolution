import UIKit

class CompanyCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblCompanyTitle: UILabel!
    @IBOutlet weak var lblCompanyStatus: UILabel!
    @IBOutlet weak var lblCompanyInterviewed: UILabel!
    @IBOutlet weak var lblCompanyCreatedDate: UILabel!
    @IBOutlet weak var lblCompanyApplied: UILabel!
    @IBOutlet weak var lblCompanyApplications: UILabel!
    @IBOutlet weak var lblCompanyJobStatus: UILabel!
    @IBOutlet weak var lblCompanyInterview: UILabel!
    @IBOutlet weak var lblCompanyDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        

        // Round the corners of the cell
        self.layer.cornerRadius = 25
        self.layer.masksToBounds = true
    }
    
}
