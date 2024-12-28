//import UIKit
import Firebase

class UserMainPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let authManager = AuthManager.shared
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblViewMore: UILabel!
    @IBOutlet weak var lblJobStatus: UILabel!
    @IBOutlet weak var lblRecJobs: UILabel!
    @IBOutlet weak var jobStatusCollectionView: UICollectionView!
    @IBOutlet weak var jobRecCollectionView: UICollectionView!
    
    private var companyListedJobs: [JobList] = [] // Store company listed jobs
    private var jobStatuses: [JobStatus] = [] // Store dynamic job statuses
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar when this view appears
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar again when navigating away from this view
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the collection view's delegate and data source
        jobRecCollectionView.delegate = self
        jobRecCollectionView.dataSource = self
        jobStatusCollectionView.delegate = self
        jobStatusCollectionView.dataSource = self
        
        // Adjust collection view width based on screen size
        let screenWidth = UIScreen.main.bounds.width
        jobRecCollectionView.frame.size.width = screenWidth
        jobStatusCollectionView.frame.size.width = screenWidth
        
        // Customize the layout (e.g., spacing, item size)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10 // Space between rows
        layout.minimumInteritemSpacing = 10 // Space between items horizontally
        layout.itemSize = CGSize(width: 269, height: 214)
        
        // Check if the user is signed in
        if AuthManager.shared.userSession == nil {
            // User is not signed in, hide certain elements
            lblJobStatus.isHidden = true
            jobStatusCollectionView.isHidden = true
            stackView.isHidden = true
        } else {
            // User is signed in, show the elements
            lblJobStatus.isHidden = false
            jobStatusCollectionView.isHidden = false
            stackView.isHidden = false
        }
        
        // Fetch the jobs and update the collection views
        fetchAllJobsFromFirestore()
    }

    // Fetch all jobs from Firestore and populate the collection views
    func fetchAllJobsFromFirestore() {
        // Fetch jobs from Firestore
        Firestore.firestore().collection("jobs").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching jobs: \(error)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("No jobs found")
                return
            }
            
            var fetchedJobs: [JobList] = []
            
            // Decode the documents into JobList objects
            for document in snapshot.documents {
                do {
                    let job = try document.data(as: JobList.self)
                    fetchedJobs.append(job)
                } catch {
                    print("Error decoding job data: \(error)")
                }
            }
            
            // Use fetched jobs as both job recommendations and statuses
            self.companyListedJobs = fetchedJobs
            self.jobStatuses = self.createJobStatuses(from: fetchedJobs) // Create job statuses

            // Reload the collection views to display the new data
            DispatchQueue.main.async {
                self.jobRecCollectionView.reloadData()
                self.jobStatusCollectionView.reloadData()
            }
        }
    }
    
    // Create JobStatus objects from JobList
    func createJobStatuses(from jobs: [JobList]) -> [JobStatus] {
        var statuses: [JobStatus] = []
        
        for job in jobs {
            // You can customize the status based on the job
            let status = JobStatus(
                jobTitle: job.jobTitle,
                company: job.companyProfile.companyName,
                jobStatus: "Applied", // Customize status based on conditions
                jobApplicationDate: "\(job.jobDatePublished)"
            )
            statuses.append(status)
        }
        
        return statuses
    }
    
    // MARK: - UICollectionView DataSource and Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == jobRecCollectionView {
            return companyListedJobs.count  // Dynamically fetched jobs as recommendations
        } else if collectionView == jobStatusCollectionView {
            return jobStatuses.count  // Dynamically fetched job statuses
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == jobRecCollectionView {
            // Dequeue JobRecCollectionViewCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobRecCell", for: indexPath) as! JobRecCollectionViewCell
            
            let job = companyListedJobs[indexPath.row]
            // Configure the JobRecCollectionViewCell with data from JobList
            cell.lblJobTitle.text = job.jobTitle
            cell.lblJobCompany.text = job.companyProfile.companyName
            cell.lblJobDescription.text = job.jobDescription
            cell.lblJobRole.text = job.jobType
            cell.lblJobSalary.text = "$\(job.jobPotentialSalary)"
            cell.lblJobLocation.text = "Location TBD" // Add location if available
            
            // Load the company logo if available
            if !job.companyProfile.companyProfileLogo.isEmpty, let logoURL = URL(string: job.companyProfile.companyProfileLogo) {
                // Fetch the image data asynchronously
                URLSession.shared.dataTask(with: logoURL) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            // Set the image on the imageView
                            cell.imgJobRec.image = image
                        }
                    } else {
                        DispatchQueue.main.async {
                            // Fallback to default image if the URL is invalid or there's an error
                            cell.imgJobRec.image = UIImage(named: "workCardImage") // Default image
                        }
                    }
                }.resume()
            } else {
                // Fallback to default image if the logo URL is not available or empty
                cell.imgJobRec.image = UIImage(named: "workCardImage") // Default image
            }



            
            return cell
        } else if collectionView == jobStatusCollectionView {
            // Dequeue JobStatusCollectionViewCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobStatusCell", for: indexPath) as! JobStatusCollectionViewCell
            
            let jobStatus = jobStatuses[indexPath.row]
            // Configure the JobStatusCollectionViewCell with data from JobStatus
            cell.lblJobTitle.text = jobStatus.jobTitle
            cell.lblJobCompany.text = jobStatus.company
            
            // Prepending text before status and application date
            if let status = jobStatus.jobStatus {
                cell.lblJobStatus.text = "Status: \(status)"
            } else {
                cell.lblJobStatus.text = "Status: N/A"
            }
            
            if let applicationDate = jobStatus.jobApplicationDate {
                cell.lblJobApplicationDate.text = "Applied on: \(applicationDate)"
            } else {
                cell.lblJobApplicationDate.text = "Applied on: N/A"
            }
            
            return cell
        }
        
        return UICollectionViewCell() // Default return if something goes wrong
    }
}

struct Job {
    var jobTitle: String
    var company: String
    var description: String
    var role: String
    var salary: String
    var location: String
    var image: UIImage
}
struct JobStatus {
    var jobTitle: String
    var company: String
    var jobStatus: String?
    var jobApplicationDate: String?
}
