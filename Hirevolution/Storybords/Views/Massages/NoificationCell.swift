import UIKit
import FirebaseStorage

class NotificationCell: UITableViewCell {

    @IBOutlet weak var JobName: UILabel!
    @IBOutlet weak var InterviewDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //basiclly links datas
    func configureCollectionCells(jobList: JobList, interviewDate: Date) {
        // Set job data to UI elements
        JobName.text = jobList.companyProfile.companyName
        
        // Displays interview date
        displayInterviewDate(interviewDate: interviewDate)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // Resize image method to maintain aspect ratio
    func resizeImage(_ image: UIImage, to newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }

    // Display the interview date
    func displayInterviewDate(interviewDate: Date) {
        // Format the date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd yyyy, h:mm a"
        let formattedDate = formatter.string(from: interviewDate)
        
        // Update the InterviewDate label
        InterviewDate.text = "Interview Date: \(formattedDate)"
    }
}
