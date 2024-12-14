<<<<<<<< Updated upstream:Hirevolution/Views/ManageJobs/Job Details/JobsDetailsView.swift
import UIKit

class JobsDetailsView: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var selectedJob: JobList? // Holds the selected job details
    var jobRequirements: [String] = [] // Data for requirements table
    var jobSkills: [String] = [] // Data for skills table

    @IBAction func BackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func EditButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Mahdi", bundle: nil)
        guard let anotherVC = storyboard.instantiateViewController(withIdentifier: "EditJobView") as? EditJobView else {
            print("Failed to instantiate AnotherView.")
            return
        }
        anotherVC.selectedJob = selectedJob
        // Push onto the same navigation stack
        navigationController?.pushViewController(anotherVC, animated: true)
    }

    
    @IBOutlet weak var FirstView: UIView!
    @IBOutlet weak var D_JobTitle: UILabel!
    @IBOutlet weak var D_JobDate: UILabel!
    @IBOutlet weak var D_JobStatus: UILabel!
    
    @IBOutlet weak var SecoundaryView: UIView!
    @IBOutlet weak var SecoundSubView: UIView!
    @IBOutlet weak var ApplicationCount: UILabel!
    @IBOutlet weak var CanceledCount: UILabel!
    @IBOutlet weak var RejectedCount: UILabel!
    @IBOutlet weak var InterviewCount: UILabel!
    
    @IBOutlet weak var AllApplicantsCollectionTable: UICollectionView!
    @IBOutlet weak var AllCandidateCollectionTable: UICollectionView!
    
    @IBOutlet weak var D_JobDiscription: UITextView!
    @IBOutlet weak var D_JobNots: UITextView!
    
    @IBOutlet weak var D_JobReguirementsTable: UITableView!
    @IBOutlet weak var D_JobSkillsReguirementsTable: UITableView!
    
    @IBOutlet weak var ThuredView: UIView!
    @IBOutlet weak var FourthView: UIView!
    @IBOutlet weak var FithView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        D_JobReguirementsTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        D_JobSkillsReguirementsTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        applyStyling()
        
        // Set delegates and data sources
        D_JobReguirementsTable.delegate = self
        D_JobReguirementsTable.dataSource = self
        D_JobSkillsReguirementsTable.delegate = self
        D_JobSkillsReguirementsTable.dataSource = self
        
        // Assign data to UI elements
        assignDataToUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func applyStyling(){
        // Set corner radius for views
        FirstView.layer.cornerRadius = 12
        SecoundaryView.layer.cornerRadius = 12
        SecoundSubView.layer.cornerRadius = 12
        ThuredView.layer.cornerRadius = 12
        FourthView.layer.cornerRadius = 12
        FithView.layer.cornerRadius = 12
        
        D_JobReguirementsTable.layer.cornerRadius = 12
        D_JobReguirementsTable.layer.borderWidth = 2
        D_JobReguirementsTable.layer.borderColor = UIColor(named: "Blue")?.cgColor
        
        D_JobSkillsReguirementsTable.layer.cornerRadius = 12
        D_JobSkillsReguirementsTable.layer.borderWidth = 2
        D_JobSkillsReguirementsTable.layer.borderColor = UIColor(named: "Blue")?.cgColor
    }
    
    func assignDataToUI() {
        guard let job = selectedJob else {
            print("No job selected")
            return
        }
        
        // Assign data to labels
        D_JobTitle.text = job.jobTitle
        D_JobDate.text = "\(job.jobDatePublished)" // Assuming job.date is a Date type
        if job.jobStatus == "On-going"{
            D_JobStatus.textColor = UIColor.orange
            D_JobStatus.text = job.jobStatus
        }else{
            print("")
        }
        
        
        // Assign statistics (counts)
        ApplicationCount.text = "\(job.jobApplyedApplicationsCount)"
        CanceledCount.text = "\(job.jobApplicationsCanceledCount)"
        RejectedCount.text = "\(job.jobRejectedApplicaintsCount)"
        InterviewCount.text = "\(job.jobInterViewedApplicaintsCount)"
        
        // Assign text views
        D_JobDiscription.text = job.jobDescription
        D_JobNots.text = job.jobNotes
        
        // Assign data to arrays and reload tables
        jobRequirements = job.jobFields // Assuming requirements is an array of strings in JobList
        jobSkills = job.jobSkills // Assuming skills is an array of strings in JobList
        D_JobReguirementsTable.reloadData()
        D_JobSkillsReguirementsTable.reloadData()
    }
    
    // MARK: - UITableView DataSource & Delegate Methods
    
    // MARK: Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == D_JobReguirementsTable {
            return jobRequirements.count
        } else if tableView == D_JobSkillsReguirementsTable {
            return jobSkills.count
        }
        return 0
    }
    
    // MARK: Cell Configuration
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if tableView == D_JobReguirementsTable {
            cell.textLabel?.text = jobRequirements[indexPath.row]
        } else if tableView == D_JobSkillsReguirementsTable {
            cell.textLabel?.text = jobSkills[indexPath.row]
        }
        
        return cell
    }
}
========
import UIKit

class JobsDetailsView: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Properties
    
    var selectedJob: JobList? // Holds the selected job details
    var jobRequirements: [String] = [] // Data for requirements table
    var jobSkills: [String] = [] // Data for skills table

    var applicaintsProfiles: [UserApplicationsStuff] = [] // Profiles of applicants
    var CandidatesProfiles: [UserApplicationsStuff] = [] // Profiles of candidates
    
    let ApplicationView = UIStoryboard(name: "Mahdi", bundle: nil).instantiateViewController(withIdentifier: "ApplicantsView") as! ApplicantsView // Conection to applicants view controller
    
    let MaanageApplicantView = UIStoryboard(name: "Mahdi", bundle: nil).instantiateViewController(withIdentifier: "ManageApplicant") as! ManageApplicant // Conection to applicants view controller
    
    // MARK: - Outlets
    
    @IBOutlet weak var FirstView: UIView!
    @IBOutlet weak var D_JobTitle: UILabel!
    @IBOutlet weak var D_JobDate: UILabel!
    @IBOutlet weak var D_JobStatus: UILabel!
    
    @IBOutlet weak var SecoundaryView: UIView!
    @IBOutlet weak var SecoundSubView: UIView!
    @IBOutlet weak var ApplicationCount: UILabel!
    @IBOutlet weak var CanceledCount: UILabel!
    @IBOutlet weak var RejectedCount: UILabel!
    @IBOutlet weak var InterviewCount: UILabel!
    
    @IBOutlet weak var AllApplicantsCollectionTable: UICollectionView!
    @IBOutlet weak var AllCandidateCollectionTable: UICollectionView!
    
    @IBOutlet weak var D_JobDiscription: UITextView!
    @IBOutlet weak var D_JobNots: UITextView!
    
    @IBOutlet weak var D_JobReguirementsTable: UITableView!
    @IBOutlet weak var D_JobSkillsReguirementsTable: UITableView!
    
    @IBOutlet weak var ThuredView: UIView!
    @IBOutlet weak var FourthView: UIView!
    @IBOutlet weak var FithView: UIView!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cells for tables
        D_JobReguirementsTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        D_JobSkillsReguirementsTable.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Set delegates and data sources
        AllApplicantsCollectionTable.delegate = self
        AllApplicantsCollectionTable.dataSource = self
        AllCandidateCollectionTable.delegate = self
        AllCandidateCollectionTable.dataSource = self
        D_JobReguirementsTable.delegate = self
        D_JobReguirementsTable.dataSource = self
        D_JobSkillsReguirementsTable.delegate = self
        D_JobSkillsReguirementsTable.dataSource = self
        
        AllApplicantsCollectionTable.reloadData()
        AllCandidateCollectionTable.reloadData()
        
        // Populate applicants and candidates
        setApplicaints()
        
        // Apply styles and assign data
        applyStyling()
        assignDataToUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - CollectionView DataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == AllApplicantsCollectionTable {
            return applicaintsProfiles.count // Number of applicants
        } else if collectionView == AllCandidateCollectionTable {
            return CandidatesProfiles.count // Number of candidates
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == AllApplicantsCollectionTable {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApplicantCell", for: indexPath) as! ApplicantCell
            let userApplication = applicaintsProfiles[indexPath.row]
            cell.configer(UserApplican: userApplication) // Configure applicant cell
            return cell
        } else if collectionView == AllCandidateCollectionTable {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CandidateCell", for: indexPath) as! CandidateCell
            let userApplication = CandidatesProfiles[indexPath.row]
            cell.configer(UserApplican: userApplication) // Configure candidate cell
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == AllApplicantsCollectionTable {
            let selectedProfile = applicaintsProfiles[indexPath.row]
            MaanageApplicantView.theSelectedJob = selectedJob
            MaanageApplicantView.theUserApplicantionDetails = selectedProfile
            print("its clicked applicnt")
            navigationController?.pushViewController(MaanageApplicantView, animated: true)
            
        } else if collectionView == AllCandidateCollectionTable {
            let selectedProfile = CandidatesProfiles[indexPath.row]
            MaanageApplicantView.theSelectedJob = selectedJob
            MaanageApplicantView.theUserApplicantionDetails = selectedProfile
            navigationController?.pushViewController(MaanageApplicantView, animated: true)
            
        }
    }
    
    // MARK: - TableView DataSource & Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == D_JobReguirementsTable {
            return jobRequirements.count
        } else if tableView == D_JobSkillsReguirementsTable {
            return jobSkills.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if tableView == D_JobReguirementsTable {
            cell.textLabel?.text = jobRequirements[indexPath.row]
        } else if tableView == D_JobSkillsReguirementsTable {
            cell.textLabel?.text = jobSkills[indexPath.row]
        }
        return cell
    }
    
    // MARK: - Button Actions
    
    @IBAction func BackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func EditButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Mahdi", bundle: nil)
        guard let anotherVC = storyboard.instantiateViewController(withIdentifier: "EditJobView") as? EditJobView else {
            print("Failed to instantiate AnotherView.")
            return
        }
        anotherVC.selectedJob = selectedJob
        navigationController?.pushViewController(anotherVC, animated: true)
    }
    
    @IBAction func ViewApplicants(_ sender: Any) {
        ApplicationView.passedSelectedJob = selectedJob
        ApplicationView.passedUserApplicantionDetails = applicaintsProfiles
        
        navigationController?.pushViewController(ApplicationView, animated: true)
        
    }
    
    @IBAction func viewCandidates(_ sender: Any) {
        ApplicationView.passedSelectedJob = selectedJob
        ApplicationView.passedUserApplicantionDetails = CandidatesProfiles
        
        
        navigationController?.pushViewController(ApplicationView, animated: true)
    }
    
    // MARK: - Helper Methods
    
    func setApplicaints() {
        // Check if jobHiredUser is set or not
        if let hiredUser = selectedJob?.jobHiredUser {
            // If jobHiredUser exists, process based on applicantStatus
            for UsersApplications in selectedJob!.ApplyedUsersApplications {
                if UsersApplications.applicantStatus == "Hired" {
                    CandidatesProfiles.append(UsersApplications)
                } else {
                    applicaintsProfiles.append(UsersApplications)
                }
            }
        } else {
            // If jobHiredUser does not exist, process based on isCandidate flag
            for UsersApplications in selectedJob!.ApplyedUsersApplications {
                if UsersApplications.isCandidate == true {
                    CandidatesProfiles.append(UsersApplications)
                } else {
                    applicaintsProfiles.append(UsersApplications)
                }
            }
        }
        
        // Reload data for UI components
        AllApplicantsCollectionTable.reloadData()
        AllCandidateCollectionTable.reloadData()
    }
    
    func applyStyling() {
        // Apply rounded corners to views
        [FirstView, SecoundaryView, SecoundSubView, ThuredView, FourthView, FithView].forEach {
            $0?.layer.cornerRadius = 12
        }
        
        // Apply styles to tables
        let borderColor = UIColor(named: "Blue")?.cgColor
        [D_JobReguirementsTable, D_JobSkillsReguirementsTable].forEach {
            $0?.layer.cornerRadius = 12
            $0?.layer.borderWidth = 2
            $0?.layer.borderColor = borderColor
        }
    }
    
    func assignDataToUI() {
        guard let job = selectedJob else {
            print("No job selected")
            return
        }
        // Assign job details to UI elements
        D_JobTitle.text = job.jobTitle
        D_JobDate.text = "\(job.jobDatePublished)"
        D_JobStatus.text = job.jobStatus
        D_JobStatus.textColor = job.jobStatus == "On-going" ? .orange : .black
        
        // Assign counts
        ApplicationCount.text = "\(job.jobApplyedApplicationsCount)"
        CanceledCount.text = "\(job.jobApplicationsCanceledCount)"
        RejectedCount.text = "\(job.jobRejectedApplicaintsCount)"
        InterviewCount.text = "\(job.jobInterViewedApplicaintsCount)"
        
        // Assign description and notes
        D_JobDiscription.text = job.jobDescription
        D_JobNots.text = job.jobNotes
        
        // Reload table data
        jobRequirements = job.jobFields
        jobSkills = job.jobSkills
        D_JobReguirementsTable.reloadData()
        D_JobSkillsReguirementsTable.reloadData()
    }
}
>>>>>>>> Stashed changes:Hirevolution/Views/ManageJobs/Job Details & view applicents/DetailsView/JobsDetailsView.swift
