import UIKit

class BrowseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{

    // MARK: - Outlets
    @IBOutlet weak var FilerButton: UIButton!
    @IBOutlet weak var sereachTextFiled: UITextField!
    @IBOutlet weak var AppAllJobsTable: UITableView!

    // MARK: - Properties
    let authManager = AuthManager.shared
    var AppListedJobs: [JobList] = []  // Holds all the job data
    var searchJobs: [JobList] = []  // Holds filtered jobs
    var selectedJobFields: [String] = []  // Holds selected job fields from the filter

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // UI setup
        FilerButton.layer.cornerRadius = 8
        sereachTextFiled.layer.cornerRadius = 8

        // Set the UITextField delegate
        sereachTextFiled.delegate = self

        // Load the jobs data from UserDefaults
        loadJobs()

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

    // MARK: - Loading Jobs
    func loadJobs() {
        // Load jobs from UserDefaults (or another source)
        if let jobs = authManager.loadAllJobsFromUserDefaults() {
            AppListedJobs = jobs
            searchJobs = jobs // Initially show all jobs
            print("Loaded jobs count: \(AppListedJobs.count)")
        } else {
            print("No jobs found in UserDefaults.")
        }
    }

    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchJobs.count // Show filtered jobs based on applied filters
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BrowsJob", for: indexPath) as? BrowseCell else {
            return UITableViewCell()
        }

        // Configure the cell with job data
        let job = searchJobs[indexPath.row]
        cell.configureCollectionCells(jobList: job)
       
        // Disable the default selection style for cells
        cell.selectionStyle = .none

        return cell
    }

    // MARK: - Filter Button Action (Show Popup)
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        // Instantiate the JobFiledFilter View Controller from the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        

    // MARK: - Search Text Field Handling
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let searchText = textField.text else { return }

        if searchText.isEmpty {
            // If search text is empty, show all jobs
            searchJobs = AppListedJobs
        } else {
            // Filter jobs based on search text
            searchJobs = AppListedJobs.filter { job in
                job.jobTitle.lowercased().contains(searchText.lowercased())
            }
        }

        // Apply filters after the search text is updated
        applyFilters()

        // Reload the table view to display the filtered results
        AppAllJobsTable.reloadData()
    }

    // MARK: - JobFiledFilterDelegate (Handle Filtered Jobs)
    func jobSelectedOrDeselected(_ selectedJobs: [String]) {
        // Update selected job fields based on the filter
        selectedJobFields = selectedJobs
        print("Selected job fields: \(selectedJobs)") // Debug statement

        // Apply filters after the user makes a selection
        applyFilters()

        // Reload the table to display the filtered jobs
        AppAllJobsTable.reloadData()
    }

    // MARK: - Applying Filters
    func applyFilters() {
        // Filter jobs based on selected job fields
        if selectedJobFields.isEmpty {
            searchJobs = AppListedJobs // Show all jobs if no fields are selected
        } else {
            // Filter jobs based on selected job fields
            searchJobs = AppListedJobs.filter { job in
                selectedJobFields.contains { field in
                    job.jobTitle.lowercased().contains(field.lowercased())
                }
            }
        }

        // Apply search text filtering if search text exists
        if let searchText = sereachTextFiled.text, !searchText.isEmpty {
            searchJobs = searchJobs.filter { job in
                job.jobTitle.lowercased().contains(searchText.lowercased())
            }
        }

        print("Filtered jobs count: \(searchJobs.count)") // Debug statement
    }
}
}
