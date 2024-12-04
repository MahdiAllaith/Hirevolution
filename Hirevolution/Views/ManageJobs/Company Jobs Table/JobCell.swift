//
//  JobCell.swift
//  Hirevolution
//
//  Created by Mac 14 on 22/11/2024.
//

import UIKit

class JobCell: UITableViewCell {
    @IBOutlet weak var JobTitle: UILabel!
    
    @IBOutlet weak var ApplicationsCount: UILabel!
    
    @IBOutlet weak var JobStatus: UILabel!
    
    @IBOutlet weak var InterViewedCoount: UILabel!
    
    @IBOutlet weak var JobHiredName: UILabel!
    
    @IBOutlet weak var JobCreatedDate: UILabel!
    
    @IBOutlet weak var ViewedCount: UILabel!
    
    
    func configureCell(jobList: JobList) {
        // Set job title
        JobTitle.text = jobList.jobTitle

        // Convert ApplyedUsersApplications to String, in case it's an integer
        ApplicationsCount.text = "\(jobList.jobApplyedApplicationsCount)"

        // Set job status
        if jobList.jobStatus == "On-going"{
            JobStatus.textColor = UIColor.orange
            JobStatus.text = jobList.jobStatus
        }else{
            JobStatus.text = jobList.jobStatus
        }
        

        // Convert jobInterViewedApplicaintsCount to String, in case it's an integer
        InterViewedCoount.text = "\(jobList.jobInterViewedApplicaintsCount)"

        // Safely unwrap the optional jobHiredUser and provide a default value if nil
        JobHiredName.text = jobList.jobHiredUser?.userName ?? "Not Hired"

        // Format job date (assuming it's a Date)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        JobCreatedDate.text = formatter.string(from: jobList.jobDatePublished)

        // Convert jobViewsCount to String, in case it's an integer
        ViewedCount.text = "\(jobList.jobViewsCount)"
    }


}
