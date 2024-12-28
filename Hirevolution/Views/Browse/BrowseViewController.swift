import UIKit

class BrowseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, BrowseCellDelegate {

    // MARK: - Outlets
    @IBOutlet weak var FilerButton: UIButton!              // Filter button
    @IBOutlet weak var sereachTextFiled: UITextField!      // Search text field
    @IBOutlet weak var AppAllJobsTable: UITableView!        // Table for listing jobs

    // MARK: - Properties
    let authManager = AuthManager.shared
    var AppListedJobs: [JobList] = []  // Array to hold all the jobs data
    var searchJobs: [JobList] = []     // Array to hold jobs based on search and filters
    var appliedFilters: [String] = []
    var FilteredJobs: [String] = []    // Store applied filter criteria (job fields)

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // UI setup
        FilerButton.layer.cornerRadius = 8
        sereachTextFiled.layer.cornerRadius = 8
        sereachTextFiled.delegate = self

        // Load jobs data from UserDefaults
        if let jobs = authManager.loadAllJobsFromUserDefaults() {
            AppListedJobs = jobs
            searchJobs = jobs  // Initially show all jobs
            print("Loaded all app jobs: \(AppListedJobs)")  // Debugging output
        } else {
            print("Failed to load jobs from UserDefaults.")
        }

        // Set table view data source and delegate
        AppAllJobsTable.dataSource = self
        AppAllJobsTable.delegate = self

        // Reload table to show data
        AppAllJobsTable.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    // MARK: - UITableView Data Source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Handle empty state (show no jobs message)
        if searchJobs.isEmpty {
            let messageLabel = UILabel()
            messageLabel.text = "No jobs found"
            messageLabel.textColor = .gray
            messageLabel.textAlignment = .center
            messageLabel.frame = tableView.bounds
            tableView.backgroundView = messageLabel
        } else {
            tableView.backgroundView = nil
        }

        return searchJobs.count  // Return filtered jobs count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BrowsJob", for: indexPath) as? BrowseCell else {
            return UITableViewCell()
        }

        let job = searchJobs[indexPath.row]  // Get the job at the filtered index
        cell.configureCollectionCells(jobList: job)
        cell.delegate = self  // Set the delegate for the cell

        // Disable the default cell selection style
        cell.selectionStyle = .none

        return cell
    }

    // MARK: - BrowseCellDelegate
    func didTapViewJobButton(in cell: BrowseCell) {
        if let indexPath = AppAllJobsTable.indexPath(for: cell) {
            let selectedJob = searchJobs[indexPath.row]
            let storyboard = UIStoryboard(name: "Mahdi", bundle: nil)
            if let applyJobVC = storyboard.instantiateViewController(withIdentifier: "ApplyForJobView") as? ApplyForJobView {
                applyJobVC.selectedJob = selectedJob

                // Increment job views count
                authManager.incrementJobViewsCount(jobID: selectedJob.jobID) { error in
                    if let error = error {
                        print("Failed to increment job views: \(error.localizedDescription)")  // Debugging output
                    } else {
                        print("Job views incremented successfully")  // Debugging output
                    }
                }

                navigationController?.pushViewController(applyJobVC, animated: true)
            }
        }
    }

    // MARK: - UITextFieldDelegate Methods (Search)
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let searchText = textField.text else { return }

        print("Search text entered: \(searchText)")  // Debugging output

        // If the search text is empty, show all jobs
        if searchText.isEmpty {
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
    
    @IBAction func unwindToBrowse(_ segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? JobFilterPopup {
            FilteredJobs = sourceVC.selectedJobs // Assuming selectedJobs is an array of Strings
            print("Filtered jobs: \(FilteredJobs)")  // Debugging output

            // Apply filters if there are any selected
            if FilteredJobs.isEmpty {
                // If no filters are selected, show all jobs
                searchJobs = AppListedJobs
            } else {
                // Filter the jobs based on selected filters in FilteredJobs
                searchJobs = AppListedJobs.filter { job in
                    // Only return jobs whose jobFields match any of the filters in FilteredJobs
                    return job.jobFields.contains { field in
                        FilteredJobs.contains(field)
                    }
                }
            }

            // Reload the table view with the filtered data
            AppAllJobsTable.reloadData()
        }
        
        
    }
}
