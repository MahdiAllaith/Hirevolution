//
//  thirdLibraryView.swift
//  Hirevolution
//
//  Created by user244481 on 12/25/24.
//

import UIKit

class thirdLibraryView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let authManager = AuthManager.shared
    var libraryID: String?
    @IBOutlet weak var lblResourceTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var resourceImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var resourcesData: [String: Any]?
    
    // Array to store articles (header and content)
    var articles: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Print the received resourcesData for debugging
        print("Resources Data: \(String(describing: resourcesData))")
        
        // Step 1: Populate the labels and image view with values from resourcesData
        if let data = resourcesData {
            // Assign resourceTitle to lblResourceTitle
            if let resourceTitle = data["resourceTitle"] as? String {
                lblResourceTitle.text = resourceTitle
            }
            
            // Assign resourceDate to lblDate
            if let resourceDate = data["resourceDate"] as? String {
                lblDate.text = resourceDate
            }
            
            // Assign resourceImage to resourceImage UIImageView
            if let resourceImageURL = data["resourceImage"] as? String {
                // Use authManager to load the image into the resourceImage UIImageView
                authManager.loadImage(from: resourceImageURL, into: self.resourceImage)
            } else {
                // If the resourceImageURL is not available, set a default image
                self.resourceImage.image = UIImage(systemName: "person.fill")
            }

            // Step 2: Parse article data and store it in the articles array
            if let articleArray = data["article"] as? [[String: Any]] {
                articles = articleArray
            }
            
            collectionView.delegate = self
            collectionView.dataSource = self
        }
        
        // Reload the collection view to show the article data
        collectionView.reloadData()
    }
    
    // MARK: - Collection View Data Source Methods
    
    // This method now returns the number of sections based on the number of articles
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return articles.count  // Each article will be in its own section
    }
    
    // This method returns the number of items per section (each article has one item per section)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1  // Each section will have one item (the content of the article)
    }
    
    // This method configures the cell for the content
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Get the article for the current section (indexPath.section refers to the section now)
        let article = articles[indexPath.section]  // Use indexPath.section for articles
        
        // Content cell
        let contentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "contentCell", for: indexPath) as! thirdLibraryCell
        
        // Fill the content cell with article content
        if let content = article["content"] as? String {  // Access "content" field in Firestore
            contentCell.lblContent.text = content
        }
        
        return contentCell
    }
    
    // MARK: - Collection View Header (Section Header) Methods
    
    // This method configures the section header for each article
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // Only if the kind is section header, configure it
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerSection", for: indexPath) as! headerThirdLibrary
            
            // Get the article for the current section (indexPath.section refers to the section now)
            let article = articles[indexPath.section]  // Use indexPath.section for section header
            
            // Set the header for the section
            if let header = article["header"] as? String {
                headerView.lblHeader.text = header
            }
            
            return headerView
        }
        
        return UICollectionReusableView()  // Return an empty view if not header
    }

    // MARK: - Collection View Layout (Optional, for custom header size)
    
    // Set the size of section headers
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)  // Adjust height as needed
    }

    @IBAction func btnEdit(_ sender: Any) {
        
        // Ensure both libraryID and resourcesData are valid
        guard let libraryID = libraryID, let resourcesData = resourcesData else {
            print("LibraryID or resourcesData is missing.")
            return
        }
        
        // Instantiate the AdminEditresources view controller
        if let adminEditResourcesVC = self.storyboard?.instantiateViewController(withIdentifier: "AdminEditresources") as? AdminEditresources {
            
            // Pass the libraryID and resourcesData to AdminEditresources
            adminEditResourcesVC.libraryID = libraryID
            adminEditResourcesVC.resourcesData = resourcesData
            
            // Push the AdminEditresources view controller onto the navigation stack
            self.navigationController?.pushViewController(adminEditResourcesVC, animated: true)
        }
    }
    
    
    @IBAction func btnDelete(_ sender: Any) {
        
        // Ensure that both LibraryID and resourceID are passed and valid
        guard let libraryID = libraryID, let resourceID = resourcesData?["resourceID"] as? String else {
            print("LibraryID or resourceID is missing.")
            return
        }

        // Show a confirmation alert before proceeding with deletion
        let alert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this resource?", preferredStyle: .alert)
        
        // Add a "Cancel" button to dismiss the alert
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Add a "Delete" button to confirm the deletion
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            // Call the deleteResource method from AuthManager after confirmation
            self.authManager.deleteResource(libraryID: libraryID, resourceID: resourceID) { success, errorMessage in
                if success {
                    // Successfully deleted the resource
                    print("Resource deleted successfully.")
                    self.navigationController?.popViewController(animated: true)
                } else {
                    // Show an error message if something goes wrong
                    let errorMessage = errorMessage ?? "Unknown error occurred."
                    let errorAlert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }
            }
        }))
        
        // Present the confirmation alert
        self.present(alert, animated: true, completion: nil)
        
    }
    // Back Button Action
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
