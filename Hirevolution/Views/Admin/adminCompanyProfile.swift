//
//  adminCompanyProfile.swift
//  Hirevolution
//
//  Created by user244481 on 12/16/24.
//

import UIKit


class adminCompanyProfile: UIViewController {
    var companyData: [String: Any]?
    let authManager = AuthManager.shared
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgProfileLogo: UIImageView!
    @IBOutlet weak var lblCEOname: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Company Data Received: \(companyData ?? [:])")
        
        // Load UI elements
        loadUIElements()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true

    }

    func loadProfileLogo() {
        guard let companyData = companyData,
              let companyProfile = companyData["companyProfile"] as? [String: Any] else {
            // If company data or profile is missing, use the default image
            authManager.loadImage(from: "", into: self.imgProfileLogo)
            return
        }
        
        if let profileLogoName = companyProfile["companyProfileLogo"] as? String {
            // Delegate image loading to AuthManager's loadImage method
            authManager.loadImage(from: profileLogoName, into: self.imgProfileLogo)
        } else {
            // If no profile logo name, load the default image
            authManager.loadImage(from: "", into: self.imgProfileLogo)
        }
    }


    // Function to load background image
    func loadBackgroundImage() {
        guard let companyData = companyData,
              let companyProfile = companyData["companyProfile"] as? [String: Any] else {
            // If company data is missing or malformed, the default image will be set by loadImage
            authManager.loadImage(from: "", into: self.imgBackground)
            return
        }
        
        if let backgroundImageName = companyProfile["profilebackgroundPictuer"] as? String {
            // Delegate image loading to the AuthManager's loadImage method
            authManager.loadImage(from: backgroundImageName, into: self.imgBackground)
        } else {
            // If no background image name, load the default image
            authManager.loadImage(from: "", into: self.imgBackground)
        }
    }


    // Function to load both profile logo and background image
    func loadImages() {
        loadProfileLogo()
        loadBackgroundImage()
    }

    // Function to load UI elements (text data)
    func loadUIElements() {
        guard let companyData = companyData,
              let companyProfile = companyData["companyProfile"] as? [String: Any],
              let ceoName = companyProfile["companyCEOName"] as? String,
              let companyName = companyProfile["companyName"] as? String,
              let year = companyProfile["yearOfEstablishment"] as? String,
              let email = companyData["eMail"] as? String,
              let description = companyProfile["companyDescription"] as? String else {
            print("Error accessing company data fields.")
            return
        }

        lblCEOname.text = ceoName
        lblCompanyName.text = companyName
        lblYear.text = year
        lblEmail.text = email
        lblDescription.text = description
        
        
        loadImages()
    }
    
    @IBAction func btnEdit(_ sender: Any) {
        let editViewController = UIStoryboard(name: "Montader", bundle: nil).instantiateViewController(withIdentifier: "adminCompanyEdit") as! adminCompanyEdit
        editViewController.companyData = companyData
        navigationController?.pushViewController(editViewController, animated: true)
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        if let companyData = companyData,
           let companyProfile = companyData["companyProfile"] as? [String: Any],
           let companyName = companyProfile["companyName"] as? String,
           let companyID = companyData["id"] as? String {
            
            let alert = UIAlertController(title: "Confirm Delete",
                                          message: "Are you sure you want to delete \(companyName)?",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                
                authManager.deleteCompany(withID: companyID) { success in
                    if success {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        print("Error deleting company")
                    }
                }
            })
            
            present(alert, animated: true)
        } else {
            print("Error: Company data or company name not found")
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false


    }
    
}
