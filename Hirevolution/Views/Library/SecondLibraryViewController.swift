//
//  SecondLibraryViewController.swift
//  Hirevolution
//
//  Created by BP-36-201-20 on 15/12/2024.
//

import UIKit

class SecondLibraryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    let authManager = AuthManager.shared


    @IBOutlet weak var collectionViewCard2: UICollectionView!
    var resourcesData: [String: Any]?
        var resourcesArray: [[String: Any]] = []

        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            // Set the collection view delegate and data source
            collectionViewCard2.delegate = self
            collectionViewCard2.dataSource = self
            
            // Extract the resources from resourcesData and store them in resourcesArray
            if let data = resourcesData, let resources = data["resources"] as? [[String: Any]] {
                resourcesArray = resources

            }
            
            // Reload the collection view to display the data
            collectionViewCard2.reloadData()

            // Apply dynamic layout for resourceCollection
            if let layout = collectionViewCard2.collectionViewLayout as? UICollectionViewFlowLayout {
                let screenWidth = UIScreen.main.bounds.width
                let cellWidth = screenWidth * 0.95  // Adjust width (95% of screen width)
                let cellHeight: CGFloat = 160  // Adjust height as needed
                
                // Set space between rows and items
                layout.minimumLineSpacing = 10  // Space between rows
                layout.minimumInteritemSpacing = 0 // Space between items horizontally
                
                // Set item size based on calculated width and height
                layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
                
                // Apply the layout changes
                collectionViewCard2.collectionViewLayout = layout
            }
        }
        
        override func viewWillAppear(_ animated: Bool) {
            tabBarController?.tabBar.isHidden = true
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
        
        // MARK: - UICollectionView Delegate and DataSource Methods
        
        // Return the number of items in the resourcesArray
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return resourcesArray.count  // Return the count of the resources array
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
            
            // Get the resource data for the current index
            let resource = resourcesArray[indexPath.item]
            
            // Set the resource title
            if let title = resource["resourceTitle"] as? String {
                cell.lblCardTitle.text = title
            }
            
            // Load the resource image from Firebase Storage using AuthManager's loadImage
            if let imageURL = resource["resourceImage"] as? String {
                authManager.loadImage(from: imageURL, into: cell.imgCardLibrary)
            } else {
                // If imageURL is not available, set the default image
                cell.imgCardLibrary.image = UIImage(systemName: "person.fill")
            }
            
            return cell
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            // Get the selected resource data from resourcesArray
            let selectedResource = resourcesArray[indexPath.item]
            print(selectedResource)

            // Perform segue with the selectedResource
            performSegue(withIdentifier: "secondToArticle", sender: selectedResource)
        }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "secondToArticle",
               let articleVC = segue.destination as? ArticleViewController,
               // Cast sender to the correct type of selectedResource
               let selectedResource = sender as? [String: Any] {

                articleVC.resourcesData = selectedResource

                // Access libraryID from resourcesData in this view controller
                if let libraryID = resourcesData?["id"] as? String {
                    
                    print("Passing libraryID: \(libraryID)")
                }

                print("Passing selected resource: \(selectedResource["resourceTitle"] ?? "") to ArticleViewController")
            }
        }
    }

