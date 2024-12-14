import UIKit

protocol JobFiledFilterDelegate: AnyObject {
    func jobSelectedOrDeselected(_ selectedJobs: [String])
}

let FilterICT = ["Software Engineer", "Data Analyst", "Cyber Security", "Game Developer", "Mobile Developer", "Tech Designer"]
let FilterEngineering = ["Industrial Engineering", "Mechanical Engineering", "Electrical Engineering", "Civil Engineering", "Aerospace Engineering", "Chemical Engineering"]
let FilterBusiness = ["Management", "Marketing", "Accounting", "Finance", "Economics", "Operations"]
let FilterOther = ["Economics", "Chief", "Film Producer", "Influencer", "Drop Shipping"]

class JobFiledFilter: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var FiledType: UISegmentedControl!
    @IBOutlet weak var FiledJobsTable: UITableView!

    var currentJobs: [String] = FilterICT // Default set to FilterICT
    var selectedJobs: [String] = [] // List of selected jobs
    var incomingSelectedJobs: [String] = [] // To store incoming selected jobs from BrowseViewController

    weak var delegate: JobFiledFilterDelegate? // Delegate to notify BrowseViewController about selection/deselection

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register UITableViewCell
        FiledJobsTable.register(UITableViewCell.self, forCellReuseIdentifier: "JobFieldCell")
        FiledJobsTable.dataSource = self
        FiledJobsTable.delegate = self

        // Initialize the selected jobs with the incoming selected jobs
        self.selectedJobs = incomingSelectedJobs
        updateJobFields(for: FiledType.selectedSegmentIndex) // Update the jobs based on the selected segment
    }

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        updateJobFields(for: sender.selectedSegmentIndex) // Change jobs when a new segment is selected
    }

    // Update job fields based on the selected segment index
    func updateJobFields(for index: Int) {
        switch index {
        case 0: currentJobs = FilterICT
        case 1: currentJobs = FilterBusiness
        case 2: currentJobs = FilterEngineering
        case 3: currentJobs = FilterOther
        default: currentJobs = []
        }
        FiledJobsTable.reloadData() // Reload table to show updated jobs
    }

    // UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentJobs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobFieldCell", for: indexPath)
        let job = currentJobs[indexPath.row]
        cell.textLabel?.text = job

        // Add a checkmark if the job is selected
        if selectedJobs.contains(job) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }

    // UITableViewDelegate Method - Handle job selection and deselection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let job = currentJobs[indexPath.row]

        // Toggle selection of the job
        if selectedJobs.contains(job) {
            selectedJobs.removeAll { $0 == job }
        } else {
            selectedJobs.append(job)
        }

        // Notify delegate (BrowseViewController) about the updated selection
        delegate?.jobSelectedOrDeselected(selectedJobs)

        // Reload the row to update the checkmark state
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
