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
