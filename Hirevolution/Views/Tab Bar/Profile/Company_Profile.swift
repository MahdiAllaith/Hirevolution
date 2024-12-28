//
//  Company_Profile.swift
//  Hirevolution
//
//  Created by BP-36-201-22 on 04/12/2024.
//

import UIKit

class Company_Profile: UIViewController {
    let authManager = AuthManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func CreateCompanyProfile(_ sender: Any) {
        let updatedCompanyProfile = CompanyProfile(profilebackgroundPictuer: "", companyProfileLogo: "gs://hirevolution.firebasestorage.app/tesla-logo-black-2711845411.jpg", companyName: "Tesla", companyDescription: "F you elon musk", yearOfEstablishment: "2000/10/10", numberOfEmployees: "354", companyCEOName: "elon zift", companyNetworth: "141B")
        
        // Ensure you are accessing the currentUser correctly
        if let user = authManager.currentUser {
            let userID = user.id
            // Proceed with the userID
            
            AuthManager.shared.updateCompanyProfile(companyId: userID, updatedCompanyProfile: updatedCompanyProfile) { error in
                if let error = error {
                    print("Error updating company profile: \(error.localizedDescription)")
                } else {
                    print("Company profile updated successfully.")
                }
            }
            
        } else {
            print("No current user found.")
        }
        
        
    }
    
    

}
