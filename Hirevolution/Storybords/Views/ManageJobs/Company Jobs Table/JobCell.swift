//
//  JobCell.swift
//  Hirevolution
//
//  Created by Mac 14 on 22/11/2024.
//

import UIKit

class JobCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var JobTitle: UILabel!
    @IBOutlet weak var ApplicationsCount: UILabel!
    @IBOutlet weak var JobStatus: UILabel!
    @IBOutlet weak var InterViewedCoount: UILabel!
    @IBOutlet weak var JobHiredName: UILabel!
    @IBOutlet weak var JobCreatedDate: UILabel!      
    @IBOutlet weak var ViewedCount: UILabel!
    
    // MARK: - Configure Cell
    func configureCell(jobList: JobList) {
        // Set the job title
        JobTitle.text = jobList.jobTitle

        // Display the number of applications, converting it to a String if necessary
        ApplicationsCount.text = "\(jobList.jobApplyedApplicationsCount)"

        // Set and style the job status
        if jobList.jobStatus == "On-going" {
            JobStatus.textColor = UIColor.orange   // Highlight "On-going" status in orange
            JobStatus.text = jobList.jobStatus
        } else {
            JobStatus.text = jobList.jobStatus
        }

        // Display the number of interviewed applicants, converting it to a String if necessary
        InterViewedCoount.text = "\(jobList.jobInterViewedApplicaintsCount)"

        // Display the hired user's name, or default to "Not Hired" if nil
        JobHiredName.text = jobList.jobHiredUser?.userName ?? "Not Hired"

        // Format and display the job's publication date (assumes jobDatePublished is a Date object)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        JobCreatedDate.text = formatter.string(from: jobList.jobDatePublished)

        // Display the number of views, converting it to a String if necessary
        ViewedCount.text = "\(jobList.jobViewsCount)"
    }
}
