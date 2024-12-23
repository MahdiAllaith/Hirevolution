//
//  SecondLibraryViewController.swift
//  Hirevolution
//
//  Created by BP-36-201-20 on 15/12/2024.
//

import UIKit

class SecondLibraryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionViewCard2: UICollectionView!
    var arrCards = [Card]()
    var selectedCard: Card?
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // Ensure the tab bar is always hidden in this view controller
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionViewCard2.collectionViewLayout as? UICollectionViewFlowLayout {
                    let screenWidth = UIScreen.main.bounds.width

                    // Set item size for collection view cells (width = screen width, height = 250)
                    layout.itemSize = CGSize(width: screenWidth, height: 250)

                    // Set the spacing between items
                    layout.minimumLineSpacing = 10  // Space between rows
                    layout.minimumInteritemSpacing = 0  // Space between items horizontally

                    // Reload the collection view to apply the updated layout
                    collectionViewCard2.reloadData()
                }
        collectionViewCard2.delegate = self
        collectionViewCard2.dataSource = self
        let workCardImage = UIImage(named: "workCardImage")
        
        // Check if the selectedCard exists
        if let selectedCard = selectedCard {
            // Check the title of the selected card and append accordingly
            if selectedCard.title == "  General Tips" {
                // Append General Tips related cards
                arrCards.append(Card(photo: workCardImage!, title: " Interview Tips"))
                arrCards.append(Card(photo: workCardImage!, title: " Time Management Tips"))
                arrCards.append(Card(photo: workCardImage!, title: " CV Building Tips"))
                arrCards.append(Card(photo: workCardImage!, title: " Public Speaking Tips"))
            } else if selectedCard.title == "  IT" {
                // Append IT related cards
                arrCards.append(Card(photo: workCardImage!, title: " The Rise of IOT"))
                arrCards.append(Card(photo: workCardImage!, title: " Introduction to Cloud Computing"))
                arrCards.append(Card(photo: workCardImage!, title: " What is CyberSecurity?"))
                arrCards.append(Card(photo: workCardImage!, title: " How to Start a Career in Software Development"))
            } else if selectedCard.title == "  Engineering" {
                // Append Engineering related cards
                arrCards.append(Card(photo: workCardImage!, title: " How to Choose the Right Engineering Field"))
                arrCards.append(Card(photo: workCardImage!, title: " The Importance of Ethics in Engineering"))
                arrCards.append(Card(photo: workCardImage!, title: " How to Land Your First Engineering Job"))
                arrCards.append(Card(photo: workCardImage!, title: " What is Civil Engineering?"))
            } else if selectedCard.title == "  Business" {
                // Append Business related cards
                arrCards.append(Card(photo: workCardImage!, title: " How to Start Your Own Business"))
                arrCards.append(Card(photo: workCardImage!, title: " The Impact of AI on Business Operations"))
                arrCards.append(Card(photo: workCardImage!, title: " The Basics of Digital Marketing"))
                arrCards.append(Card(photo: workCardImage!, title: " The Future of E-commerce"))
                arrCards.append(Card(photo: workCardImage!, title: " The Future of E-commerce"))
                arrCards.append(Card(photo: workCardImage!, title: " The Future of E-commerce"))
            }
        }
        
        
        // Reload the collection view to show the updated array of cards
        collectionViewCard2.reloadData()
    }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return arrCards.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionViewCard2.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCollectionViewCell
            
            let card = arrCards[indexPath.row]
            cell.setupCell(photo: card.photo, title: card.title)
            return cell
        }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get the selected card
        let card = arrCards[indexPath.row]
        
        // Debugging: Print the selected card's title
        print("Selected Card: \(card.title)")
        
        self.tabBarController?.tabBar.isHidden = true
        
        // Perform the segue and pass the selected card via sender
        performSegue(withIdentifier: "secondToArticle", sender: card)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "secondToArticle" {
            // Get the destination view controller
            if let articleVC = segue.destination as? ArticleViewController {
                // Pass the selected card to the destination view controller
                if let selectedCard = sender as? Card {
                    articleVC.selectedCardTitle = selectedCard.title
                    // Debugging: Print to ensure the card is passed correctly
                    print("Passing selected card: \(selectedCard.title) to ArticleViewController")
                }
            }
        }
    }


       
        
    }
    
    struct Card2 {
        let photo : UIImage
        let title : String
    }
