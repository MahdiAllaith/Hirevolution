//
//  AdminEditresources.swift
//  Hirevolution
//
//  Created by user244481 on 12/25/24.
//

import UIKit

class AdminEditresources: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    let authManager = AuthManager.shared
    var isImageSelected = false
    var libraryID: String?
    var resourcesData: [String: Any]?
    var resourceID: String?
    
    @IBOutlet weak var resourceTitle: UITextField!
    @IBOutlet weak var resourceImage: UIImageView!
    
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

           // Print to see what data is being passed
           print("Resources Data: \(String(describing: resourcesData))")

           if let data = resourcesData {
               // Set the resourceID properly
               resourceID = data["resourceID"] as? String  // Safely extract the resourceID

               // Load the image
               if let imageUrlString = data["resourceImage"] as? String {
                   authManager.loadImage(from: imageUrlString, into: resourceImage)
               }

               // Set the resource title
               resourceTitle.text = data["resourceTitle"] as? String

               // Handle the articles and populate sections
               if let articles = data["article"] as? [[String: Any]] {
                   for article in articles {
                       if let articleID = article["articleID"] {
                           // Handle articleID as a string or number
                           var id: Int?
                           
                           // Check if articleID is a string and convert to Int
                           if let articleIDString = articleID as? String {
                               id = Int(articleIDString)
                           }
                           // Or check if it's directly an integer
                           else if let articleIDInt = articleID as? Int {
                               id = articleIDInt
                           }
                           
                           // Switch based on the articleID
                           switch id {
                           case 1:
                               sectionOneHeader.text = article["header"] as? String
                               sectionOneContent.text = article["content"] as? String
                               print("Populating section 1")
                           case 2:
                               sectionTwoHeader.text = article["header"] as? String
                               sectionTwoContent.text = article["content"] as? String
                               print("Populating section 2")
                           case 3:
                               sectionThreeHeader.text = article["header"] as? String
                               sectionThreeContent.text = article["content"] as? String
                               print("Populating section 3")
                           case 4:
                               sectionFourHeader.text = article["header"] as? String
                               sectionFourContent.text = article["content"] as? String
                               print("Populating section 4")
                           default:
                               print("Unknown articleID: \(id ?? -1)")  // To capture any unexpected articleID values
                           }
                       }
                   }
               }
           }
       }
    

    


    @IBAction func btnChangeImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()

             // Set the source type to the photo library
             imagePickerController.sourceType = .photoLibrary

             // Set the delegate to handle the image selection
             imagePickerController.delegate = self

             // Present the image picker
             present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          // Get the selected image
          if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
              // Set the selected image to the resourceImage UIImageView
              resourceImage.image = selectedImage
              
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
    
    private func hasTextChanges() -> Bool {
        // Fetch the original values from resourcesData
        guard let data = resourcesData else {
            return false
        }

        // Fetch the original values from the data dictionary
        let originalResourceTitle = data["resourceTitle"] as? String ?? ""
        
        // Original articles sections data
        var originalSectionOneHeader = ""
        var originalSectionOneContent = ""
        var originalSectionTwoHeader = ""
        var originalSectionTwoContent = ""
        var originalSectionThreeHeader = ""
        var originalSectionThreeContent = ""
        var originalSectionFourHeader = ""
        var originalSectionFourContent = ""
        
        // Handle articles data and populate original section values
        if let articles = data["article"] as? [[String: Any]] {
            for article in articles {
                if let articleID = article["articleID"] {
                    // Convert articleID to an integer (it can be either String or Int)
                    var id: Int?
                    
                    // Check if articleID is a String and convert to Int
                    if let articleIDString = articleID as? String {
                        id = Int(articleIDString)  // Convert String to Int
                    }
                    // Or if it's already an Int
                    else if let articleIDInt = articleID as? Int {
                        id = articleIDInt  // Directly assign if it's already an Int
                    }
                    
                    // Now we have a consistent Int type for articleID, we can use it in the switch
                    switch id {
                    case 1:
                        originalSectionOneHeader = article["header"] as? String ?? ""
                        originalSectionOneContent = article["content"] as? String ?? ""
                    case 2:
                        originalSectionTwoHeader = article["header"] as? String ?? ""
                        originalSectionTwoContent = article["content"] as? String ?? ""
                    case 3:
                        originalSectionThreeHeader = article["header"] as? String ?? ""
                        originalSectionThreeContent = article["content"] as? String ?? ""
                    case 4:
                        originalSectionFourHeader = article["header"] as? String ?? ""
                        originalSectionFourContent = article["content"] as? String ?? ""
                    default:
                        print("Unknown articleID: \(id ?? -1)")  // To capture any unexpected articleID values
                    }
                }
            }
        }
        
        // Compare the text field values with the original data (no trimming of spaces)
        return resourceTitle.text != originalResourceTitle ||
               sectionOneHeader.text != originalSectionOneHeader ||
               sectionOneContent.text != originalSectionOneContent ||
               sectionTwoHeader.text != originalSectionTwoHeader ||
               sectionTwoContent.text != originalSectionTwoContent ||
               sectionThreeHeader.text != originalSectionThreeHeader ||
               sectionThreeContent.text != originalSectionThreeContent ||
               sectionFourHeader.text != originalSectionFourHeader ||
               sectionFourContent.text != originalSectionFourContent
    }


    
    @IBAction func btnEdit(_ sender: Any) {
        // Check if any text or image has changed
        let hasChanges = hasTextChanges() || isImageSelected
        
        if hasChanges {
            // Show confirmation alert
            let alertController = UIAlertController(title: "Confirm Changes", message: "Are you sure you want to update the resource?", preferredStyle: .alert)
            
            // Action for confirming the update
            let confirmAction = UIAlertAction(title: "Yes", style: .default) { _ in
                // Proceed with the update if confirmed
                self.updateResourceInFirestore()
            }
            
            // Action for canceling the update
            let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            
            // Add actions to the alert controller
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            // Present the alert
            self.present(alertController, animated: true, completion: nil)
        } else {
            // Inform the user that there are no changes
            print("No changes detected.")
        }
    }


    private func updateResourceInFirestore() {
        // Retrieve the new values from the text fields
        let resourceTitleText = resourceTitle.text ?? ""
        let sectionOneHeaderText = sectionOneHeader.text ?? ""
        let sectionOneContentText = sectionOneContent.text ?? ""
        let sectionTwoHeaderText = sectionTwoHeader.text ?? ""
        let sectionTwoContentText = sectionTwoContent.text ?? ""
        let sectionThreeHeaderText = sectionThreeHeader.text ?? ""
        let sectionThreeContentText = sectionThreeContent.text ?? ""
        let sectionFourHeaderText = sectionFourHeader.text ?? ""
        let sectionFourContentText = sectionFourContent.text ?? ""
        
        // Prepare the article data
        let articleData: [[String: Any]] = [
            ["articleID": 1, "header": sectionOneHeaderText, "content": sectionOneContentText],
            ["articleID": 2, "header": sectionTwoHeaderText, "content": sectionTwoContentText],
            ["articleID": 3, "header": sectionThreeHeaderText, "content": sectionThreeContentText],
            ["articleID": 4, "header": sectionFourHeaderText, "content": sectionFourContentText]
        ]
        
        // Call the method to update the Firestore document
        authManager.updateResourceInFirestore(libraryID: libraryID!, resourceID: resourceID!, resourceTitleText: resourceTitleText, sectionData: articleData, resourceImage: resourceImage.image, isImageSelected: isImageSelected) { success in
            if success {
                // Success: Show success alert and go back to root view
                let alertController = UIAlertController(title: "Success", message: "Resource updated successfully!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    // Ensure the tab bar is visible and navigate back to the root
                    self.navigationController?.popToRootViewController(animated: true)
                    self.tabBarController?.tabBar.isHidden = false // Show the tab bar
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                // Failure: Show failure alert
                let alertController = UIAlertController(title: "Error", message: "Failed to update resource. Please try again.", preferredStyle: .alert)
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                alertController.addAction(retryAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }





    
    
    
    
    @IBAction func btnBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)

        
    }
}
