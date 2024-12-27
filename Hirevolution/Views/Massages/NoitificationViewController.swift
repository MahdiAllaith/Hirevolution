import UIKit
import FirebaseFirestore

class NoitificationViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var NotificationView: UITableView!
    var TimeSech: [ScheduledInterviewWithJob] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationView.dataSource = self
        fetchScheduledInterviews()
    }

    // Fetches schedul from the Firebase
    func fetchScheduledInterviews() {
        let db = Firestore.firestore()
        let userID = "currentUserID"
        
        db.collection("users").document(userID).collection("interviews")
            .getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error getting interviews: \(error.localizedDescription)")
                    return
                }
                
               
                self.TimeSech.removeAll()

                // Parse the documents into Schedule
                for document in snapshot!.documents {
                    if let interviewDate = document["interviewDate"] as? Timestamp,
                       let jobID = document["jobID"] as? String {

                        // Fetch the job associated with this interview
                        self.fetchJobDetails(jobID: jobID) { job in
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
                            self.NotificationView.reloadData() // Reload table view with the new data
                        }
                    }
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
        
        // Ensure we have the job and interview date to pass to the cell
        if let job = interviewWithJob.job {
            cell.configureCollectionCells(jobList: job, interviewDate: interviewWithJob.interviewDate)
        }
        
        return cell
    }

    @IBAction func unwindToManage(_ send: UIStoryboardSegue) {}
}
