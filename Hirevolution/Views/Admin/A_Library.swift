//
//  A_Library.swift
//  Hirevolution
//
//  Created by BP-36-201-22 on 04/12/2024.
//

import UIKit


class A_Library: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let authManager = AuthManager.shared
    var libraryData: [[String: Any]] = []
    
    @IBOutlet weak var libraryCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        libraryCollection.delegate = self
        libraryCollection.dataSource = self
        fetchLibraryData()
    }
    
    // Fetch library data using AuthManager
    func fetchLibraryData() {
        authManager.fetchLibrary { [weak self] data in
            self?.libraryData = data  // Assign the fetched data to the array
            print("Library Data: \(self?.libraryData ?? [])")  // Print the fetched data
            self?.libraryCollection.reloadData()  // Reload the collection view after data is loaded
        }
    }
    
    // MARK: - UICollectionView Delegate and DataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return libraryData.count  // Return the count of libraryData
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue the cell using the correct identifier "firstLibraryCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstLibraryCell", for: indexPath) as! firstCollectionLibraryCell
        
        let data = libraryData[indexPath.item]
        
        // Extract the title and image URL from the data
        if let title = data["title"] as? String {
            cell.lblTitle.text = title  // Set the title label
        }
        
        if let imageURL = data["image"] as? String {
            // Call AuthManager's loadImage function to load the image into the cell's image view
            authManager.loadImage(from: imageURL, into: cell.image)
        } else {
            // If imageURL is not available, set a default image
            cell.image.image = UIImage(systemName: "person.fill")
        }
        
        // For debugging, print the data for each item
        print("Data for item at \(indexPath.item): \(data)")
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get the selected data
        let selectedData = libraryData[indexPath.item]
        
        // Instantiate the SecondLibraryView controller from the storyboard
        if let secondLibraryVC = storyboard?.instantiateViewController(withIdentifier: "SecondLibraryView") as? SecondLibraryView {
            
            // Pass the selected data to the second library view controller
            secondLibraryVC.resourcesData = selectedData
            
            // Push the SecondLibraryView onto the navigation stack
            navigationController?.pushViewController(secondLibraryVC, animated: true)
        }
    }

}
