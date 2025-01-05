import UIKit
import FirebaseFirestore

class NotificationViewController: UIViewController, UITableViewDataSource {

    var TimeSech: [ScheduledInterviewWithJob] = []
    @IBOutlet weak var NotificationView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationView.dataSource = self
        
        // Fetch scheduled interviews from Firestore
        fetchScheduledInterviews()
    }

    // Fetch scheduled interviews from Firestore
    func fetchScheduledInterviews() {
        let db = Firestore.firestore()
        let userID = "currentUserID" // Replace with the actual current user ID.
        
        db.collection("users").document(userID).collection("interviews")
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting interviews: \(error.localizedDescription)")
                    return
                }
                
                self.TimeSech.removeAll()
                let group = DispatchGroup() // To wait for all job fetches to complete

                for document in snapshot!.documents {
                    if let interviewDate = document["interviewDate"] as? Timestamp,
                       let jobID = document["jobID"] as? String {
                        
                        group.enter() // Enter the group for each job fetch

                        // Fetch the job associated with this interview
                        self.fetchJobDetails(jobID: jobID) { job in
                            // Only proceed if job is not nil
                            if let job = job {
                                let scheduledInterview = ScheduledInterview(
                                    interviewDate: interviewDate.dateValue(),
                                    userID: userID,
                                    jobID: jobID
                                )
                                
                                let interviewWithJob = ScheduledInterviewWithJob(
                                    interviewDate: scheduledInterview.interviewDate,
                                    userID: scheduledInterview.userID,
                                    jobID: scheduledInterview.jobID,
                                    job: job
                                )
                                
                                self.TimeSech.append(interviewWithJob)
                            }
                            group.leave() // Leave the group once this job fetch is complete
                        }
                    }
                }
                
                // Notify when all fetches are complete
                group.notify(queue: .main) {
                    self.NotificationView.reloadData() // Reload table view with the new data
                }
            }
    }

    // Fetch job details based on jobID from Firestore
    func fetchJobDetails(jobID: String, completion: @escaping (JobList?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("jobs").document(jobID).getDocument { (document, error) in
            if let error = error {
                print("Error fetching job details: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let document = document, document.exists else {
                print("No job found with the given jobID")
                completion(nil)
                return
            }
            
            do {
                let job = try document.data(as: JobList.self)
                completion(job)
            } catch {
                print("Error decoding job data: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TimeSech.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! NotificationCell
        
        let interviewWithJob = TimeSech[indexPath.row]
        
        if let job = interviewWithJob.job {
            cell.configureCollectionCells(jobList: job, interviewDate: interviewWithJob.interviewDate)
        } else {
            cell.textLabel?.text = "Job details unavailable"
        }
        
        return cell
    }

    @IBAction func unwindToManage(_ sender: UIStoryboardSegue) {}
}
