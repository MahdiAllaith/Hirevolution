import UIKit

class BrowseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, JobFilterPopupDelegate, BrowseCellDelegate {

    // MARK: - Outlets
    @IBOutlet weak var FilerButton: UIButton!              // Filter button
    @IBOutlet weak var sereachTextFiled: UITextField!      // Search text field
    @IBOutlet weak var AppAllJobsTable: UITableView!        // Table for listing jobs

    // MARK: - Properties
    let authManager = AuthManager.shared
    var AppListedJobs: [JobList] = []  // Array to hold all the jobs data
    var searchJobs: [JobList] = []     // Array to hold jobs based on search and filters
    var searching = false              // Flag for searching state
    var appliedFilters: [String] = []  // Store applied filter criteria (job fields)

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
            print("Loaded all app jobs: \(AppListedJobs)")
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

    // MARK: - JobFilterPopupDelegate Methods
    func jobFilterUpdated(filteredJobs: [JobList]) {
        // When the filter is applied, update the filtered jobs
        print("Filtered jobs in BrowseViewController: \(filteredJobs)")
        searchJobs = filteredJobs
        appliedFilters = filteredJobs.flatMap { $0.jobFields }  // Store all selected job fields in appliedFilters
        
        // After updating the filters, reapply the search and field filters
        applyFilters()

        // Reload the table to show the filtered jobs
        AppAllJobsTable.reloadData()
    }

    // MARK: - Filter Button Action
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        // Present the JobFilterPopup when the filter button is tapped
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let filterPopupVC = storyboard.instantiateViewController(withIdentifier: "JobFilterPopup") as? JobFilterPopup {
            filterPopupVC.delegate = self  // Set delegate to BrowseViewController
            filterPopupVC.allJobs = AppListedJobs  // Pass all jobs data to the popup
            filterPopupVC.incomingSelectedJobs = appliedFilters  // Pass selected filters to the popup
            self.present(filterPopupVC, animated: true, completion: nil)
        }
    }

    // MARK: - Apply Filters Method
    private func applyFilters() {
        // Start with all jobs
        searchJobs = AppListedJobs

        // Apply search filter if there's text in the search field
        if let searchText = sereachTextFiled.text, !searchText.isEmpty {
            searchJobs = searchJobs.filter { job in
                job.jobTitle.lowercased().contains(searchText.lowercased())
            }
        }

        // Apply job field filters if any filters are applied
        if !appliedFilters.isEmpty {
            searchJobs = searchJobs.filter { job in
                job.jobFields.contains { field in
                    appliedFilters.contains(field)
                }
            }
        }

        // Reload the table to reflect filtered jobs
        AppAllJobsTable.reloadData()
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
                        print("Failed to increment job views: \(error.localizedDescription)")
                    } else {
                        print("Job views incremented successfully")
                    }
                }

                navigationController?.pushViewController(applyJobVC, animated: true)
            }
        }
    }

    // MARK: - UITextFieldDelegate Methods (Search)
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // Apply filters after the search text is updated
        applyFilters()

        // Reload table to reflect the filtered results
        AppAllJobsTable.reloadData()
    }
}
