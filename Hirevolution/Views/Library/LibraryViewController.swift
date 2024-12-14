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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionViewCard.delegate = self
        collectionViewCard.dataSource = self
        arrCards.append(Card(photo: UIImage(named: "workCardImage")!, title: "  General Tips"))
        arrCards.append(Card(photo: UIImage(named: "workCardImage")!, title: "  IT"))
        arrCards.append(Card(photo: UIImage(named: "workCardImage")!, title: "  Engineering"))
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
        let selectedCard = arrCards[indexPath.row]
        
        // Instantiate SecondLibraryViewController using the correct Storyboard ID
        if let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondLibraryViewController") as? SecondLibraryViewController {
            print("Successfully instantiated SecondLibraryViewController")
            
            secondVC.selectedCard = selectedCard
            
            self.present(secondVC, animated: true, completion: nil)
        } else {
            print("Error: Could not instantiate SecondLibraryViewController")
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
