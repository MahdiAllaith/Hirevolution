//
//  ManageJobsView.swift
//  Hirevolution
//
//  Created by Mac 14 on 21/11/2024.
//

import UIKit

class ManageJobsView: UIViewController {
    
    // MARK: - Properties
    private let authManager = AuthManager.shared
    private var companyListedJobs: [JobList] = [] // Array to hold the jobs data

    // MARK: - Outlets
    @IBOutlet weak var companyJobsTable: UITableView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadJobsData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        // Configure table view
        companyJobsTable.dataSource = self
        companyJobsTable.delegate = self
        companyJobsTable.reloadData()
    }
    
    private func loadJobsData() {
        if let companyJobs = authManager.loadCompanyJobsFromUserDefaults() {
            companyListedJobs = companyJobs
            print("Loaded jobs: \(companyListedJobs)")  // Debugging line to confirm data
        } else {
            print("Failed to load jobs from UserDefaults.")
        }
    }
}

// MARK: - UITableViewDataSource
extension ManageJobsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companyListedJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JobCell", for: indexPath) as? JobCell else {
            return UITableViewCell()
        }
        
        let jobListIndex = companyListedJobs[indexPath.row]
        cell.configureCell(jobList: jobListIndex) // Configure the cell with job data
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ManageJobsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the selected job
        let selectedJob = companyListedJobs[indexPath.row]
        
        // Instantiate JobsDetailsView from the storyboard
        let storyboard = UIStoryboard(name: "Mahdi", bundle: nil)
        guard let jobsDetailsVC = storyboard.instantiateViewController(withIdentifier: "JobDetailsView") as? JobsDetailsView else {
            print("Failed to instantiate JobsDetailsView.")
            return
        }
        
        // Pass the selected job to JobsDetailsView
        jobsDetailsVC.selectedJob = selectedJob
        
        // Push JobsDetailsView onto the navigation stack
        navigationController?.pushViewController(jobsDetailsVC, animated: true)
    }
}


