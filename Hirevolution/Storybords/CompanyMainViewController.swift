import UIKit
import FirebaseFirestore
import FirebaseAuth

class CompanyMainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var lblJobApps: UILabel!
    @IBOutlet weak var lblViewMore: UILabel!
    @IBOutlet weak var viewMoreNav: UIImageView!
    @IBOutlet weak var stckViewMore: UIStackView!
    @IBOutlet weak var CompanyCardCollectionView: UICollectionView!

    var jobList: [JobList] = [] // Array to store fetched jobs directly

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.toolbar.isHidden = true
        
        // Set delegates and dataSource for the collection view
        CompanyCardCollectionView.delegate = self
        CompanyCardCollectionView.dataSource = self
        
        // Add tap gesture recognizer to the stack view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateToManageJobs))
        stckViewMore.addGestureRecognizer(tapGesture)
        stckViewMore.isUserInteractionEnabled = true // Make sure interaction is enabled

        // Load jobs from UserDefaults or Firestore
        loadCompanyJobs()
    }

    // MARK: - Navigation Function
    @objc func navigateToManageJobs() {
        // Load the other storyboard
        let otherStoryboard = UIStoryboard(name: "Mahdi", bundle: nil)  // Replace "Mahdi" with the actual storyboard name
        
        // Instantiate the ManageJobsViewController from the other storyboard using the Storyboard ID
        if let manageJobsVC = otherStoryboard.instantiateViewController(withIdentifier: "ManageJobs") as? ManageJobsView {
            // Optionally, pass data to the new view controller here if needed
            // manageJobsVC.someData = "Data to pass"
            
            // Perform the navigation (push the view controller)
            navigationController?.pushViewController(manageJobsVC, animated: true)
        }
    }

    // MARK: - Fetch Jobs from Firestore
    func fetchCompanyJobs(completion: @escaping (Error?) -> Void) {
        guard let currentUser = AuthManager.shared.currentUser else {
            completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No current user logged in"]))
            return
        }
        
        let companyID = currentUser.id
        
        // Firestore reference to the 'jobs' collection
        let jobsRef = Firestore.firestore().collection("jobs")
        
        // Query for jobs where the CompanyID matches the current user's uid
        jobsRef.whereField("CompanyID", isEqualTo: companyID).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(error)
                return
            }
            
            // Check if there are any documents retrieved
            guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                completion(nil)
                print("No jobs found for this company.")
                return
            }
            
            // Array to hold the fetched jobs
            var fetchedJobs: [JobList] = []
            
            // Loop through the documents and decode each job
            for document in querySnapshot.documents {
                do {
                    // Decode the job data into the JobList model
                    let job = try document.data(as: JobList.self)
                    fetchedJobs.append(job)
                } catch {
                    print("Error decoding job data: \(error)")
                }
            }
            
            // Save fetched jobs to UserDefaults
            let encoder = JSONEncoder()
            do {
                let encodedJobs = try encoder.encode(fetchedJobs)
                UserDefaults.standard.set(encodedJobs, forKey: "ApplicationJobsList")
                print("Jobs successfully saved to UserDefaults.")
                self.jobList = fetchedJobs // Directly assign fetched jobs
                self.CompanyCardCollectionView.reloadData() // Reload the collection view
                completion(nil)
            } catch {
                print("Error encoding jobs to UserDefaults: \(error)")
                completion(error)
            }
        }
    }

    // MARK: - Load Jobs from UserDefaults
    func loadCompanyJobs() {
        if let savedJobs = loadCompanyJobsFromUserDefaults() {
            self.jobList = savedJobs // Directly assign the loaded jobs
            self.CompanyCardCollectionView.reloadData() // Reload the collection view
        } else {
            // Fetch jobs from Firestore if no jobs are found in UserDefaults
            fetchCompanyJobs { error in
                if let error = error {
                    print("Error fetching jobs: \(error)")
                }
            }
        }
    }

    // MARK: - Load Company Jobs from UserDefaults
    func loadCompanyJobsFromUserDefaults() -> [JobList]? {
        // Retrieve the Data from UserDefaults
        if let savedJobsData = UserDefaults.standard.data(forKey: "ApplicationJobsList") {
            print("Retrieved jobs data: \(savedJobsData)") // For debugging
            
            // Decode the Data into an array of JobList objects
            let decoder = JSONDecoder()
            do {
                let decodedJobs = try decoder.decode([JobList].self, from: savedJobsData)
                print("Successfully decoded jobs from UserDefaults.")
                return decodedJobs
            } catch {
                print("Error decoding jobs from UserDefaults: \(error)")
                return nil
            }
        } else {
            print("No jobs data found in UserDefaults.")
            return nil
        }
    }

    // MARK: - UICollectionView DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobList.count // Return the count of JobList
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CompanyCardCell", for: indexPath) as! CompanyCardCollectionViewCell

        let job = jobList[indexPath.item] // Use the JobList object

        // Populate the cell's labels with data from the JobList model
        cell.lblCompanyTitle.text = job.jobTitle
        cell.lblCompanyApplications.text = "\(job.jobApplyedApplicationsCount)" // Use the count of applications
        cell.lblCompanyJobStatus.text = job.jobStatus
        cell.lblCompanyInterview.text = "\(job.jobScheduledForInterviewCount)" // Use the count of interviews scheduled
        cell.lblCompanyDate.text = formatDate(job.jobDatePublished)

        return cell
    }

    // Helper function to format the date
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
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
