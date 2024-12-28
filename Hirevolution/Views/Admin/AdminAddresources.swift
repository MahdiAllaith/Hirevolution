//
//  AdminAddresources.swift
//  Hirevolution
//
//  Created by user244481 on 12/25/24.
//

import UIKit

class AdminAddresources: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Flag to check if an image has been selected
    var isImageSelected = false
    
    // Declare the property to hold the resource ID
    var LibraryID: String?
    
    let authManager = AuthManager.shared


    @IBOutlet weak var txtResourceTitle: UITextField!
    @IBOutlet weak var imgResource: UIImageView!
    @IBOutlet weak var sectionOneHeader: UITextField!
    @IBOutlet weak var sectionOneContent: UITextView!
    @IBOutlet weak var sectionTwoHeader: UITextField!
    @IBOutlet weak var sectionTwoContent: UITextView!
    @IBOutlet weak var sectionThreeHeader: UITextField!
    @IBOutlet weak var sectionThreeContent: UITextView!
    @IBOutlet weak var sectionFourHeader: UITextField!
    @IBOutlet weak var sectionFourContent: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Any setup if needed
    }

    // MARK: - Image Picker

    @IBAction func btnImage(_ sender: Any) {
        // Create an instance of UIImagePickerController
        let imagePickerController = UIImagePickerController()

        // Set the source type to the photo library
        imagePickerController.sourceType = .photoLibrary

        // Set the delegate to handle the image selection
        imagePickerController.delegate = self

        // Present the image picker
        present(imagePickerController, animated: true, completion: nil)
    }

    // MARK: - UIImagePickerControllerDelegate Methods

    // This method is called when the user selects an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Get the selected image
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // Set the selected image to the imgResource UIImageView
            imgResource.image = selectedImage
            
            // Set the flag to true indicating an image has been selected
            isImageSelected = true
        }
        
        // Dismiss the image picker
        dismiss(animated: true, completion: nil)
    }

    // This method is called when the user cancels the image picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the image picker
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Add Resource to Firestore

    @IBAction func btnAdd(_ sender: Any) {
        // Check if the image has been selected and text fields are not empty
        if isImageSelected && isValidInput() {
            // Create a confirmation alert
            let confirmationAlert = UIAlertController(title: "Confirm Add Resource", message: "Are you sure you want to add this resource?", preferredStyle: .alert)
            
            // Add a "Cancel" action to allow the user to cancel the action
            confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            // Add a "Confirm" action to proceed with uploading the resource
            confirmationAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                self.uploadAndAddResource()
            }))
            
            // Present the confirmation alert to the user
            present(confirmationAlert, animated: true, completion: nil)
            
        } else {
            // Alert the user if the image is not selected or fields are empty
            let alert = UIAlertController(title: "Missing Information", message: "Please ensure all fields are filled and an image is selected.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }


    // Validate that all the required text fields are filled
    func isValidInput() -> Bool {
        return !(txtResourceTitle.text?.isEmpty ?? true) &&
               !(sectionOneHeader.text?.isEmpty ?? true) &&
               !(sectionOneContent.text?.isEmpty ?? true) &&
               !(sectionTwoHeader.text?.isEmpty ?? true) &&
               !(sectionTwoContent.text?.isEmpty ?? true) &&
               !(sectionThreeHeader.text?.isEmpty ?? true) &&
               !(sectionThreeContent.text?.isEmpty ?? true) &&
               !(sectionFourHeader.text?.isEmpty ?? true) &&
               !(sectionFourContent.text?.isEmpty ?? true)
    }

    // Function to upload the image and add the resource to Firestore
    func uploadAndAddResource() {
        // Prepare section headers and contents
        let sectionHeaders = [
            sectionOneHeader.text!,
            sectionTwoHeader.text!,
            sectionThreeHeader.text!,
            sectionFourHeader.text!
        ]
        
        let sectionContents = [
            sectionOneContent.text!,
            sectionTwoContent.text!,
            sectionThreeContent.text!,
            sectionFourContent.text!
        ]
        
        // Get the selected image from imgResource UIImageView
        guard let selectedImage = imgResource.image else {
            print("No image selected.")
            return
        }

        let resourceTitle = txtResourceTitle.text ?? ""
        let imageName = "\(resourceTitle).png" // Modify as needed
        
        // Call AuthManager function to add resource to Firestore
        authManager.addNewResourceToLibrary(LibraryID: LibraryID ?? "", resourceTitle: resourceTitle, resourceImage: selectedImage, sectionHeaders: sectionHeaders, sectionContents: sectionContents, imageName: imageName) { success in
            if success {
                // Success: Show confirmation message
                let alert = UIAlertController(title: "Success", message: "Resource has been successfully added!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    // After the alert is dismissed, navigate back to the A_Library view
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                // Failure: Show error message
                let alert = UIAlertController(title: "Error", message: "Failed to add the resource. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    
    
    
    

    // MARK: - Back Button Action

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
