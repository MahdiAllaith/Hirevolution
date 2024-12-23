//
//  LibraryViewController.swift
//  Hirevolution
//
//  Created by BP-36-201-20 on 15/12/2024.
//

import UIKit

class LibraryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionViewCard: UICollectionView!
    var arrCards = [Card]()
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // Ensure the tab bar is always visible in this view controller
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.setNavigationBarHidden(true, animated: animated)
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the layout to adjust the item size to the screen width and add space
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
        arrCards.append(Card(photo: UIImage(named: "workCardImage")!, title: "  General Tips"))
        arrCards.append(Card(photo: UIImage(named: "workCardImage")!, title: "  IT"))
        arrCards.append(Card(photo: UIImage(named: "workCardImage")!, title: "  Engineering"))
        arrCards.append(Card(photo: UIImage(named: "workCardImage")!, title: "  Business"))
        arrCards.append(Card(photo: UIImage(named: "workCardImage")!, title: "  Business"))
        arrCards.append(Card(photo: UIImage(named: "workCardImage")!, title: "  Business"))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewCard.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
        
        let card = arrCards[indexPath.row]
        cell.setupCell(photo: card.photo, title: card.title)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("Item clicked at index: \(indexPath.row)")
            
            // Get the selected card
            let selectedCard = arrCards[indexPath.row]
            
            // Debugging: Print the selected card's title
            print("Selected Card: \(selectedCard.title)")
        
            self.tabBarController?.tabBar.isHidden = true
            
            // Perform the segue and pass the selected card via sender
            performSegue(withIdentifier: "libraryToSecond", sender: selectedCard)
        }

        // Prepare for the segue to pass the selected card
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "libraryToSecond" {
                // Get the destination view controller
                if let secondVC = segue.destination as? SecondLibraryViewController {
                    // Pass the selected card
                    if let selectedCard = sender as? Card {
                        secondVC.selectedCard = selectedCard
                        // Debugging: Print to ensure the card is passed correctly
                        print("Passing selected card: \(selectedCard.title) to SecondLibraryViewController")
                    }
                }
            }
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

struct Card {
    let photo : UIImage
    let title : String
}
