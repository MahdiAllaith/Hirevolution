import UIKit
import FirebaseAuth
import FirebaseFirestore

// Job data model
struct Job {
    let jobID: String
    let jobTitle: String
    let jobDescription: String
    let jobStatus: String
    let companyName: String
}

class JobTracking: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Outlet for the table view
    @IBOutlet weak var tableView: UITableView!

    // Array to store job data
    var jobs: [Job] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the table view delegate and data source
        tableView.delegate = self
        tableView.dataSource = self

        // Fetch job details for the applied jobs of the current user
        fetchJobDetailsForAppliedJobs()
    }

    func fetchJobDetailsForAppliedJobs() {
        let db = Firestore.firestore()

        // 1. Get the current user's UID
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No user is logged in")
            return
        }

        // 2. Fetch the document where the 'id' field matches the current user's UID
        db.collection("users")
            .whereField("id", isEqualTo: userID) // Compare 'id' field with current user's UID
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting user documents: \(error)")
                    return
                }

                // Ensure that at least one user document is found
                guard let userDocument = querySnapshot?.documents.first else {
                    print("No user document found for userID: \(userID)")
                    return
                }

                // 3. Extract the applied job IDs from the user document
                guard let userApplicationsList = userDocument.data()["userApplicationsList"] as? [String: Any],
                      let appliedJobIDLinks = userApplicationsList["appliedJobIDLink"] as? [String] else {
                    print("userApplicationsList or appliedJobIDLink not found or invalid format in document: \(userDocument.documentID)")
                    return
                }

                // 4. Fetch job details for each applied job ID
                for jobID in appliedJobIDLinks {
                    // Print the jobID
                    print("Job ID: \(jobID)")  // This will print the job ID to the console

                    db.collection("jobs").document(jobID)
                        .getDocument { (jobDocument, error) in
                            if let error = error {
                                print("Error getting job document: \(error)")
                                return
                            }

                            guard let jobDocument = jobDocument, jobDocument.exists else {
                                print("Job document not found for ID: \(jobID)")
                                return
                            }

                            // 5. Extract job data
                            let jobData = jobDocument.data()!
                            let jobDescription = jobData["jobDescription"] as? String ?? ""
                            let jobStatus = jobData["jobStatus"] as? String ?? ""
                            let jobTitle = jobData["jobTitle"] as? String ?? ""

                            // Access companyName from companyProfile map
                            let companyName = (jobData["companyProfile"] as? [String: Any])?["companyName"] as? String ?? ""

                            // Step 6: Print the retrieved fields
                            print("Job ID: \(jobID)")
                            print("  Job Title: \(jobTitle)")
                            print("  Job Description: \(jobDescription)")
                            print("  Job Status: \(jobStatus)")
                            print("  Company Name: \(companyName)")

                            // Step 7: Create a Job object and append it to the jobs array
                            let job = Job(jobID: jobID, jobTitle: jobTitle, jobDescription: jobDescription, jobStatus: jobStatus, companyName: companyName)
                            self.jobs.append(job)

                            // Reload table view on the main thread after fetching all jobs
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                }
            }
    } // MARK: - UITableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the custom cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobTrackingCell", for: indexPath) as! JobTrackingCell

        // Get the job for this row
        let job = jobs[indexPath.row]

        // Populate the cell with the job details
        cell.lblJobName.text = job.jobTitle
        cell.lblJobDescription.text = job.jobDescription
        cell.lblJobStatus.text = job.jobStatus
        cell.lblCompanyName.text = job.companyName

        // Update the imgStatus based on job status
        cell.updateStatusImage(status: job.jobStatus)

        return cell
    }

    // MARK: - UITableView Delegate

    // Implement any table view delegate methods if needed
}
