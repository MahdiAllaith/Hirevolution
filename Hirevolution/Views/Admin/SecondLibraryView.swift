//
//  SecondLibraryView.swift
//  Hirevolution
//
//  Created by user244481 on 12/24/24.
//

import UIKit


class SecondLibraryView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let authManager = AuthManager.shared

    @IBOutlet weak var resourceCollection: UICollectionView!
    var resourcesData: [String: Any]?
    var resourcesArray: [[String: Any]] = []  // This will store the actual resources

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the collection view delegate and data source
        resourceCollection.delegate = self
        resourceCollection.dataSource = self
       
        
        // Extract the resources from resourcesData and store them in resourcesArray
        if let data = resourcesData, let resources = data["resources"] as? [[String: Any]] {
            resourcesArray = resources
        }
        
        // Reload the collection view to display the data
        resourceCollection.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true

    }
    
    // MARK: - UICollectionView Delegate and DataSource Methods
    
    // Return the number of items in the resourcesArray
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resourcesArray.count  // Return the count of the resources array
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecondLibraryCell", for: indexPath) as! SecondLibraryCell
        
        // Get the resource data for the current index
        let resource = resourcesArray[indexPath.item]
        
        // Set the resource title
        if let title = resource["resourceTitle"] as? String {
            cell.lblResourceTitle.text = title
        }
        
        // Load the resource image from Firebase Storage using AuthManager's loadImage
        if let imageURL = resource["resourceImage"] as? String {
            authManager.loadImage(from: imageURL, into: cell.imgResourceImage)
        } else {
            // If imageURL is not available, set the default image
            cell.imgResourceImage.image = UIImage(systemName: "person.fill")
        }
        
        return cell
    }


   
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Get the selected resource data from resourcesArray
        let selectedResource = resourcesArray[indexPath.item]

        // Get the LibraryID from resourcesData (assuming it's in the parent dictionary)
        if let libraryID = resourcesData?["id"] as? String {
            // Push the thirdLibraryView controller
            if let thirdLibraryViewController = self.storyboard?.instantiateViewController(withIdentifier: "thirdLibraryView") as? thirdLibraryView {
                
                // Pass the selected resource data to thirdLibraryView
                thirdLibraryViewController.resourcesData = selectedResource // Pass the selected resource
                
                // Pass the LibraryID
                thirdLibraryViewController.libraryID = libraryID
                
                // Push the view controller
                self.navigationController?.pushViewController(thirdLibraryViewController, animated: true)
            }
        }

    }
    
    
    @IBAction func btnAdd(_ sender: Any) {
        
        if let data = resourcesData, let LibraryID = data["id"] as? String {
            
            // Instantiate the AdminAddresources view controller from the storyboard
            if let adminAddResourcesVC = self.storyboard?.instantiateViewController(withIdentifier: "AdminAddresources") as? AdminAddresources {
                
                // Pass the resource ID to the AdminAddresources view controller
                adminAddResourcesVC.LibraryID = LibraryID
                
                // Push the AdminAddresources view controller onto the navigation stack
                self.navigationController?.pushViewController(adminAddResourcesVC, animated: true)
            }
        }
        
    }
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false

    }
}
