//
//  ApplicantCell.swift
//  Hirevolution
//
//  Created by Mac 14 on 12/12/2024.
//

import UIKit
import FirebaseStorage

class ApplicantCell: UICollectionViewCell {
    
    @IBOutlet weak var ViewHolder: UIView!
    @IBOutlet weak var UserProfileImage: UIImageView!
    @IBOutlet weak var UserName: UILabel!
    @IBOutlet weak var MainWorkFiled: UILabel!
    @IBOutlet weak var ProfileAbout: UITextView!
    @IBOutlet weak var MainWorkCompanyLogo: UIImageView!
    @IBOutlet weak var WE_jobTitle: UILabel!
    @IBOutlet weak var WE_companyName: UILabel!
    @IBOutlet weak var WE_Experience: UILabel!
    
    func configer(UserApplican: UserApplicationsStuff) {
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
        
        // Set user details
        UserName.text = ApplicanUserPrfile.userName
        ProfileAbout.text = ApplicanUserPrfile.userAbout
        MainWorkFiled.text = MainWork?.jobFiled
        WE_jobTitle.text = MainWork?.jobTitle
        WE_companyName.text = "Company: \(MainWork!.companyName)"

        if let startDateString = MainWork?.startDate, let endDateString = MainWork?.endDate {
            if let startDate = convertStringToDate(dateString: startDateString),
               let endDate = convertStringToDate(dateString: endDateString) {
                
                let timeInterval = endDate.timeIntervalSince(startDate)
                let years = Int(timeInterval) / (60 * 60 * 24 * 365) // Number of years
                let months = (Int(timeInterval) % (60 * 60 * 24 * 365)) / (60 * 60 * 24 * 30) // Remaining months
                
                WE_Experience.text = "Experience: \(years) yr, \(months) mons"
            } else {
                WE_Experience.text = "N/A"
            }
        } else {
            WE_Experience.text = "N/A"
        }
        
        // Download user profile image
        let imageURL = ApplicanUserPrfile.userProfileImage
        let imageLogoURL = MainWork?.mainJobCompanyLogo

        
        let storage = Storage.storage()
        let reference = storage.reference(forURL: imageURL)
        let reference2 = storage.reference(forURL: imageURL)
        
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
                self.UserProfileImage.image = resizedImage
                self.UserProfileImage.layer.cornerRadius = 37
            }
        }
        
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
                self.MainWorkCompanyLogo.image = resizedImage
                self.MainWorkCompanyLogo.layer.cornerRadius = 15
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
