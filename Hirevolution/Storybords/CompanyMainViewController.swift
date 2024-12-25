import UIKit

class CompanyMainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var arrJobApplications: [CompanyApplications] = [
        CompanyApplications(jobTitle: "Software Engineer", jobStatus: "Open", jobDate: "2024-12-15", numOfInterviews: "3", numOfApplications: "10"),
        CompanyApplications(jobTitle: "Product Manager", jobStatus: "Closed", jobDate: "2024-12-10", numOfInterviews: "2", numOfApplications: "5"),
        CompanyApplications(jobTitle: "UX Designer", jobStatus: "Open", jobDate: "2024-12-18", numOfInterviews: "4", numOfApplications: "8")
    ]

    @IBOutlet weak var CompanyCardCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set delegates and dataSource
        CompanyCardCollectionView.delegate = self
        CompanyCardCollectionView.dataSource = self

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
        let screenWidth = UIScreen.main.bounds.width
        let height: CGFloat = 250 // Increase this to give the cells more height
        return CGSize(width: screenWidth - 20, height: height)
    }
}

struct CompanyApplications {
    var jobTitle: String
    var jobStatus: String
    var jobDate: String
    var numOfInterviews: String
    var numOfApplications: String
}
