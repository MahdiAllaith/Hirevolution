//
//  AddJobView.swift
//  Hirevolution
//
//  Created by Mac 14 on 19/11/2024.
//

import UIKit

protocol ReloadTableJobsForCompanyUser: AnyObject {
    func reload()
}

class AddJobView: UIViewController, JobFiledPopupDelegate, UITableViewDataSource, UITableViewDelegate, SkillsPopupDelegate {

    let authManager = AuthManager.shared
    
    // MARK: - IBOutlets
    @IBOutlet weak var JobTitle: UITextField!
    @IBOutlet weak var JobDiscription: UITextView!
    @IBOutlet weak var JobNots: UITextView!
    @IBOutlet weak var jobSalary: UITextField!
    @IBOutlet weak var SegJobType: UISegmentedControl!
    @IBOutlet weak var SkillsTable: UITableView!
    @IBOutlet weak var JobFiledsTable: UITableView!

    // MARK: - Properties
    weak var delegate: ReloadTableJobsForCompanyUser?
    var selectedSkills = [String]() // Store selected skills to display in SkillsTable
    var selectedJobs = [String]()   // Store selected jobs to display in JobFiledsTable

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextView(JobDiscription)
        configureTextView(JobNots)
        
        setupUI()
        setupTables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    // MARK: - IBActions
    @IBAction func BackButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func AddSkillsPopupButton(_ sender: Any) {
        presentSkillsPopup()
    }
    
    @IBAction func AddJobFiledPopupButton(_ sender: Any) {
        presentJobFiledPopup()
    }
    
    @IBAction func ListJobButtonClicked(_ sender: Any) {
        // Get the data from the UI components
        let jobTitle = JobTitle.text ?? ""
        let jobDescription = JobDiscription.text ?? ""
        let jobNotes = JobNots.text ?? ""
        let jobPotentialSalary = jobSalary.text ?? ""
        let jobSkills = selectedSkills
        let jobFields = selectedJobs

        // Map segment index to job type string
        let jobType: String
        switch SegJobType.selectedSegmentIndex {
        case 0:
            jobType = "full-time"
        case 1:
            jobType = "part-time"
        case 2:
            jobType = "contract"
        default:
            jobType = "unknown" // Fallback value if no valid selection
        }

        // Validate required fields
        guard !jobTitle.isEmpty else {
            showAlert(message: "Job Title is required.")
            return
        }
        guard !jobDescription.isEmpty else {
            showAlert(message: "Job Description is required.")
            return
        }
        
        guard !jobSkills.isEmpty else {
            showAlert(message: "At least one Job Skill is required.")
            return
        }
        
        guard !jobFields.isEmpty else {
            showAlert(message: "At least one Job Field is required.")
            return
        }

        // Call the createJob method
        authManager.createJob(
            jobTitle: jobTitle,
            jobDescription: jobDescription,
            jobNotes: jobNotes,
            jobPotentialSalary: jobPotentialSalary,
            jobType: jobType,
            jobSkills: jobSkills,
            jobFields: jobFields
        ) { [weak self] error in
            if let error = error {
                self?.showAlert(message: "Failed to create job: \(error.localizedDescription)")
            } else {
                // Show success alert
                self?.showAlert(message: "Job successfully created!") {
                    // Reload the data and navigate back after the success alert
                    
                    // Get the new data for browse
                    self?.authManager.fetchAllJobs { error in
                        if let error = error {
                            print("Error fetching jobs: \(error.localizedDescription)")
                        } else {
                            print("AppDelegate: Jobs fetched and stored in UserDefaults successfully.")
                        }
                    }
                    // Get the new data for company list
                    self?.authManager.fetchCompanyJobs() { error in
                        if let error = error {
                            print("Error fetching comapny jobs: \(error.localizedDescription)")
                        } else {
                            print("AppDelegate: Jobs fetched and stored in UserDefaults successfully.")
                        }
                    }
                    
                    self?.delegate?.reload()
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }

    // Helper function to show an alert
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Notification", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
    }


    // MARK: - Helper Methods
    private func setupUI() {
        // Configure UI elements
        [JobTitle, jobSalary].forEach { configureTextField($0) }
//        [JobDiscription, JobNots].forEach { configureTextView($0) }
        [SkillsTable, JobFiledsTable].forEach { configureTableView($0) }
    }
    
    private func setupTables() {
        // Register cells and set delegates for tables
        SkillsTable.register(UITableViewCell.self, forCellReuseIdentifier: "SelectedSkillCell")
        JobFiledsTable.register(UITableViewCell.self, forCellReuseIdentifier: "JobFieldCell")
        
        SkillsTable.dataSource = self
        SkillsTable.delegate = self
        JobFiledsTable.dataSource = self
        JobFiledsTable.delegate = self
    }
    
    private func presentSkillsPopup() {
        if let popupSkills = UIStoryboard(name: "Mahdi", bundle: nil).instantiateViewController(withIdentifier: "SkillsPopup") as? SkillsPopup {
            popupSkills.modalPresentationStyle = .pageSheet
            popupSkills.sheetPresentationController?.detents = [.medium()]
            popupSkills.sheetPresentationController?.prefersGrabberVisible = true
            popupSkills.delegate = self
            popupSkills.selectedSkills = selectedSkills
            present(popupSkills, animated: true)
        }
    }
    
    private func presentJobFiledPopup() {
        if let popupFiled = UIStoryboard(name: "Mahdi", bundle: nil).instantiateViewController(withIdentifier: "JobFiledPopup") as? JobFiledPopup {
            popupFiled.modalPresentationStyle = .pageSheet
            popupFiled.sheetPresentationController?.detents = [.medium()]
            popupFiled.sheetPresentationController?.prefersGrabberVisible = true
            popupFiled.delegate = self
            popupFiled.selectedJobs = selectedJobs
            present(popupFiled, animated: true)
        }
    }

    // Configure UITextField to add radius and stroke
    private func configureTextField(_ textField: UITextField?) {
        textField?.layer.cornerRadius = 8
        textField?.layer.borderColor = UIColor(named: "Blue")?.cgColor
        textField?.layer.borderWidth = 2
    }

    // Configure UITextView to add radius and stroke
    private func configureTextView(_ textView: UITextView?) {
        guard let textView = textView else{ return }
        
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = UIColor(named: "Blue")?.cgColor
        textView.layer.borderWidth = 2
        
        textView.clipsToBounds = true
    }
    
    private func configureTableView(_ table: UITableView?) {
        table?.layer.cornerRadius = 8
        table?.layer.borderColor = UIColor(named: "Blue")?.cgColor
        table?.layer.borderWidth = 2
    }

    // MARK: - JobFiledPopupDelegate
    func jobSelectedOrDeselected(_ job: String) {
        if selectedJobs.contains(job) {
            selectedJobs.removeAll { $0 == job }
        } else {
            selectedJobs.append(job)
        }
        JobFiledsTable.reloadData()
    }
    
    // MARK: - SkillsPopupDelegate
    func skillSelected(_ skill: String) {
        if !selectedSkills.contains(skill) {
            selectedSkills.append(skill)
            SkillsTable.reloadData()
        }
    }
    
    func skillDeselected(_ skill: String) {
        if let index = selectedSkills.firstIndex(of: skill) {
            selectedSkills.remove(at: index)
            SkillsTable.reloadData()
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == JobFiledsTable {
            return selectedJobs.count
        } else {
            return selectedSkills.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if tableView == JobFiledsTable {
            cell = tableView.dequeueReusableCell(withIdentifier: "JobFieldCell", for: indexPath)
            cell.textLabel?.text = selectedJobs[indexPath.row]
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "SelectedSkillCell", for: indexPath)
            cell.textLabel?.text = selectedSkills[indexPath.row]
        }
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        // Enable delete for both tables
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if tableView == JobFiledsTable {
                // Handle deletion for Job Fields
                selectedJobs.remove(at: indexPath.row)
                JobFiledsTable.deleteRows(at: [indexPath], with: .automatic)
            } else if tableView == SkillsTable {
                // Handle deletion for Skills
                selectedSkills.remove(at: indexPath.row)
                SkillsTable.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }

}

