//
//  ApplyForJobView.swift
//  Hirevolution
//
//  Created by Mac 14 on 25/11/2024.
//


import UIKit

class ApplyForJobView: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let authManager = AuthManager.shared
    
    // Property to hold the selected job
    var selectedJob: JobList?

    var metteFiledReq: Bool = false
    var metteSkillsReq: Bool = false
    
    var jobRequirements: [String] = [] // Data for requirements table
    var jobSkills: [String] = [] // Data for skills table
    
    //
    @IBOutlet weak var JobTitle: UILabel!
    @IBOutlet weak var JobPostedDate: UILabel!
    @IBOutlet weak var JobViews: UILabel!
    @IBOutlet weak var JobDescription: UITextView!
    @IBOutlet weak var JobNots: UITextView!
    @IBOutlet weak var JobFeildReqTable: UITableView!
    @IBOutlet weak var JobSkillsReqTable: UITableView!
    @IBOutlet weak var JobSkillsReqLooder: UIActivityIndicatorView!
    @IBOutlet weak var FiledReqCheckerLooder: UIActivityIndicatorView!
    @IBOutlet weak var FiledCheckBoxImage: UIImageView!
    @IBOutlet weak var SkillsCkeckBoxImage: UIImageView!
    @IBOutlet weak var ApplyForJobButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if authManager.currentUser?.option == "admin" || authManager.currentUser?.option == "company"{
            ApplyForJobButton.isEnabled = false
        }
        
        // Calling data loader func
        JobTitle.text = selectedJob?.jobTitle
        JobPostedDate.text = "\( selectedJob!.jobDatePublished)"
        JobViews.text = "\(selectedJob!.jobViewsCount)"
        JobDescription.text = selectedJob?.jobDescription
        JobNots.text = selectedJob?.jobNotes
        
        jobSkills = selectedJob!.jobSkills
        jobRequirements = selectedJob!.jobFields
        
        setupTables()
        
        checkForRequirments() // will check requirements if met
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func backbutton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func ViewCompanyProfile(_ sender: Any) {
        let companyProfile = selectedJob?.companyProfile
            
        // Instantiate ViewedCompanyProfile from the storyboard
        let storyboard = UIStoryboard(name: "Yahya", bundle: nil)
        guard let ProfileView = storyboard.instantiateViewController(withIdentifier: "ViewedCompanyProfile") as? ViewedCompanyProfile else {
            print("Failed to instantiate ViewedCompanyProfile.")
            return
        }
            
        // Pass profile data to view
        ProfileView.Profile = companyProfile
            
        // Push onto the profile view
        self.present(ProfileView, animated: true)
    }
    
    @IBAction func ApplyForJob(_ sender: Any) {
        
        if authManager.currentUser?.userProfile?.userName != ""{
            
            let applyedJobsUser: [String] = (authManager.currentUser?.userApplicationsList!.appliedJobIDLink)!
            for applyedJobsUser in applyedJobsUser {
                if applyedJobsUser == selectedJob?.jobID{
                    showAlert(Title: "Error", message: "You already applied for this job")
                    return
                }
            }
            
            if metteFiledReq && metteSkillsReq {
                authManager.applyForJob(
                    userID: authManager.currentUser!.id,
                    userProfile: authManager.currentUser!.userProfile!,
                    jobID: selectedJob!.jobID
                ) { result in
                    switch result {
                    case .success():
                        
                        // Fetching data to update
                        self.authManager.fetchUserData(uid: self.authManager.currentUser!.id)
                        
                        self.showAlert(Title: "Success", message: "Your application was successful, wait for a response from employer")
                        
                        self.navigationController?.popToRootViewController(animated: true)
                        
                    case .failure(let error):
                        self.showAlert(Title: "Error", message: "Failed to apply for job: \(error.localizedDescription)")
                    }
                }
                
            } else {
                showAlert(Title: "Requirements not met", message: "You don't have the necessary requirements to apply for this job")
            }
            
        } else {
            showAlert(Title: "No Profile", message: "You didn't create your profile please! To apply for the job list you must have created your profile")
        }
    }
    
    private func showAlert(Title: String, message: String) {
        let alert = UIAlertController(title: Title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func checkForRequirments() {
        // Get job field and skill requirements
        guard let selectedJob = selectedJob else { return }
        let jobFiledReq = selectedJob.jobFields
        let jobSkillsReq = selectedJob.jobSkills

        // Initialize user's fields and skills
        var userFields: [String] = []
        if let workExperience = authManager.currentUser?.userProfile?.userWorkExperience {
            userFields = workExperience.map { $0.jobFiled }
        }
        let userSkills = authManager.currentUser?.userProfile?.userSkills ?? []

        // Start loaders
        FiledReqCheckerLooder.startAnimating()
        JobSkillsReqLooder.startAnimating()

        // Check job field requirements with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let meetsFieldReq = jobFiledReq.allSatisfy { userFields.contains($0) }
            self.FiledReqCheckerLooder.stopAnimating()
            if meetsFieldReq {
                self.FiledCheckBoxImage.image = UIImage(systemName: "checkmark")
                self.metteFiledReq = true
            } else {
                self.FiledCheckBoxImage.tintColor = UIColor(named: "Red") // Set the tint color
                self.FiledCheckBoxImage.image = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate)
                self.metteFiledReq = false
            }
        }

        // Check job skill requirements with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // Start after 3 + 3 seconds
            let meetsSkillReq = jobSkillsReq.allSatisfy { userSkills.contains($0) }
            self.JobSkillsReqLooder.stopAnimating()
            if meetsSkillReq {
                self.SkillsCkeckBoxImage.image = UIImage(systemName: "checkmark")
                self.metteSkillsReq = true
            } else {
                self.SkillsCkeckBoxImage.tintColor = UIColor(named: "Red") // Set the tint color
                self.SkillsCkeckBoxImage.image = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate)
                self.metteSkillsReq = false
            }
        }
    }
    
    private func setupTables() {
        configureTableView(JobSkillsReqTable)
        configureTableView(JobFeildReqTable)
        JobSkillsReqTable.register(UITableViewCell.self, forCellReuseIdentifier: "SkillCell")
        JobFeildReqTable.register(UITableViewCell.self, forCellReuseIdentifier: "FieldCell")
        JobSkillsReqTable.dataSource = self
        JobSkillsReqTable.delegate = self
        JobFeildReqTable.dataSource = self
        JobFeildReqTable.delegate = self
    }
    
    private func configureTableView(_ table: UITableView?) {
        table?.layer.cornerRadius = 8
        table?.layer.borderColor = UIColor(named: "Blue")?.cgColor
        table?.layer.borderWidth = 2
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == JobFeildReqTable {
            return jobRequirements.count
        } else {
            return jobSkills.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if tableView == JobFeildReqTable {
            cell = tableView.dequeueReusableCell(withIdentifier: "FieldCell", for: indexPath)
            cell.textLabel?.text = jobRequirements[indexPath.row]
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "SkillCell", for: indexPath)
            cell.textLabel?.text = jobSkills[indexPath.row]
        }
        return cell
    }
}
