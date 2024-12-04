//
//  EditJobView.swift
//  Hirevolution
//
//  Created by Mac 14 on 27/11/2024.
//

import UIKit

class EditJobView: UIViewController, UITableViewDataSource, UITableViewDelegate, SkillsPopupDelegate, JobFiledPopupDelegate {
    
    // MARK: - Properties
    let authManager = AuthManager.shared
    var selectedJob: JobList? // Holds the selected job details
    var jobRequirements: [String] = [] // Data for requirements table
    var jobSkills: [String] = [] // Data for skills table
    
    // MARK: - IBOutlets
    @IBOutlet weak var E_JobTitle: UITextField!
    @IBOutlet weak var E_JobDiscription: UITextView!
    @IBOutlet weak var E_JobNots: UITextView!
    @IBOutlet weak var E_Salary: UITextField!
    @IBOutlet weak var E_JobType: UISegmentedControl!
    @IBOutlet weak var E_SkillsReq: UITableView!
    @IBOutlet weak var E_JobFiledReq: UITableView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTables()
        loadJobDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - UI Setup Methods
    private func setupUI() {
        configureTextField(E_JobTitle)
        configureTextView(E_JobDiscription)
        configureTextView(E_JobNots)
        configureTextField(E_Salary)
    }
    
    private func setupTables() {
        configureTableView(E_SkillsReq)
        configureTableView(E_JobFiledReq)
        E_SkillsReq.register(UITableViewCell.self, forCellReuseIdentifier: "SkillCell")
        E_JobFiledReq.register(UITableViewCell.self, forCellReuseIdentifier: "FieldCell")
        E_SkillsReq.dataSource = self
        E_SkillsReq.delegate = self
        E_JobFiledReq.dataSource = self
        E_JobFiledReq.delegate = self
    }
    
    private func configureTextField(_ textField: UITextField?) {
        textField?.layer.cornerRadius = 8
        textField?.layer.borderColor = UIColor(named: "Blue")?.cgColor
        textField?.layer.borderWidth = 2
    }
    
    private func configureTextView(_ textView: UITextView?) {
        textView?.layer.cornerRadius = 8
        textView?.layer.borderColor = UIColor(named: "Blue")?.cgColor
        textView?.layer.borderWidth = 2
    }
    
    private func configureTableView(_ table: UITableView?) {
        table?.layer.cornerRadius = 8
        table?.layer.borderColor = UIColor(named: "Blue")?.cgColor
        table?.layer.borderWidth = 2
    }
    
    // MARK: - Data Handling
    private func loadJobDetails() {
        guard let selectedJob = selectedJob else { return }
        E_JobTitle.text = selectedJob.jobTitle
        E_JobDiscription.text = selectedJob.jobDescription
        E_JobNots.text = selectedJob.jobNotes
        E_Salary.text = selectedJob.jobPotentialSalary
        E_JobType.selectedSegmentIndex = mapJobTypeToSegmentIndex(selectedJob.jobType)
        jobSkills = selectedJob.jobSkills
        jobRequirements = selectedJob.jobFields
        E_SkillsReq.reloadData()
        E_JobFiledReq.reloadData()
    }
    
    private func mapJobTypeToSegmentIndex(_ type: String) -> Int {
        switch type {
        case "full-time":
            return 0
        case "part-time":
            return 1
        case "contract":
            return 2
        default:
            return UISegmentedControl.noSegment
        }
    }
    
    // MARK: - IBActions
    @IBAction func SkillsButton(_ sender: Any) {
        presentSkillsPopup()
    }
    
    @IBAction func JobFiledReg(_ sender: Any) {
        presentJobFiledPopup()
    }
    
    @IBAction func BackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func EditJobButton(_ sender: Any) {
        // Show confirmation alert to ask user if they want to update
        showConfirmationAlert()
    }

    // MARK: - Alert Methods
    private func showConfirmationAlert() {
        let alert = UIAlertController(title: "Confirm Update", message: "Are you sure you want to update the job details?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { _ in
            // Proceed with updating the job details after user confirms
            self.updateSelectedJob()
        }))
        
        present(alert, animated: true, completion: nil)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Update Job
    private func updateSelectedJob() {
        guard let updatedJobTitle = E_JobTitle.text, !updatedJobTitle.isEmpty,
              let updatedJobDescription = E_JobDiscription.text, !updatedJobDescription.isEmpty,
              let updatedJobNotes = E_JobNots.text,
              let updatedSalary = E_Salary.text, !updatedSalary.isEmpty else {
            self.showAlert(message: "Please fill out all required fields.")
            return
        }
        
        selectedJob?.jobTitle = updatedJobTitle
        selectedJob?.jobDescription = updatedJobDescription
        selectedJob?.jobNotes = updatedJobNotes
        selectedJob?.jobPotentialSalary = updatedSalary
        selectedJob?.jobType = mapSegmentIndexToJobType(E_JobType.selectedSegmentIndex)
        selectedJob?.jobSkills = jobSkills
        selectedJob?.jobFields = jobRequirements
        
        self.authManager.updateJobInDatabase(updatedJob: selectedJob!) { error in
            if let error = error {
                self.showAlert(message: "Failed to update job: \(error.localizedDescription)")
            } else {
                self.showAlert(message: "Job updated successfully.")
                
                // Fetch the updated job data from the database
                self.authManager.fetchAllJobs { error in
                    if let error = error {
                        print("Failed to fetch all jobs: \(error.localizedDescription)")
                    } else {
                        // Handle the success case, possibly update the UI with the latest job data
                        print("Successfully fetched all jobs.")
                    }
                }
                
                // Fetch jobs for the company, if needed
                self.authManager.fetchCompanyJobs { error in
                    if let error = error {
                        print("Failed to fetch company jobs: \(error.localizedDescription)")
                    } else {
                        // Handle the success case for company jobs
                        print("Successfully fetched company jobs.")
                    }
                }
                
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

    private func mapSegmentIndexToJobType(_ index: Int) -> String {
        switch index {
        case 0:
            return "full-time"
        case 1:
            return "part-time"
        case 2:
            return "contract"
        default:
            return "full-time"
        }
    }

    // MARK: - Skills and Job Fields Popups
    private func presentSkillsPopup() {
        if let popupSkills = UIStoryboard(name: "Mahdi", bundle: nil).instantiateViewController(withIdentifier: "SkillsPopup") as? SkillsPopup {
            popupSkills.modalPresentationStyle = .pageSheet
            popupSkills.sheetPresentationController?.detents = [.medium()]
            popupSkills.sheetPresentationController?.prefersGrabberVisible = true
            popupSkills.delegate = self
            popupSkills.selectedSkills = jobSkills
            present(popupSkills, animated: true)
        }
    }
    
    private func presentJobFiledPopup() {
        if let popupFiled = UIStoryboard(name: "Mahdi", bundle: nil).instantiateViewController(withIdentifier: "JobFiledPopup") as? JobFiledPopup {
            popupFiled.modalPresentationStyle = .pageSheet
            popupFiled.sheetPresentationController?.detents = [.medium()]
            popupFiled.sheetPresentationController?.prefersGrabberVisible = true
            popupFiled.delegate = self
            popupFiled.selectedJobs = jobRequirements
            present(popupFiled, animated: true)
        }
    }

    // MARK: - SkillsPopupDelegate Methods
    func skillSelected(_ skill: String) {
        if !jobSkills.contains(skill) {
            jobSkills.append(skill)
            E_SkillsReq.reloadData()
        }
    }

    func skillDeselected(_ skill: String) {
        if let index = jobSkills.firstIndex(of: skill) {
            jobSkills.remove(at: index)
            E_SkillsReq.reloadData()
        }
    }
    
    // MARK: - JobFiledPopupDelegate Methods
    func jobSelectedOrDeselected(_ job: String) {
        if !jobRequirements.contains(job) {
            jobRequirements.append(job)
        } else {
            if let index = jobRequirements.firstIndex(of: job) {
                jobRequirements.remove(at: index)
            }
        }
        E_JobFiledReq.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == E_JobFiledReq {
            return jobRequirements.count
        } else {
            return jobSkills.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if tableView == E_JobFiledReq {
            cell = tableView.dequeueReusableCell(withIdentifier: "FieldCell", for: indexPath)
            cell.textLabel?.text = jobRequirements[indexPath.row]
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "SkillCell", for: indexPath)
            cell.textLabel?.text = jobSkills[indexPath.row]
        }
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == E_JobFiledReq {
            let job = jobRequirements[indexPath.row]
            jobSelectedOrDeselected(job)
        } else {
            let skill = jobSkills[indexPath.row]
            skillDeselected(skill)
        }
    }
}
