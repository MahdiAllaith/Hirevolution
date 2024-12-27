//
//  ManageApplicant.swift
//  Hirevolution
//
//  Created by Mac 14 on 14/12/2024.
//

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
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setDateToView()
        
        
        if let hiredUser = theSelectedJob?.jobHiredUser {
            setCandidateButton.isEnabled = false
            scheduleInterViewButton.isEnabled = false
            RejectButton.isEnabled = false
            HireButton.isEnabled = false
        }else if theUserApplicantionDetails?.applicantStatus == "Canceled" {
            setCandidateButton.isEnabled = false
            scheduleInterViewButton.isEnabled = false
            RejectButton.isEnabled = false
            HireButton.isEnabled = false
            MassageButton.isEnabled = false
        }else if theUserApplicantionDetails?.applicantStatus == "Rejected"{
            setCandidateButton.isEnabled = false
            scheduleInterViewButton.isEnabled = false
            RejectButton.isEnabled = false
            HireButton.isEnabled = false
        }else{
            setCandidateButton.isEnabled = true
            scheduleInterViewButton.isEnabled = true
            RejectButton.isEnabled = true
            HireButton.isEnabled = true
            MassageButton.isEnabled = true
        }
        
    }
    
    // Update the view each time it appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDateToView() // Refresh the view whenever it is shown
        
        if let hiredUser = theSelectedJob?.jobHiredUser {
            setCandidateButton.isEnabled = false
            scheduleInterViewButton.isEnabled = false
            RejectButton.isEnabled = false
            HireButton.isEnabled = false
        }else if theUserApplicantionDetails?.applicantStatus == "Canceled" {
            setCandidateButton.isEnabled = false
            scheduleInterViewButton.isEnabled = false
            RejectButton.isEnabled = false
            HireButton.isEnabled = false
            MassageButton.isEnabled = false
        }else if theUserApplicantionDetails?.applicantStatus == "Rejected"{
            setCandidateButton.isEnabled = false
            scheduleInterViewButton.isEnabled = false
            RejectButton.isEnabled = false
            HireButton.isEnabled = false
        }else{
            setCandidateButton.isEnabled = true
            scheduleInterViewButton.isEnabled = true
            RejectButton.isEnabled = true
            HireButton.isEnabled = true
            MassageButton.isEnabled = true
        }
    }
    
    // MARK: - Actions

    // Back Button Action
    @IBAction func BackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    // View User Profile Button Action
    @IBAction func ViewUserProfileButton(_ sender: Any) {
        let MassageView = UIStoryboard(name: "Yhya", bundle: nil).instantiateViewController(withIdentifier: "ViewedApplicantProfile")
        self.navigationController?.pushViewController(MassageView, animated: true)
    }

    // View Message Button Action (Currently not implemented)
    @IBAction func ViewMassageButton(_ sender: Any) {
        // Uncomment and implement if needed
        // let MassageView = UIStoryboard(name: "Mohamed", bundle: nil).instantiateViewController(withIdentifier: "some")
        // self.present(MassageView, animated: true)
    }

    // Schedule Interview Button Action
    @IBAction func viewSchaduleInterViewToMassageButton(_ sender: Any) {
        if let popupSchadule = UIStoryboard(name: "Mohamed", bundle: nil).instantiateViewController(withIdentifier: "SechaduleInterviewPopUp") as? SechaduleInterviewPopUp {
            popupSchadule.modalPresentationStyle = .pageSheet
            popupSchadule.sheetPresentationController?.detents = [.medium()]
            popupSchadule.sheetPresentationController?.prefersGrabberVisible = true
            present(popupSchadule, animated: true)
        }
    }

    // Reject Application Button Action
    @IBAction func RejectApplciationButton(_ sender: Any) {
        showCustomAlert(
            title: "Reject Application",
            message: "Are you sure you want to reject this application?",
            confirmTitle: "Reject",
            confirmStyle: .destructive
        ) {
            // Update job in the database
            self.authManager.rejectApplicantStatus(jobID: self.theSelectedJob!.jobID, applicantID: self.theUserApplicantionDetails!.applicantUserID) { error in
                if let error = error {
                    print("Error updating job: \(error.localizedDescription)")
                } else {
                    print("Job updated successfully.")
                }
            }

            // Fetch user data again
            self.authManager.fetchUserData(uid: self.authManager.userSession!.uid)

        }
    }

    // Hire Applicant Button Action
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

                        // Update job in the database
                        self.authManager.hireApplicant(jobID: self.theSelectedJob!.jobID, applicantID: self.theUserApplicantionDetails!.applicantUserID) { error in
                            if let error = error {
                                print("Error updating job: \(error.localizedDescription)")
                            } else {
                                print("Job updated successfully.")
                            }
                        }

                        // Fetch user data again
                        self.authManager.fetchUserData(uid: self.authManager.userSession!.uid)

                        // Show success alert
                        let alertController = UIAlertController(title: "Success", message: "\(self.theUserApplicantionDetails?.applicantProfile.userName ?? "") is hired.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)

                        // Go back to the root view
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                )
            })
    }

    // Make Candidate Button Action
    @IBAction func MakeCAndidateButton(_ sender: Any) {
        guard var selectedJob = self.theSelectedJob else {
            print("Error: No selected job available.")
            return
        }

        if self.theUserApplicantionDetails!.isCandidate {
                showCustomAlert(
                    title: "Already Candidate",
                    message: "This applicant is already set as a candidate, do you want to unselect him?",
                    confirmTitle: "Unselect",
                    confirmStyle: .destructive
                ) {
                    self.isCandidateImage.image = UIImage(systemName: "star.fill") // Change image if selected as candidate
                    
                    // update the job in the database
                    self.authManager.updateCandidateStatus(jobID: self.theSelectedJob!.jobID, isCandidate: false, applicantID: self.theUserApplicantionDetails!.applicantUserID) { error in
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
                    
                    self.authManager.updateCandidateStatus(jobID: self.theSelectedJob!.jobID, isCandidate: true, applicantID: self.theUserApplicantionDetails!.applicantUserID) { error in
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

    // Set Data to View
    func setDateToView() {
        let userProfile = theUserApplicantionDetails!.applicantProfile

        // Find the main job experience
        let WorkExperince = userProfile.userWorkExperience
        var MainWork: WorkExperience?
        for workExperience in WorkExperince {
            if workExperience.mainJob {
                MainWork = workExperience
                break
            }
        }

        // Update candidate image
        if theUserApplicantionDetails!.isCandidate {
            isCandidateImage.image = UIImage(systemName: "star.fill")
        } else {
            isCandidateImage.image = UIImage(systemName: "star")
        }

        // Set user profile information
        userName.text = userProfile.userName
        userMainFiled.text = MainWork?.jobFiled
        userProfileAbout.text = userProfile.userAbout
        userApplicationStatus.text = theUserApplicantionDetails?.applicantStatus

        // Update application status color
        switch theUserApplicantionDetails?.applicantStatus {
            case "On-going":
                userApplicationStatus.textColor = UIColor.orange
            case "Rejected":
                userApplicationStatus.textColor = UIColor(named: "Red")
            case "Canceled":
                userApplicationStatus.textColor = UIColor(named: "Red")
            case "Hired":
                userApplicationStatus.textColor = UIColor.green
            default:
                break
        }

        // Download user profile image from Firebase Storage
        let imageURL = userProfile.userProfileImage
        let imageBAckgroundURL = userProfile.backgroundPictuer

        let storage = Storage.storage()

        // Validate imageURL for profile image
        if imageURL.isEmpty {
            self.userProfileImage.backgroundColor = UIColor.gray
        } else {
            let reference = storage.reference(forURL: imageURL)
            reference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Error downloading image: \(error)")
                    return
                }

                if let data = data {
                    let imagee = UIImage(data: data)
                    let newSize = CGSize(width: 100, height: 100)
                    let resizedImage = self.resizeImage(imagee!, to: newSize)

                    // Set the resized image to the UIImageView
                    self.userProfileImage.image = resizedImage
                    self.userProfileImage.layer.borderWidth = 1
                    self.userProfileImage.layer.borderColor = UIColor(named: "Blue")?.cgColor
                    self.userProfileImage.layer.cornerRadius = 50
                }
            }
        }

        // Validate background image
        if imageBAckgroundURL.isEmpty {
            self.userProfileBackground.backgroundColor = UIColor.gray
        } else {
            let reference2 = storage.reference(forURL: imageBAckgroundURL)
            reference2.getData(maxSize: 1 * 8024 * 8024) { data, error in
                if let error = error {
                    print("Error downloading image: \(error)")
                    return
                }

                if let data = data {
                    let imagee = UIImage(data: data)
                    let newSize = CGSize(width: 393, height: 160)
                    let resizedImage = self.resizeImage(imagee!, to: newSize)

                    // Set the resized image to the UIImageView
                    self.userProfileBackground.image = resizedImage
                }
            }
        }
    }

    // Resize image method
    func resizeImage(_ image: UIImage, to newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }

    // Custom Alert method
    func showCustomAlert(
        title: String,
        message: String,
        cancelTitle: String = "Cancel",
        confirmTitle: String,
        confirmStyle: UIAlertAction.Style = .default,
        confirmHandler: @escaping () -> Void
    ) {
        // Create the alert controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // Cancel Button
        alertController.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))

        // Confirm Button with custom handler
        let confirmAction = UIAlertAction(title: confirmTitle, style: confirmStyle, handler: { _ in
            confirmHandler()
        })
        alertController.addAction(confirmAction)

        // Present the alert from the current view controller
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func unwindToManage(_ sender: UIStoryboardSegue) {}

}
