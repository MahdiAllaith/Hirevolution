import UIKit
import FirebaseStorage

class ManageApplicant: UIViewController {
    
    let authManager = AuthManager.shared
    var theSelectedJob: JobList? // Holds the selected job details
    var theUserApplicantionDetails: UserApplicationsStuff? // Holds the user applications
    
    @IBOutlet weak var userProfileBackground: UIImageView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var isCandidateImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userMainFiled: UILabel!
    @IBOutlet weak var userProfileAbout: UITextView!
    @IBOutlet weak var userApplicationStatus: UILabel!
    
    @IBOutlet weak var setCandidateButton: UIButton!
    @IBOutlet weak var scheduleInterViewButton: UIButton!
    @IBOutlet weak var RejectButton: UIButton!
    @IBOutlet weak var HireButton: UIButton!
    @IBOutlet weak var MassageButton: UIButton!
    var  userID1 = ""
    var jobID1 = ""
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDateToView()
        updateButtonStates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDateToView()
        updateButtonStates()
    }
    
    // MARK: - Actions
    
    @IBAction func BackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ViewUserProfileButton(_ sender: Any) {
        let MassageView = UIStoryboard(name: "Yhya", bundle: nil).instantiateViewController(withIdentifier: "ViewedApplicantProfile")
        self.navigationController?.pushViewController(MassageView, animated: true)
    }
    
    @IBAction func viewSchaduleInterViewToMassageButton(_ sender: Any) {
        // Ensure that applicantUserID and jobID are available
        guard let userID = theUserApplicantionDetails?.applicantUserID,
              let jobID = theSelectedJob?.jobID else {
            print("Error: Missing userID or jobID.")
            return
        }
        
        userID1 = userID
        jobID1 = jobID
        performSegue(withIdentifier: "toInterview", sender: nil)
        
    }
    
    @IBAction func RejectApplciationButton(_ sender: Any) {
        showCustomAlert(
            title: "Reject Application",
            message: "Are you sure you want to reject this application?",
            confirmTitle: "Reject",
            confirmStyle: .destructive
        ) {
            self.authManager.rejectApplicantStatus(jobID: self.theSelectedJob!.jobID, applicantID: self.theUserApplicantionDetails!.applicantUserID) { error in
                if let error = error {
                    print("Error updating job: \(error.localizedDescription)")
                } else {
                    print("Job updated successfully.")
                }
            }
            self.authManager.fetchUserData(uid: self.authManager.userSession!.uid)
        }
    }
    
    @IBAction func HireApplicantButton(_ sender: Any) {
        showCustomAlert(
            title: "Hire Application",
            message: "Are you sure you want to hire this applicant?",
            confirmTitle: "Yes",
            confirmHandler: {
                self.showCustomAlert(
                    title: "Warning",
                    message: "All other applicants will be subjected to rejection. Are you sure you want to continue and hire?",
                    confirmTitle: "Hire",
                    confirmHandler: {
                        self.authManager.hireApplicant(jobID: self.theSelectedJob!.jobID, applicantID: self.theUserApplicantionDetails!.applicantUserID) { error in
                            if let error = error {
                                print("Error updating job: \(error.localizedDescription)")
                            } else {
                                print("Job updated successfully.")
                            }
                        }
                        
                        self.authManager.fetchUserData(uid: self.authManager.userSession!.uid)
                        
                        let alertController = UIAlertController(title: "Success", message: "\(self.theUserApplicantionDetails?.applicantProfile.userName ?? "") is hired.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                        
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                )
            }
        )
    }
    
    @IBAction func MakeCAndidateButton(_ sender: Any) {
        guard let selectedJob = self.theSelectedJob else {
            print("Error: No selected job available.")
            return
        }
        
        let isCandidate = self.theUserApplicantionDetails?.applicantStatus == "Candidate"
        
        if isCandidate {
            showCustomAlert(
                title: "Already Candidate",
                message: "This applicant is already set as a candidate, do you want to unselect him?",
                confirmTitle: "Unselect",
                confirmStyle: .destructive
            ) {
                self.isCandidateImage.image = UIImage(systemName: "star") // Change image if unselected
                self.authManager.updateCandidateStatus(jobID: selectedJob.jobID, isCandidate: false, applicantID: self.theUserApplicantionDetails!.applicantUserID) { error in
                    if let error = error {
                        print("Error updating job: \(error.localizedDescription)")
                    } else {
                        print("Job updated successfully.")
                    }
                }
                self.authManager.fetchUserData(uid: self.authManager.userSession!.uid)
            }
        } else {
            showCustomAlert(
                title: "Make Candidate",
                message: "Are you sure you want to select this applicant as a candidate?",
                confirmTitle: "Select"
            ) {
                self.authManager.updateCandidateStatus(jobID: selectedJob.jobID, isCandidate: true, applicantID: self.theUserApplicantionDetails!.applicantUserID) { error in
                    if let error = error {
                        print("Error updating job: \(error.localizedDescription)")
                    } else {
                        print("Job updated successfully.")
                    }
                }
                self.authManager.fetchUserData(uid: self.authManager.userSession!.uid)
            }
        }
    }
    
    func setDateToView() {
        guard let userProfile = theUserApplicantionDetails?.applicantProfile else { return }
        
        isCandidateImage.image = userProfile.userWorkExperience.contains(where: { $0.jobTitle.contains("Candidate") }) ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        
        userName.text = userProfile.userName
        userMainFiled.text = userProfile.userWorkExperience.first(where: { $0.mainJob })?.jobFiled
        userProfileAbout.text = userProfile.userAbout
        userApplicationStatus.text = theUserApplicantionDetails?.applicantStatus
        
        switch theUserApplicantionDetails?.applicantStatus {
        case "On-going":
            userApplicationStatus.textColor = UIColor.orange
        case "Rejected", "Canceled":
            userApplicationStatus.textColor = UIColor(named: "Red")
        case "Hired":
            userApplicationStatus.textColor = UIColor.green
        default:
            break
        }
        
        downloadProfileImage(from: userProfile.userProfileImage, for: userProfileImage)
        downloadProfileImage(from: userProfile.backgroundPictuer, for: userProfileBackground)
    }
    
    private func downloadProfileImage(from url: String, for imageView: UIImageView) {
        guard !url.isEmpty else {
            imageView.backgroundColor = UIColor.gray
            return
        }
        
        let reference = Storage.storage().reference(forURL: url)
        reference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image: \(error)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                let resizedImage = self.resizeImage(image, to: CGSize(width: 100, height: 100))
                DispatchQueue.main.async {
                    imageView.image = resizedImage
                    imageView.layer.borderWidth = 1
                    imageView.layer.borderColor = UIColor(named: "Blue")?.cgColor
                    imageView.layer.cornerRadius = imageView.frame.size.width / 2
                }
            }
        }
    }
    
    func resizeImage(_ image: UIImage, to newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    func showCustomAlert(
        title: String,
        message: String,
        cancelTitle: String = "Cancel",
        confirmTitle: String,
        confirmStyle: UIAlertAction.Style = .default,
        confirmHandler: @escaping () -> Void
    ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
        let confirmAction = UIAlertAction(title: confirmTitle, style: confirmStyle, handler: { _ in confirmHandler() })
        alertController.addAction(confirmAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func updateButtonStates() {
        if (theSelectedJob?.jobHiredUser) != nil {
            setCandidateButton.isEnabled = false
            scheduleInterViewButton.isEnabled = false
            RejectButton.isEnabled = false
            HireButton.isEnabled = false
            MassageButton.isEnabled = false
        } else if let status = theUserApplicantionDetails?.applicantStatus,
                  ["Canceled", "Rejected"].contains(status) {
            setCandidateButton.isEnabled = false
            scheduleInterViewButton.isEnabled = false
            RejectButton.isEnabled = false
            HireButton.isEnabled = false
            MassageButton.isEnabled = false
        } else {
            setCandidateButton.isEnabled = true
            scheduleInterViewButton.isEnabled = true
            RejectButton.isEnabled = true
            HireButton.isEnabled = true
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInterview" {
            let vc = segue.destination as! SechaduleInterviewPopUp
            print(userID1)
            vc.userID = userID1
            vc.jobID = jobID1
        }
    }
    
    
    
    @IBAction func unwindToManger(_ segue: UIStoryboardSegue) {}
    
}
