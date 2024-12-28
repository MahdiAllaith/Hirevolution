//
//  adminUserEdit.swift
//  Hirevolution
//
//  Created by user244481 on 12/18/24.
//

import UIKit


class adminUserEdit: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var userData: [String: Any]?

    @IBOutlet weak var lblProfilemage: UILabel!
    @IBOutlet weak var lblBackgroundImage: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgBackground: UIImageView!

    @IBOutlet weak var btnEditProfileImage: UIButton!
    @IBOutlet weak var btnEditBackgroundImage: UIButton!

    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var AboutMe: UILabel!

    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAboutMe: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    
    private var profileImageSelected = false // Flag for profile image selection
    private var backgroundImageSelected = false

    let authManager = AuthManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        print("User Data Received: \(userData ?? [:])")
        
        // Check if user data is available and populate fields
        if let userData = userData {
            populateData(from: userData)
        } else {
            print("userData is empty")
        }
    }
    
    func populateData(from userData: [String: Any]) {
        if let userProfile = userData["userProfile"] as? [String: Any],
           let userName = userProfile["userName"] as? String,
           let email = userData["eMail"] as? String,
           let userAbout = userProfile["userAbout"] as? String,
           let fullName = userData["fullName"] as? String {
            
            // Populate text fields
            txtUserName.text = userName
            txtEmail.text = email
            txtAboutMe.text = userAbout
            txtFullName.text = fullName
            
            // Load images (Profile & Background)
            loadProfileImage(from: userProfile)
            loadBackgroundImage(from: userProfile)
        } else {
            print("Error accessing user data fields.")
        }
    }
    
    // MARK: - Image Loading Methods
    
    func loadProfileImage(from userProfile: [String: Any]) {
        guard let profileImageName = userProfile["userProfileImage"] as? String, !profileImageName.isEmpty else {
            imgProfile.image = UIImage(systemName: "person.fill") // Set to default system image
            return
        }
        
        authManager.loadImage(from: profileImageName, into: imgProfile)
    }
    
    func loadBackgroundImage(from userProfile: [String: Any]) {
        guard let backgroundImageName = userProfile["backgroundPictuer"] as? String, !backgroundImageName.isEmpty else {
            imgBackground.image = UIImage(systemName: "person.fill") // Set to default system image
            return
        }
        
        authManager.loadImage(from: backgroundImageName, into: imgBackground)
    }
    
 
    
    // MARK: - Update User Data
    
    @IBAction func btnUpdate(_ sender: Any) {
        guard let userData = userData, let userProfile = userData["userProfile"] as? [String: Any] else {
            print("Error: User data or profile not found.")
            return
        }
        
        let userName = txtUserName.text ?? ""
        let email = txtEmail.text ?? ""
        let aboutMe = txtAboutMe.text ?? ""
        let fullName = txtFullName.text ?? ""
        
        // Validate fields
        if userName.isEmpty || email.isEmpty || aboutMe.isEmpty || fullName.isEmpty {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }
        
        if !isValidEmail(email) {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }
        
        var anyChangesMade = false

        // Check if any images or text fields have changed
        if profileImageSelected || backgroundImageSelected || hasTextChanges(userProfile: userProfile, userData: userData) {
            anyChangesMade = true
        }
        
        if !anyChangesMade {
            showAlert(title: "No Changes", message: "You didn't make any changes.")
            return
        }
        
        let confirmAlert = UIAlertController(title: "Confirm Update", message: "Are you sure you want to update the user information?", preferredStyle: .alert)
        
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        confirmAlert.addAction(UIAlertAction(title: "Update", style: .default) { _ in
            self.authManager.updateUserData(userData: userData,
                                            fullName: fullName,
                                            email: email,
                                            userName: userName,
                                            userAbout: aboutMe,
                                            profileImageSelected: self.profileImageSelected,
                                            backgroundImageSelected: self.backgroundImageSelected,
                                            profileImage: self.imgProfile.image,
                                            backgroundImage: self.imgBackground.image) { success, message in
                if success {
                    let updatedAlert = UIAlertController(title: "Updated", message: "User information updated successfully.", preferredStyle: .alert)
                    updatedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        // Pop all view controllers back to the A_Browse view controller
                        if let navigationController = self.navigationController {
                            // Find the index of the A_Browse view controller in the navigation stack
                            if let aBrowseVC = navigationController.viewControllers.first(where: { $0 is A_Browse }) {
                                // Pop to the A_Browse view controller
                                navigationController.popToViewController(aBrowseVC, animated: true)
                                self.tabBarController?.tabBar.isHidden = false

                            }
                        }
                    }))
                    self.present(updatedAlert, animated: true)
                } else {
                    self.showAlert(title: "Error", message: message)
                }
            }
        })
        
        self.present(confirmAlert, animated: true)
    }


    
    private func hasTextChanges(userProfile: [String: Any], userData: [String: Any]) -> Bool {
        // Fetch the original user data values from userProfile and userData
        guard let originalUserName = userProfile["userName"] as? String,
              let originalUserAbout = userProfile["userAbout"] as? String,
              let originalFullName = userData["fullName"] as? String,
              let originalEmail = userData["eMail"] as? String else {
            return false
        }
        
        // Compare the text field values with the original user data
        return txtUserName.text != originalUserName ||
               txtAboutMe.text != originalUserAbout ||
               txtFullName.text != originalFullName ||
               txtEmail.text != originalEmail
    }

    
    // MARK: - Image Picker
    
    enum ImageType {
        case profile, background
    }

    @IBAction func btnProfileImage(_ sender: Any) {
        showImagePicker(for: .profile)
    }

    @IBAction func btnBackgroundImage(_ sender: Any) {
        showImagePicker(for: .background)
    }

    func showImagePicker(for type: ImageType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true // Allow user to edit the image

        // Set a tag to identify which image is being picked
        picker.view.tag = (type == .profile) ? 1 : 2

        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[.editedImage] as? UIImage else { return }

        if picker.view.tag == 1 {
            imgProfile.image = pickedImage
            profileImageSelected = true
        } else {
            imgBackground.image = pickedImage
            backgroundImageSelected = true
        }

        dismiss(animated: true)
    }
    
    // Helper function to show alerts
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // Helper function for email validation
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
}
