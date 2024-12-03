//
//  BrowseViewController.swift
//  Hirevolution
//
//  Created by Mac 14 on 25/11/2024.
//

import UIKit

class BrowseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var FilerButton: UIButton!
    @IBOutlet weak var sereachTextFiled: UITextField!
    
    let authManager = AuthManager.shared
    
    // Array to hold all the jobs data
    var AppListedJobs: [JobList] = []
    
    @IBOutlet weak var AppAllJobsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FilerButton.layer.cornerRadius = 8
        sereachTextFiled.layer.cornerRadius = 8
        
        // Load the jobs data from UserDefaults
        if let Jobs = authManager.loadAllJobsFromUserDefaults() {
            AppListedJobs = Jobs
            print("Loaded all app jobs: \(AppListedJobs)")
        } else {
            print("Failed to load jobs from UserDefaults.")
        }
        
        // Set the tableview's data source and delegate
        AppAllJobsTable.dataSource = self
        AppAllJobsTable.delegate = self
        
        // Reload the table to display the data
        AppAllJobsTable.reloadData()
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppListedJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BrowsJob", for: indexPath) as? BrowseCell else {
            return UITableViewCell()
        }
        
        let jobListIndex = AppListedJobs[indexPath.row]
        cell.configureCollectionCells(jobList: jobListIndex)
        cell.delegate = self // Set the delegate
        
        // Disable the default selection style for cells
        cell.selectionStyle = .none
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Do nothing to disable cell selection
    }
}

extension BrowseViewController: BrowseCellDelegate {
    func didTapViewJobButton(in cell: BrowseCell) {
        // Find the index path of the cell
        if let indexPath = AppAllJobsTable.indexPath(for: cell) {
            // Get the selected job
            let selectedJob = AppListedJobs[indexPath.row]
            
            // Instantiate ApplyForJobView from the storyboard
            let SelectedJobDetailsView = UIStoryboard(name: "Mahdi", bundle: nil)
            if let applyJobVC = SelectedJobDetailsView.instantiateViewController(withIdentifier: "ApplyForJobView") as? ApplyForJobView {
                // Pass the selected job to ApplyForJobView
                applyJobVC.selectedJob = selectedJob
                
                // Increment by 1 for viewing job
                authManager.incrementJobViewsCount(jobID: selectedJob.jobID) { error in
                    if let error = error {
                        // Handle error (e.g., show alert)
                        print("Failed to increment job views: \(error.localizedDescription)")
                    } else {
                        // Successfully incremented views
                        print("Job views incremented successfully")
                    }
                }
                
                // Push ApplyForJobView onto the navigation stack
                navigationController?.pushViewController(applyJobVC, animated: true)
            }
        }
    }
}




