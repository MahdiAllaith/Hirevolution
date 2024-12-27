import UIKit

class ArticleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var viewLayoutHead: UIView!
    @IBOutlet weak var ArticleCollectionCard: UICollectionView!
    @IBOutlet weak var lblHead: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgArticlePage: UIImageView!
    
    let authManager = AuthManager.shared
    var resourcesData: [String: Any]?
    
    // Array to store articles (header and content)
    var articles: [[String: Any]] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure the tab bar is hidden in this view controller
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round the image view (imgArticlePage)
        roundImageView(imgArticlePage)
        
        // Step 1: Populate the labels and image view with values from resourcesData
        if let data = resourcesData {
            // Assign resourceTitle to lblHead
            if let resourceTitle = data["resourceTitle"] as? String {
                lblHead.text = resourceTitle
            }
            
            // Assign resourceDate to lblDate
            if let resourceDate = data["resourceDate"] as? String {
                lblDate.text = resourceDate
            }
            
            // Assign resourceImage to imgArticlePage UIImageView
            if let resourceImageURL = data["resourceImage"] as? String {
                // Use authManager to load the image into the imgArticlePage UIImageView
                authManager.loadImage(from: resourceImageURL, into: self.imgArticlePage)
            } else {
                // If the resourceImageURL is not available, set a default image
                self.imgArticlePage.image = UIImage(systemName: "person.fill")
            }

            // Step 2: Parse article data and store it in the articles array
            if let articleArray = data["article"] as? [[String: Any]] {
                articles = articleArray
            }

            // Reload the collection view to show the article data
            ArticleCollectionCard.delegate = self
            ArticleCollectionCard.dataSource = self
            ArticleCollectionCard.reloadData()
        }
    }

    // Helper function to round the image view
    func roundImageView(_ imageView: UIImageView) {
        imageView.layer.cornerRadius = imageView.frame.size.width / 15 // Use width or height for circular shape
    }
    
    // MARK: - Collection View Data Source Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return articles.count  // Each article will be in its own section
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1  // Each section will have one item (the content of the article)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let article = articles[indexPath.section]  // Use indexPath.section for articles
        
        // Content cell
        let contentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "contentCell", for: indexPath) as! ArticleCollectionViewCell
        
        // Fill the content cell with article content
        if let content = article["content"] as? String {  // Access "content" field in resourcesData
            contentCell.lblContent.text = content
        }
        
        return contentCell
    }
    
    // MARK: - Collection View Header (Section Header) Methods
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! HeaderCollectionReusableView
            
            let article = articles[indexPath.section]  // Use indexPath.section for section header
            
            if let header = article["header"] as? String {
                headerView.lblHeader.text = header
            }
            
            return headerView
        }
        
        return UICollectionReusableView()  // Return an empty view if not header
    }

    // MARK: - Collection View Layout (Optional, for custom header size)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)  // Adjust height as needed
    }
    
    // MARK: - Helper Method to Estimate Text Height for Dynamic Sizing
    // This method allows the cell size to change dynamically based on the content
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let article = articles[indexPath.section]  // Get the article data for the given index path
            
            // Get the content text from the article
            if let content = article["content"] as? String {
                
                // Estimate the height for the content label
                let estimatedHeight = estimateTextHeight(for: content)
                
                // Return the size for the item (width, height)
                // Set the width of the cell to the full width of the collection view
                return CGSize(width: collectionView.frame.width, height: estimatedHeight + 40)  // Add padding for top/bottom
            }
            
            // Default size if no content
            return CGSize(width: collectionView.frame.width, height: 100)
        }

        // Helper Method to Estimate Text Height for Dynamic Sizing
        func estimateTextHeight(for text: String) -> CGFloat {
            let maxWidth = self.view.frame.width  // Use the full width of the collection view
            let maxHeight: CGFloat = 1000  // Set a large max height to calculate properly
            
            // Calculate the bounding rect for the text, which will help estimate the height
            let rect = (text as NSString).boundingRect(with: CGSize(width: maxWidth, height: maxHeight),
                                                       options: .usesLineFragmentOrigin,
                                                       attributes: [.font: UIFont.systemFont(ofSize: 16)],
                                                       context: nil)
            
            return rect.height
        }
}
