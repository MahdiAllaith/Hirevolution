//
//  adminCompanyEdit.swift
//  Hirevolution
//
//  Created by user244481 on 12/18/24.
//

import UIKit


class adminCompanyEdit: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var companyData: [String: Any]?

    // UI Outlets
    @IBOutlet weak var imgLogoCompany: UIImageView!
    @IBOutlet weak var btnLogoImg: UIButton!
    @IBOutlet weak var lblCompanyLogoImage: UILabel!
    @IBOutlet weak var lblCompanyBackgroundImg: UILabel!
    @IBOutlet weak var imgCompanyBackground: UIImageView!
    @IBOutlet weak var btnCompanyBackground: UIButton!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var txtCompanyName: UITextField!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var lblYearOffEstablishment: UILabel!
    @IBOutlet weak var txtYearOfEstablishment: UITextField!
    @IBOutlet weak var lblNumberOfEmployees: UILabel!
    @IBOutlet weak var txtNumberOfEmployees: UITextField!
    @IBOutlet weak var lblCEOname: UILabel!
    @IBOutlet weak var txtCEOname: UITextField!
    @IBOutlet weak var lblNetWorth: UILabel!
    @IBOutlet weak var txtNetWorth: UITextField!
    
    let authManager = AuthManager.shared
    private var logoImageSelected = false
    private var backgroundImageSelected = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let companyData = companyData {
            print("Company Data Received: \(companyData)")
            populateCompanyData(from: companyData)
        } else {
            print("companyData is empty")
        }
    }

    // MARK: - Populate Company Data

    func populateCompanyData(from companyData: [String: Any]) {
        if let companyProfile = companyData["companyProfile"] as? [String: Any],
           let companyName = companyProfile["companyName"] as? String,
           let companyDescription = companyProfile["companyDescription"] as? String,
           let yearOfEstablishment = companyProfile["yearOfEstablishment"] as? String,
           let numberOfEmployees = companyProfile["numberOfEmployees"] as? String,
           let companyCEOName = companyProfile["companyCEOName"] as? String,
           let companyNetworth = companyProfile["companyNetworth"] as? String {
            
            // Populate text fields
            txtCompanyName.text = companyName
            txtDescription.text = companyDescription
            txtYearOfEstablishment.text = yearOfEstablishment
            txtNumberOfEmployees.text = numberOfEmployees
            txtCEOname.text = companyCEOName
            txtNetWorth.text = companyNetworth
            
            // Load images (Logo & Background)
            loadLogoImage(from: companyProfile)
            loadBackgroundImage(from: companyProfile)
        } else {
            print("Error accessing company data fields.")
        }
    }

    // MARK: - Image Loading Methods

    func loadLogoImage(from companyProfile: [String: Any]) {
        guard let logoImageName = companyProfile["companyProfileLogo"] as? String, !logoImageName.isEmpty else {
            imgLogoCompany.image = UIImage(systemName: "person.fill") // Default system image
            return
        }
        
        authManager.loadImage(from: logoImageName, into: imgLogoCompany)
    }

    func loadBackgroundImage(from companyProfile: [String: Any]) {
        guard let backgroundImageName = companyProfile["profilebackgroundPictuer"] as? String, !backgroundImageName.isEmpty else {
            imgCompanyBackground.image = UIImage(systemName: "person.fill") // Default system image
            return
        }
        
        authManager.loadImage(from: backgroundImageName, into: imgCompanyBackground)
    }

    

    


    // MARK: - Update Company Data

    @IBAction func btnUpdate(_ sender: Any) {
        guard let companyData = companyData,
              let companyProfile = companyData["companyProfile"] as? [String: Any],
              let companyId = companyData["id"] as? String else {
            print("Error: Company data or profile not found.")
            showAlert(title: "Error", message: "Company data or profile not found.")
            return
        }

        // Gather updated company details from the UI
        let companyName = txtCompanyName.text ?? ""
        let companyDescription = txtDescription.text ?? ""
        let yearOfEstablishment = txtYearOfEstablishment.text ?? ""
        let numberOfEmployees = txtNumberOfEmployees.text ?? ""
        let companyCEOName = txtCEOname.text ?? ""
        let companyNetworth = txtNetWorth.text ?? ""
        
        // Validate fields
        if companyName.isEmpty || companyDescription.isEmpty || yearOfEstablishment.isEmpty ||
            numberOfEmployees.isEmpty || companyCEOName.isEmpty || companyNetworth.isEmpty {
            showAlert(title: "Error", message: "Please fill in all fields.")
            return
        }
        
        var anyChangesMade = false

        // Check if any images or text fields have changed
        if logoImageSelected || backgroundImageSelected || hasTextChanges(companyProfile: companyProfile) {
            anyChangesMade = true
        }

        // If no changes were made, show an alert and return
        if !anyChangesMade {
            showAlert(title: "No Changes", message: "You didn't make any changes.")
            return
        }
        
        // Confirmation alert to ensure the user wants to update the company data
        let confirmAlert = UIAlertController(title: "Confirm Update", message: "Are you sure you want to update the company information?", preferredStyle: .alert)
        
        confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        confirmAlert.addAction(UIAlertAction(title: "Update", style: .default) { _ in
            // Call the `updateCompanyData` method to perform the update
            self.authManager.updateCompanyData(
                companyData: companyData, // original company data
                companyId: companyId,
                companyName: companyName,
                companyDescription: companyDescription,
                yearOfEstablishment: yearOfEstablishment,
                numberOfEmployees: numberOfEmployees,
                companyCEOName: companyCEOName,
                companyNetworth: companyNetworth,
                logoImageSelected: self.logoImageSelected, // flag if logo image is selected
                backgroundImageSelected: self.backgroundImageSelected, // flag if background image is selected
                logoImage: self.imgLogoCompany.image, // the new logo image
                backgroundImage: self.imgCompanyBackground.image, // the new background image
                completion: { success, message in
                    if success {
                        let updatedAlert = UIAlertController(title: "Updated", message: "Company information updated successfully.", preferredStyle: .alert)
                        updatedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                            // Navigate back to A_Browse directly without a function
                            if let aBrowseVC = self.navigationController?.viewControllers.first(where: { $0 is A_Browse }) {
                                // Pop to the A_Browse view controller
                                self.navigationController?.popToViewController(aBrowseVC, animated: true)
                                self.tabBarController?.tabBar.isHidden = false

                            }
                        }))
                        self.present(updatedAlert, animated: true)
                    } else {
                        self.showAlert(title: "Error", message: message) // Error alert
                    }
                }
            )
        })
        
        // Present the confirmation alert
        self.present(confirmAlert, animated: true)
    }



    // Function to check for text field changes in company profile
    private func hasTextChanges(companyProfile: [String: Any]) -> Bool {
        // Fetch the original company profile data values
        guard let originalCompanyName = companyProfile["companyName"] as? String,
              let originalCompanyDescription = companyProfile["companyDescription"] as? String,
              let originalYearOfEstablishment = companyProfile["yearOfEstablishment"] as? String,
              let originalNumberOfEmployees = companyProfile["numberOfEmployees"] as? String,
              let originalCompanyCEOName = companyProfile["companyCEOName"] as? String,
              let originalCompanyNetworth = companyProfile["companyNetworth"] as? String else {
            return false
        }
        
        // Compare the text field values with the original company data
        return txtCompanyName.text != originalCompanyName ||
               txtDescription.text != originalCompanyDescription ||
               txtYearOfEstablishment.text != originalYearOfEstablishment ||
               txtNumberOfEmployees.text != originalNumberOfEmployees ||
               txtCEOname.text != originalCompanyCEOName ||
               txtNetWorth.text != originalCompanyNetworth
    }
    // MARK: - Image Picker

    enum ImageType {
        case logo, background
    }

    @IBAction func btnLogoImage(_ sender: Any) {
        showImagePicker(for: .logo)
    }

    @IBAction func btnBackgroundImage(_ sender: Any) {
        showImagePicker(for: .background)
    }

    func showImagePicker(for type: ImageType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.view.tag = (type == .logo) ? 1 : 2
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[.editedImage] as? UIImage else { return }

        if picker.view.tag == 1 {
            imgLogoCompany.image = pickedImage
            logoImageSelected = true
        } else {
            imgCompanyBackground.image = pickedImage
            backgroundImageSelected = true
        }
        
        dismiss(animated: true)
    }

    // MARK: - Helper Methods

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)

    }
    
}
