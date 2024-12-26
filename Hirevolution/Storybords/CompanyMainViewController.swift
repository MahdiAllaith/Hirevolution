import UIKit

class CompanyMainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var lblJobApps: UILabel!
    @IBOutlet weak var lblViewMore: UILabel!
    @IBOutlet weak var viewMoreNav: UIImageView!
    @IBOutlet weak var stckViewMore: UIStackView!
    
    var arrJobApplications: [CompanyApplications] = [
        CompanyApplications(jobTitle: "Software Engineer", jobStatus: "Open", jobDate: "2024-12-15", numOfInterviews: "3", numOfApplications: "10"),
        CompanyApplications(jobTitle: "Product Manager", jobStatus: "Closed", jobDate: "2024-12-10", numOfInterviews: "2", numOfApplications: "5"),
        CompanyApplications(jobTitle: "UX Designer", jobStatus: "Open", jobDate: "2024-12-18", numOfInterviews: "4", numOfApplications: "8")
    ]

    @IBOutlet weak var CompanyCardCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.toolbar.isHidden = true
        // Set delegates and dataSource
        CompanyCardCollectionView.delegate = self
        CompanyCardCollectionView.dataSource = self

        // Add tap gesture recognizer to the stack view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateToManageJobs))
        stckViewMore.addGestureRecognizer(tapGesture)
        stckViewMore.isUserInteractionEnabled = true // Make sure interaction is enabled
    }

    // MARK: - Navigation Function
    @objc func navigateToManageJobs() {
        // Load the other storyboard
        let otherStoryboard = UIStoryboard(name: "Mahdi", bundle: nil)  // Replace "OtherStoryboard" with the actual storyboard name
        
        // Instantiate the ManageJobsViewController from the other storyboard using the Storyboard ID
        if let manageJobsVC = otherStoryboard.instantiateViewController(withIdentifier: "ManageJobs") as? ManageJobsView {
            
            // Optionally, pass data to the new view controller here if needed
            // manageJobsVC.someData = "Data to pass"
            
            // Perform the navigation (push the view controller)
            navigationController?.pushViewController(manageJobsVC, animated: true)
        }
    }

    // MARK: - UICollectionView DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrJobApplications.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompanyCardCell", for: indexPath) as! CompanyCardCollectionViewCell

        let jobApplication = arrJobApplications[indexPath.item]

        // Populate the cell's labels with data from the model
        cell.lblCompanyTitle.text = jobApplication.jobTitle
        cell.lblCompanyApplications.text = jobApplication.numOfApplications
        cell.lblCompanyJobStatus.text = jobApplication.jobStatus
        cell.lblCompanyInterview.text = jobApplication.numOfInterviews
        cell.lblCompanyDate.text = jobApplication.jobDate

        return cell
    }

    // MARK: - UICollectionView Delegate Flow Layout Methods
    func collectionView(_ collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width // Use collectionView's bounds
        let itemSpacing: CGFloat = 10 // Adjust this if you want to add space between cells

        // Subtract any margins or padding you need for spacing
        let cellWidth = collectionViewWidth - 2 * itemSpacing // Subtracting left and right margins
        let height: CGFloat = 250 // Height for the cell
        return CGSize(width: cellWidth, height: height)
    }
}

struct CompanyApplications {
    var jobTitle: String
    var jobStatus: String
    var jobDate: String
    var numOfInterviews: String
    var numOfApplications: String
}
