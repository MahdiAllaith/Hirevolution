//
//  ViewedApplicationTableCell.swift
//  Hirevolution
//
//  Created by Mac 14 on 13/12/2024.
//

import UIKit
import FirebaseStorage

protocol goToMessageView : AnyObject{
    func gotoMassageView()
}

class ViewedApplicationTableCell: UITableViewCell {
    
    weak var delegate: goToMessageView?
    
    var passedApplicantDetails: UserApplicationsStuff?
    
    @IBOutlet weak var ViewHolder: UIView!
    @IBOutlet weak var IsCanadidateStarIamge: UIImageView!
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var MainField: UILabel!
    @IBOutlet weak var ProfileAbout: UITextView!
    @IBOutlet weak var MainWorkLogo: UIImageView!
    @IBOutlet weak var MainWorkTitle: UILabel!
    @IBOutlet weak var MainWorkCompanyName: UILabel!
    @IBOutlet weak var ExperainceDuration: UILabel!
    @IBOutlet weak var ApplicationSatus: UILabel!
    
    @IBOutlet weak var MassageButton: UIButton!
    
    // New closure to handle taps
    var onCellTap: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Ensure ViewHolder receives touch events
        ViewHolder.isUserInteractionEnabled = true
    }
    
    // Override touchesBegan to capture tap on the ViewHolder
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        // Check if the touch was within the bounds of the ViewHolder
        if ViewHolder.bounds.contains(touches.first!.location(in: ViewHolder)) {
            // Trigger the tap event handler
            onCellTap?()
        }
    }
    
    @IBAction func MassageButton(_ sender: Any) {
        
        if passedApplicantDetails?.applicantStatus == "Canceled" {
            MassageButton.isEnabled = false
        }else {
            //will present massage view
            delegate?.gotoMassageView()
        }
        
        
    }
    
    //Function to set data into all objects
    func config(UserApplican: UserApplicationsStuff) {
        passedApplicantDetails = UserApplican
        
        let ApplicanUserPrfile = UserApplican.applicantProfile
        
        // Set corner radius
        ViewHolder.layer.cornerRadius = 15
        
        // Find the main job experience
        let WorkExperince = ApplicanUserPrfile.userWorkExperience
        var MainWork: WorkExperience?
        for workExperience in WorkExperince {
            if workExperience.mainJob {
                MainWork = workExperience
                break
            }
        }
        
        if UserApplican.isCandidate {
            IsCanadidateStarIamge.image = UIImage(systemName: "star.fill")
        }else{
            IsCanadidateStarIamge.image = UIImage(systemName: "star")
        }
        
        // Set user details
        UserName.text = ApplicanUserPrfile.userName
        ProfileAbout.text = ApplicanUserPrfile.userAbout
        MainField.text = MainWork?.jobFiled
        MainWorkTitle.text = MainWork?.jobTitle
        MainWorkCompanyName.text = "Company: \(MainWork!.companyName)"
        ApplicationSatus.text = UserApplican.applicantStatus
        
        switch UserApplican.applicantStatus{
            case "On-going":
            ApplicationSatus.textColor = UIColor.orange
            break
            case "Rejected":
            ApplicationSatus.textColor = UIColor(named: "Red")
            break
            case "Canceled":
            ApplicationSatus.textColor = UIColor(named: "Red")
            break
            case "Hired":
            ApplicationSatus.textColor = UIColor.green
            break
            default:
            break
        }

        if let startDateString = MainWork?.startDate, let endDateString = MainWork?.endDate {
            if let startDate = convertStringToDate(dateString: startDateString),
               let endDate = convertStringToDate(dateString: endDateString) {
                
                let timeInterval = endDate.timeIntervalSince(startDate)
                let years = Int(timeInterval) / (60 * 60 * 24 * 365) // Number of years
                let months = (Int(timeInterval) % (60 * 60 * 24 * 365)) / (60 * 60 * 24 * 30) // Remaining months
                
                ExperainceDuration.text = "Experience: \(years) yr, \(months) mons"
            } else {
                ExperainceDuration.text = "N/A"
            }
        } else {
            ExperainceDuration.text = "N/A"
        }
        
        // Download user profile image
        let imageURL = ApplicanUserPrfile.userProfileImage
        let imageLogoURL = MainWork!.mainJobCompanyLogo

        let storage = Storage.storage()

        // Validate imageURL
        if imageURL.isEmpty {
            self.ProfileImage.backgroundColor = UIColor.gray
        } else {
            let reference = storage.reference(forURL: imageURL)
            reference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Error downloading image: \(error)")
                    return
                }

                if let data = data {
                    let imagee = UIImage(data: data)
                    let newSize = CGSize(width: 74, height: 72)
                    let resizedImage = self.resizeImage(imagee!, to: newSize)

                    // Set the resized image to the UIImageView
                    self.ProfileImage.image = resizedImage
                    self.ProfileImage.layer.borderWidth = 1
                    self.ProfileImage.layer.borderColor = UIColor(named: "Blue")?.cgColor
                    self.ProfileImage.layer.cornerRadius = 33
                }
            }
        }

        // Validate imageBAckgroundURL
        if imageLogoURL.isEmpty {
            self.MainWorkLogo.backgroundColor = UIColor.gray
        } else {
            let reference2 = storage.reference(forURL: imageLogoURL)
            reference2.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Error downloading image: \(error)")
                    return
                }

                if let data = data {
                    let imagee = UIImage(data: data)
                    let newSize = CGSize(width: 74, height: 70)
                    let resizedImage = self.resizeImage(imagee!, to: newSize)

                    // Set the resized image to the UIImageView
                    self.MainWorkLogo.image = resizedImage
                }
            }
        }
        
    }

    // Helper function to convert string to Date
    func convertStringToDate(dateString: String, format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: dateString)
    }
    
    
    func resizeImage(_ image: UIImage, to newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }

}
