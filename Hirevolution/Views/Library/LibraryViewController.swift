//
//  LibraryViewController.swift
//  Hirevolution
//
//  Created by BP-36-201-20 on 15/12/2024.
//

import UIKit

class LibraryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let authManager = AuthManager.shared
    var libraryData: [[String: Any]] = []
    @IBOutlet weak var collectionViewCard: UICollectionView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Ensure the tab bar is always visible in this view controller
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the layout to adjust the item size to the screen width and add space
        fetchLibraryData()

        if let layout = collectionViewCard.collectionViewLayout as? UICollectionViewFlowLayout {
            // Dynamically set the item size based on the screen width
            let screenWidth = UIScreen.main.bounds.width

            // Set the size of the cell (adjust width and height here)
            let cellWidth = screenWidth * 0.95  // 90% of screen width (reduce width if needed)
            let cellHeight: CGFloat = 160  // Adjust the height as needed

            // Setting space between rows (vertical)
            layout.minimumLineSpacing = 10  // Space between rows
            layout.minimumInteritemSpacing = 0 // Space between items horizontally

            // Set item size (width = cellWidth, height = cellHeight)
            layout.itemSize = CGSize(width: cellWidth, height: cellHeight)

            // Apply the layout changes
            collectionViewCard.collectionViewLayout = layout
            collectionViewCard.reloadData()  // Reload to apply changes
        }
        
        collectionViewCard.delegate = self
        collectionViewCard.dataSource = self
    }

    func fetchLibraryData() {
        authManager.fetchLibrary { [weak self] data in
            self?.libraryData = data  // Assign the fetched data to the array
            print("Library Data: \(self?.libraryData ?? [])")  // Print the fetched data
            self?.collectionViewCard.reloadData()  // Reload the collection view after data is loaded
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return libraryData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
        
        let data = libraryData[indexPath.item]
        
        // Extract the title and image URL from the data
        if let title = data["title"] as? String {
            cell.lblCardTitle.text = title  // Set the title label
        }
        
        if let imageURL = data["image"] as? String {
            // Call AuthManager's loadImage function to load the image into the cell's image view
            authManager.loadImage(from: imageURL, into: cell.imgCardLibrary)
        } else {
            // If imageURL is not available, set a default image
            cell.imgCardLibrary.image = UIImage(systemName: "person.fill")
        }
        
        // For debugging, print the data for each item
        print("Data for item at \(indexPath.item): \(data)")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item clicked at index: \(indexPath.row)")
        
        
        let selectedData = libraryData[indexPath.item]

        // Perform the segue and pass the selected card via sender
        performSegue(withIdentifier: "libraryToSecond", sender: selectedData)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "libraryToSecond",
           let secondVC = segue.destination as? SecondLibraryViewController,
           let selectedData = sender as? [String: Any] {

            secondVC.resourcesData = selectedData
            self.tabBarController?.tabBar.isHidden = true
            print("Passing selected data to SecondLibraryViewController: \(selectedData["title"] as? String ?? "")")
        }
    }
}

