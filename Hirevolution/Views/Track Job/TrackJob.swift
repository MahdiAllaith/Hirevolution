//
//  TrackJob.swift
//  Hirevolution
//
//  Created by user244481 on 12/15/24.
//

import UIKit

class TrackJob: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var TrackJobTableView: UITableView!
    
    var jobApplications = [JobDataApplicantList]()
    let authManager = AuthManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup TableView dataSource and delegate
        TrackJobTableView.dataSource = self
        TrackJobTableView.delegate = self
        
        // Fetch user data and job applications
        authManager.getUserDataAndJobApplications { [weak self] jobsData in
            if let jobsData = jobsData {
                self?.jobApplications = jobsData
                DispatchQueue.main.async {
                    self?.TrackJobTableView.reloadData()
                }
            } else {
                print("No job applications found")
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobApplications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackJobCell", for: indexPath) as! JobTrackCell
        let jobData = jobApplications[indexPath.row]
        
        cell.lblCompanyName.text = jobData.companyName
        cell.lblJobName.text = jobData.jobTitle
        cell.lblJobDescription.text = jobData.jobDescription
        cell.lblJobStatus.text = jobData.applicantStatus
        
        // Set the image based on the applicant status
        cell.imgStatus.image = UIImage(systemName: "circle.fill")
        
        switch jobData.applicantStatus {
        case "On-going":
            cell.imgStatus.tintColor = .orange
        case "Hired":
            cell.imgStatus.tintColor = .green
        case "Rejected":
            cell.imgStatus.tintColor = .red
        case "Cancelled":
            cell.imgStatus.tintColor = .black
        default:
            cell.imgStatus.tintColor = .white
        }
        
        // Set the cancel button action
        cell.btnCancel.tag = indexPath.row
        cell.btnCancel.addTarget(self, action: #selector(cancelButtonPressed(_:)), for: .touchUpInside)
        
        return cell
    }

    @objc func cancelButtonPressed(_ sender: UIButton) {
        // Get the index of the selected job
        let selectedJob = jobApplications[sender.tag]
        
        // Print the selected job's applicant status for debugging
        print("Selected job: \(selectedJob.jobTitle), Applicant Status: \(selectedJob.applicantStatus)")
        
        // Ensure the applicant status is not Hired, Rejected, or Cancelled
        guard selectedJob.applicantStatus != "Hired",
              selectedJob.applicantStatus != "Rejected",
              selectedJob.applicantStatus != "Cancelled" else {
            // If status is Hired, Rejected, or Cancelled, show an alert
            showAlert(message: "You cannot cancel this application because it is already \(selectedJob.applicantStatus).")
            return
        }
        
        // Show confirmation alert to the user
        let alertController = UIAlertController(title: "Cancel Application",
                                                message: "Are you sure you want to cancel this application?",
                                                preferredStyle: .alert)
        
        // Add Cancel button to dismiss the alert
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        // Add Confirm button to cancel the job application if the user confirms
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            // Print before updating the status to check if the correct data is passed
            print("User confirmed to cancel application. Proceeding to update status...")
            
            // Proceed with canceling the application by updating the status
            self.authManager.cancelJobApplicationStatus(jobData: selectedJob) { updatedJobData, success in
                if success {
                    // Print the updated job status for debugging
                    print("Updated job status to Cancelled for: \(updatedJobData?.jobTitle ?? "Unknown")")
                    
                    // Update the local jobApplications array and reload the table
                    if let updatedJobData = updatedJobData, let index = self.jobApplications.firstIndex(where: { $0.jobID == updatedJobData.jobID }) {
                        self.jobApplications[index] = updatedJobData
                        DispatchQueue.main.async {
                            self.TrackJobTableView.reloadData()
                        }
                    }
                } else {
                    // If update fails, show an error alert
                    self.showAlert(message: "Failed to cancel the application. Please try again later.")
                }
            }
        }))
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }


}
