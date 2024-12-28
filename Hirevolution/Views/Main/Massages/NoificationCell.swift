import UIKit
import FirebaseStorage

class NotificationCell: UITableViewCell {

    @IBOutlet weak var JobName: UILabel!
    @IBOutlet weak var JobImage: UIImageView!
    @IBOutlet weak var InterviewDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //basiclly links datas
    func configureCollectionCells(jobList: JobList, interviewDate: Date) {
        // Set job data to UI elements
        JobName.text = jobList.companyProfile.companyName
        
        // displays company logo
        loadCompanyLogo(from: jobList.companyProfile.companyProfileLogo)
        
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

    // Load company logo from Firebase Storage
    private func loadCompanyLogo(from imageURL: String) {
        if imageURL.isEmpty {
            JobImage.image = UIImage(systemName: "suitcase.fill")
        } else {
            let storage = Storage.storage()
            let reference = storage.reference(forURL: imageURL)
            
            reference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Error downloading image: \(error)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    let resizedImage = self.resizeImage(image, to: CGSize(width: 80, height: 80))
                    self.JobImage.image = resizedImage
                }
            }
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
