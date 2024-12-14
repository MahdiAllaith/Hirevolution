import UIKit

class BrowseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var FilerButton: UIButton!
    @IBOutlet weak var sereachTextFiled: UITextField!
    @IBOutlet weak var AppAllJobsTable: UITableView!
    
    // MARK: - Properties
    
    let authManager = AuthManager.shared
    var AppListedJobs: [JobList] = [] // Array to hold all the jobs data
    var searchJobs: [JobList] = []  // Array to hold filtered jobs
    var searching = false
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI setup
        FilerButton.layer.cornerRadius = 8
        sereachTextFiled.layer.cornerRadius = 8
        
        // Set the UITextField delegate
        sereachTextFiled.delegate = self
        
        // Load the jobs data from UserDefaults
        if let Jobs = authManager.loadAllJobsFromUserDefaults() {
            AppListedJobs = Jobs
            searchJobs = Jobs  // Initially show all jobs
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchJobs.count // Show filtered or all jobs
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BrowsJob", for: indexPath) as? BrowseCell else {
            return UITableViewCell()
        }
        
        // Configure cell with job data
        let jobListIndex = searchJobs[indexPath.row] // Use searchJobs here
        cell.configureCollectionCells(jobList: jobListIndex)
        cell.delegate = self // Set the delegate
        
        // Disable the default selection style for cells
        cell.selectionStyle = .none
        
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Do nothing to disable cell selection
    }
    
    // MARK: - UITextFieldDelegate Methods
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let searchText = textField.text else { return }
        
        if searchText.isEmpty {
            // If search text is empty, show all jobs
            searchJobs = AppListedJobs
        } else {
            // Filter jobs where the jobTitle starts with the search text (case-insensitive)
            searchJobs = AppListedJobs.filter { job in
                return job.jobTitle.lowercased().hasPrefix(searchText.lowercased())
            }
        }
        
        // Reload the table view to display the filtered results
        AppAllJobsTable.reloadData()
    }
}

// MARK: - BrowseCellDelegate

extension BrowseViewController: BrowseCellDelegate {
    func didTapViewJobButton(in cell: BrowseCell) {
        // Find the index path of the cell
        if let indexPath = AppAllJobsTable.indexPath(for: cell) {
            // Get the selected job
            let selectedJob = searchJobs[indexPath.row] // Use searchJobs here
            
            // Instantiate ApplyForJobView from the storyboard
            let SelectedJobDetailsView = UIStoryboard(name: "Mahdi", bundle: nil)
            if let applyJobVC = SelectedJobDetailsView.instantiateViewController(withIdentifier: "ApplyForJobView") as? ApplyForJobView {
                // Pass the selected job to ApplyForJobView
                applyJobVC.selectedJob = selectedJob
                
                // Increment job views count
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
