//
//  ManageJobsView.swift
//  Hirevolution
//
//  Created by Mac 14 on 21/11/2024.
//

import UIKit

class ManageJobsView: UIViewController, UITableViewDelegate, UITableViewDataSource, ReloadTableJobsForCompanyUser {
    
    // MARK: - Properties
    private let authManager = AuthManager.shared
    private var companyListedJobs: [JobList] = [] // Array to hold the jobs data
    
    // MARK: - Outlets
    @IBOutlet weak var companyJobsTable: UITableView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView() // Setup table view and initial configurations
        loadJobsData() // Load job data for the company
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Reload Table Protocol Method
    func reload() {
        viewDidLoad() // Reload view when the protocol method is called
    }
    
    // MARK: - Action Methods
    @IBAction func AddNewJob(_ sender: Any) {
        // Check if the user has created a company profile before adding a new job
        if authManager.currentUser?.companyProfile?.companyName != "" {
            let CreateAccountView = UIStoryboard(name: "Mahdi", bundle: nil).instantiateViewController(withIdentifier: "AddJobView")
            self.navigationController?.pushViewController(CreateAccountView, animated: true)
        } else {
            showAlert(message: "You didn't create your profile! To add a new job list, you must have a company profile.")
        }
    }
    
    // MARK: - Private Methods
    private func setupView() {
        // Configure the table view
        companyJobsTable.dataSource = self
        companyJobsTable.delegate = self
        companyJobsTable.reloadData()
    }
    
    private func loadJobsData() {
        // Load job data from UserDefaults via AuthManager
        if let companyJobs = authManager.loadCompanyJobsFromUserDefaults() {
            companyListedJobs = companyJobs
            print("Loaded jobs: \(companyListedJobs)")  // Debugging line to confirm data
        } else {
            print("Failed to load jobs from UserDefaults.")
        }
    }
    
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        // Display an alert with a message
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
    }
    
    // MARK: - UITableViewDataSource and UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companyListedJobs.count // Return the number of jobs
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue reusable cell and configure it with job data
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JobCell", for: indexPath) as? JobCell else {
            return UITableViewCell()
        }
        
        let jobListIndex = companyListedJobs[indexPath.row]
        cell.configureCell(jobList: jobListIndex) // Configure the cell with job data
        return cell
    }
    
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

