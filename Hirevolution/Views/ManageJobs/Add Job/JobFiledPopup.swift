//
//  JobFiledPopup.swift
//  Project-G5
//
//  Created by Mac 14 on 14/11/2024.
//

import UIKit

// MARK: - Protocol Definition
protocol JobFiledPopupDelegate: AnyObject {
    func jobSelectedOrDeselected(_ job: String) // Notify when a job is selected or deselected
}

// MARK: - Job Categories
let FiledICT = [
    "Software Engineer", "Data Analyst", "Cyber Security",
    "Game Developer", "Mobile Developer", "Tech Designer"
]
let FiledEngineering = [
    "Industrial Engineering", "Mechanical Engineering",
    "Electrical Engineering", "Civil Engineering",
    "Aerospace Engineering", "Chemical Engineering"
]
let FiledBusiness = [
    "Management", "Marketing", "Accounting",
    "Finance", "Economics", "Operations"
]
let FiledOther = [
    "Economics", "Chief", "Film Producer",
    "Influencer", "Drop Shipping"
]

class JobFiledPopup: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var FiledType: UISegmentedControl!    // Segmented control for selecting job categories
    @IBOutlet weak var FiledJobsTable: UITableView!     // Table view for displaying job fields
    
    // MARK: - Properties
    var currentJobs: [String] = FiledICT                 // Current jobs based on selected segment
    var selectedJobs: [String] = []                      // List of selected jobs
    var incomingSelectedJobs: [String] = []              // Jobs passed from the parent view
    weak var delegate: JobFiledPopupDelegate?            // Delegate to handle selection changes
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register a basic UITableViewCell class for reuse
        FiledJobsTable.register(UITableViewCell.self, forCellReuseIdentifier: "JobFieldCell")
        
        // Set the table view's data source and delegate
        FiledJobsTable.dataSource = self
        FiledJobsTable.delegate = self
        
        // Initialize job list and selected jobs
        updateJobFields(for: FiledType.selectedSegmentIndex)
        selectedJobs = incomingSelectedJobs
    }
    
    // MARK: - Actions
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        // Update job fields when the segmented control changes
        updateJobFields(for: sender.selectedSegmentIndex)
    }
    
    // MARK: - Helper Methods
    private func updateJobFields(for index: Int) {
        // Update the currentJobs array based on selected segment index
        switch index {
        case 0: currentJobs = FiledICT
        case 1: currentJobs = FiledBusiness
        case 2: currentJobs = FiledEngineering
        case 3: currentJobs = FiledOther
        default: currentJobs = []
        }
        
        // Reload table view to reflect changes
        FiledJobsTable.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobFieldCell", for: indexPath)
        let job = currentJobs[indexPath.row]
        
        // Configure cell text and accessory type
        cell.textLabel?.text = job
        cell.accessoryType = selectedJobs.contains(job) ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let job = currentJobs[indexPath.row]
        
        // Toggle selection state
        if selectedJobs.contains(job) {
            selectedJobs.removeAll { $0 == job } // Deselect job
        } else {
            selectedJobs.append(job)            // Select job
        }
        
        // Notify delegate about the change
        delegate?.jobSelectedOrDeselected(job)
        
        // Update cell UI
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
