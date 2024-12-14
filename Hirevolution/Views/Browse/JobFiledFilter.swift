
import UIKit

protocol JobFiledFilterDelegate: AnyObject {
    func jobSelectedOrDeselected(_ job: String)
}

// Rename arrays to more meaningful names
let FilterICT = ["Software Engineer", "Data Analyst", "Cyber Security", "Game Developer", "Mobile Developer", "Tech Designer"]
let FilterEngineering = ["Industrial Engineering", "Mechanical Engineering", "Electrical Engineering", "Civil Engineering", "Aerospace Engineering", "Chemical Engineering"]
let FilterBusiness = ["Management", "Marketing", "Accounting", "Finance", "Economics", "Operations"]
let FilterOther = ["Economics", "Chief", "Film Producer", "Influencer", "Drop Shipping"]

class JobFiledFilter: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var FiledType: UISegmentedControl!
    @IBOutlet weak var FiledJobsTable: UITableView!
    
    var currentJobs: [String] = FilterICT  // Updated array name
    var selectedJobs: [String] = []  // Keep track of selected jobs
    var incomingSelectedJobs: [String] = []  // New variable to store passed selected jobs

    var delegate: JobFiledPopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register a basic UITableViewCell class with the identifier "JobFieldCell"
        FiledJobsTable.register(UITableViewCell.self, forCellReuseIdentifier: "JobFieldCell")
        
        // Set the dataSource and delegate of the table view
        FiledJobsTable.dataSource = self
        FiledJobsTable.delegate = self
        
        // Set the initial data for the table view
        updateJobFields(for: FiledType.selectedSegmentIndex)
        
        // Assign passed selectedJobs to incomingSelectedJobs
        self.incomingSelectedJobs = selectedJobs
        self.selectedJobs = incomingSelectedJobs // Now we use incomingSelectedJobs to initialize selectedJobs
    }

    // Action triggered when the segmented control value changes
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        updateJobFields(for: sender.selectedSegmentIndex)
    }
    
    // Update the data source based on the selected segment index
    func updateJobFields(for index: Int) {
        switch index {
        case 0: currentJobs = FilterICT
        case 1: currentJobs = FilterBusiness
        case 2: currentJobs = FilterEngineering
        case 3: currentJobs = FilterOther
        default: currentJobs = []
        }
        
        FiledJobsTable.reloadData() // Reload table with the new data
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobFieldCell", for: indexPath)
        let job = currentJobs[indexPath.row]
        cell.textLabel?.text = job
        
        // If the job is selected, add a checkmark to the cell
        if selectedJobs.contains(job) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let job = currentJobs[indexPath.row]
        
        // If the job is selected, remove it from selectedJobs
        if selectedJobs.contains(job) {
            selectedJobs.removeAll { $0 == job }
        } else {
            // If not selected, add it to selectedJobs
            selectedJobs.append(job)
        }
        
        // Inform the delegate about the selection/deselection
        delegate?.jobSelectedOrDeselected(job)
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
