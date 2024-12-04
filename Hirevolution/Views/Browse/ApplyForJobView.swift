//
//  ApplyForJobView.swift
//  Hirevolution
//
//  Created by Mac 14 on 25/11/2024.
//

import UIKit

class ApplyForJobView: UIViewController {

    // Property to hold the selected job
    var selectedJob: JobList?

    @IBAction func backbutton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Use `selectedJob` to populate the view with job details (if applicable)
        if let job = selectedJob {
            print("Job Title: \(job.jobTitle)")
            print("Job Description: \(job.jobDescription)")
            // Update UI elements with job data here
        }
    }
}
