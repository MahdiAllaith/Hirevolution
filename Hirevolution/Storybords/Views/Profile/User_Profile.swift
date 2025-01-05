//
//  User_Profile.swift
//  Hirevolution
//
//  Created by BP-36-201-22 on 04/12/2024.
//

import UIKit

class User_Profile: UIViewController {
    let authManager = AuthManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    @IBAction func createProfile(_ sender: Any) {
        let MainWorkEX = WorkExperience(
            jobTitle: "DataBase Adminstrator",
            jobFiled: "Data Analyst",
            companyName: "Amazon",
            startDate: "2020/10/20",
            endDate: "2022/10/28",
            stillWorking: false,
            mainJob: true,
            mainJobCompanyLogo: "gs://hirevolution.firebasestorage.app/youtube-logo-hd-8-1348870541.png")
        
        let oneWorkEX = WorkExperience(
            jobTitle: "Software Engineer",
            jobFiled: "Software Engineer",
            companyName: "Tasla",
            startDate: "2022/11/20",
            endDate: "2023/11/28",
            stillWorking: false,
            mainJob: false,
            mainJobCompanyLogo: "gs://hirevolution.firebasestorage.app/tesla-logo-black-2711845411.jpg")
//        
//        let secWorkEX = WorkExperience(
//            jobTitle: "Mobile Designer",
//            jobFiled: "Mobile Developer",
//            companyName: "Google",
//            startDate: "2010/10/20",
//            endDate: "2012/10/2",
//            stillWorking: false,
//            mainJob: false,
//            mainJobCompanyLogo: "")
        
        let updatedUserProfile = UserProfile(
            backgroundPictuer: "",
            userProfileImage: "gs://hirevolution.firebasestorage.app/c6f0b2c6cad28711d5209f7bb3cabddb-834927952.jpg",
            userName: "Alix",
            userAbout: "Updated about section",
            userWorkExperience: [MainWorkEX,oneWorkEX],  // Updated work experience
            userSkills: ["Problem Solving"] // Updated skills
        )
        
        guard let userID = authManager.userSession?.uid else {
            print("User ID is missing, handle the error appropriately")
            return
        }
        
        AuthManager.shared.updateUserProfile(userId: userID, updatedUserProfile: updatedUserProfile) { error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
            } else {
                print("Profile updated successfully.")
            }
            
            // fetching data to update
            self.authManager.fetchUserData(uid: self.authManager.currentUser!.id)
        }
    }
    
}
