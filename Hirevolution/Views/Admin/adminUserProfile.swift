//
//  adminUserProfile.swift
//  Hirevolution
//
//  Created by user244481 on 12/16/24.
//

import UIKit


class adminUserProfile: UIViewController {
    var userData: [String: Any]?
    let authManager = AuthManager.shared

    @IBOutlet weak var imgUserBackground: UIImageView!
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var lblUserFullName: UILabel!
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserAbout: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("User Data Received: \(userData ?? [:])")
        
        loadUIElements()

        

    }

    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true

    }

    // Function to load profile image
    func loadProfileImage() {
        guard let userData = userData,
              let userProfile = userData["userProfile"] as? [String: Any] else {
            // If user data or profile is missing, use the default image
            authManager.loadImage(from: "", into: self.imgUserProfile)
            return
        }

        if let profileImageName = userProfile["userProfileImage"] as? String, !profileImageName.isEmpty {
            // Delegate image loading to AuthManager's loadImage method
            authManager.loadImage(from: profileImageName, into: self.imgUserProfile)
        } else {
            // If no profile image name, load the default image
            authManager.loadImage(from: "", into: self.imgUserProfile)
        }
    }
    
    func loadBackgroundImage() {
        guard let userData = userData,
              let userProfile = userData["userProfile"] as? [String: Any] else {
            // If user data or profile is missing, use the default image
            authManager.loadImage(from: "", into: self.imgUserBackground)
            return
        }

        if let backgroundImageName = userProfile["backgroundPictuer"] as? String, !backgroundImageName.isEmpty {
            // Delegate image loading to AuthManager's loadImage method
            authManager.loadImage(from: backgroundImageName, into: self.imgUserBackground)
        } else {
            // If no background image name, load the default image
            authManager.loadImage(from: "", into: self.imgUserBackground)
        }
    }



    // Function to load both profile and background images
    func loadImages() {
        loadProfileImage()
        loadBackgroundImage()
    }

    // Function to load UI elements (no longer calls loadImages)
    func loadUIElements() {
        guard let userData = userData,
              let userProfile = userData["userProfile"] as? [String: Any],
              let userName = userProfile["userName"] as? String,
              let email = userData["eMail"] as? String,
              let userAbout = userProfile["userAbout"] as? String,
              let fullName = userData["fullName"] as? String else {
            print("Error accessing user data fields.")
            return
        }

        lblUserName.text = userName
        lblUserEmail.text = email
        lblUserAbout.text = userAbout
        lblUserFullName.text = fullName
        
       
        loadImages()

    }
    
    @IBAction func btnDelete(_ sender: Any) {
        if let fullName = userData?["fullName"] as? String {
            let alert = UIAlertController(title: "Confirm Delete",
                                          message: "Are you sure you want to delete \(fullName)'s Account?",
                                          preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                guard let self = self else { return }

                if let userID = self.userData?["id"] as? String {
                    authManager.deleteUser(withID: userID) { success in
                        if success {
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            print("Error deleting user")
                        }
                    }
                } else {
                    print("Error: User ID not found")
                }
            })

            present(alert, animated: true)
        } else {
            print("Error: User's full name not found")
        }
    }

    @IBAction func btnEdit(_ sender: Any) {
        let editViewController = UIStoryboard(name: "Montader", bundle: nil).instantiateViewController(withIdentifier: "adminUserEdit") as! adminUserEdit
        editViewController.userData = userData
        navigationController?.pushViewController(editViewController, animated: true)
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false

    }
    
}
