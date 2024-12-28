//
//  UserProfileViewController.swift
//  Hirevolution
//
//  Created by BP-36-201-22 on 04/12/2024.
//

import UIKit

class UserProfileViewController: UIViewController {
    let authManager = AuthManager.shared

    // MARK: - Outlets
    @IBOutlet var profileHeaderImage: UIImageView!
    @IBOutlet var profileUserImage: UIImageView!
    @IBOutlet var profileUserName: UILabel!
    @IBOutlet var profileUserRole: UILabel!
    @IBOutlet var profileDescription: UILabel!
    @IBOutlet var experiencesStackView: UIStackView!
    @IBOutlet var skillsStackView: UIStackView!
    @IBOutlet var cvsStackView: UIStackView!
    
    // MARK: - Properties
    var userName: String?
    var userRole: String?
    var aboutUserDescription: String?
    
    var experiences: [Experience] = [] {
        didSet {
            configureExperiencesStackView()
        }
    }

    var skills: [Skill] = [] {
        didSet {
            configureSkillsStackView()
        }
    }

    var cvs: [CVForm.CV] = [] {
        didSet {
            configureCVsStackView()
        }
    }
    
    var selectedCV: CVForm.CV?
    
    // MARK: - Methods
    func configureUserProfile() {
        // AuthManager.shared.currentUser?.userProfile can be used to save and display the data
        if let name = userName {
            profileUserName.text = name
        }
        
        if let role = userRole {
            profileUserRole.text = role
        }
        
        if let aboutUser = aboutUserDescription {
            profileDescription.text = aboutUser
        }
    }
    
    func configureExperiencesStackView() {
        // Clear previous stack view contents
        experiencesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if experiences.isEmpty {
            // Show NoItemsLabel when there are no experiences
            let noItemsLabelView = NoItemsLabel()
            noItemsLabelView.updateLabel(withText: "You don’t have any experiences yet, click on add to add an experience.")
            experiencesStackView.addArrangedSubview(noItemsLabelView)
        } else {
            // Add experience items
            for experience in experiences {
                let experienceItem = ExperienceItemView()
                experienceItem.configure(experience: experience)
                experiencesStackView.addArrangedSubview(experienceItem)
            }
        }
    }
    
    func configureSkillsStackView() {
        // Clear previous stack view contents
        skillsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if skills.isEmpty {
            let noItemsLabelView = NoItemsLabel()
            noItemsLabelView.updateLabel(withText: "You don’t have any skills yet, click on add to add a skill.")
            skillsStackView.addArrangedSubview(noItemsLabelView)
        } else {
            for skill in skills {
                let skillItem = SkillItemView()
                skillItem.updateLabel(withText: skill.name)
                skillsStackView.addArrangedSubview(skillItem)
            }
        }
    }
    
    func configureCVsStackView() {
        // Clear previous stack view contents
        cvsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if cvs.isEmpty {
            let noItemsLabelView = NoItemsLabel()
            noItemsLabelView.updateLabel(withText: "You don’t have any CVs yet, click on add to add a CV.")
            cvsStackView.addArrangedSubview(noItemsLabelView)
        } else {
            // Assuming this code is inside a UIViewController
            for cv in cvs {
                let cvItem = CVItemView()
                cvItem.configure(withCV: cv)
                cvsStackView.addArrangedSubview(cvItem)
                
                // Add a tap gesture recognizer to each CVItemView
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cvItemTapped(_:)))
                cvItem.addGestureRecognizer(tapGesture)
                cvItem.isUserInteractionEnabled = true // Ensure the view can respond to gestures
                
                if let index = cvs.firstIndex(where: { $0.uuid == cv.uuid }) {
                    cvItem.tag = index
                } else {
                    cvItem.tag = -1 // Fallback in case the CV isn't found, though this case is unlikely
                }
            }

        }
    }
    
    // Action method for the tap gesture
    @objc func cvItemTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view as? CVItemView else { return }
        
        // Retrieve the CV from the tag
        let index = tappedView.tag
        guard index >= 0 && index < cvs.count else { return }
        selectedCV = cvs[index]
        
        // Perform the segue
        performSegue(withIdentifier: "ShowCV", sender: self)
    }

    func saveUserProfile() {
        let workExperiences = experiences.map { experience in
            WorkExperience(
                jobTitle: experience.jobTitle,
                jobFiled: "",
                companyName: experience.companyName,
                startDate: experience.startDate,
                endDate: experience.endDate!,
                stillWorking: experience.isStillWorkingHere,
                mainJob: false,
                mainJobCompanyLogo: ""
            )
        }
        
        let skills = skills.map { $0.name }
        
        // mainJobCompanyLogo: gs://hirevolution.firebasestorage.app/youtube-logo-hd-8-1348870541.png
        // mainJobCompanyLogo: gs://hirevolution.firebasestorage.app/tesla-logo-black-2711845411.jpg
        // userProfileImage: gs://hirevolution.firebasestorage.app/c6f0b2c6cad28711d5209f7bb3cabddb-834927952.jpg
        
        let updatedUserProfile = UserProfile(
                backgroundPictuer: "",
                userProfileImage: "",
                userName: userName ?? "", userRole: "",
                userAbout: aboutUserDescription ?? "",
                userWorkExperience: workExperiences,  // Updated work experience
                userSkills: skills, // Updated skills
                cvs: cvs
        )

        guard let userID = authManager.userSession?.uid else {
            print("User ID is missing, handle the error appropriately")
            return
        }

        AuthManager.shared.updateUserProfile(userId: userID, updatedUserProfile: updatedUserProfile) { error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
            } else {
                print("Profile updated successfully.")
            }

            // fetching data to update
            self.authManager.fetchUserData(uid: self.authManager.currentUser!.id)
        }
    }

    func loadUserProfileData() {
        if let user = self.authManager.currentUser{
            let userProfile = user.userProfile
            userName = userProfile?.userName
            userRole = user.option
            aboutUserDescription = userProfile?.userAbout
            experiences = userProfile!.userWorkExperience.map {
                Experience(workExperience: $0)
            }
            skills = userProfile!.userSkills.map { Skill(skill: $0) }
            cvs = userProfile?.cvs ?? []
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserProfileData()
        
        configureUserProfile()
        // Initially configure the stack views
        configureExperiencesStackView()
        configureSkillsStackView()
        configureCVsStackView()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowExperienceVC",
           let destinationVC = segue.destination as? ExperienceViewController {
            destinationVC.onSaveExperience = { [weak self] experience in
                self?.experiences.append(experience)
                // UI will be updated by the didSet of experiences stored property
                self?.saveUserProfile()
            }
        } else if segue.identifier == "ShowSkillVC",
                  let destinationVC = segue.destination as? SkillViewController {
            destinationVC.onSaveSkill = { [weak self] skillTitle in
                self?.skills.append(Skill(name: skillTitle))
                // UI will be updated by the didSet of skills stored property
                self?.saveUserProfile()
            }
        } else if segue.identifier == "ShowEditProfileVC",
                  let destinationVC = segue.destination as? EditProfileViewController {
            destinationVC.onSaveProfile = { [weak self] userName, userRole, aboutUserDescription in
                self?.userName = userName
                self?.userRole = userRole
                self?.aboutUserDescription = aboutUserDescription
                self?.configureUserProfile()
                self?.saveUserProfile()
            }
        } else if segue.identifier == "ShowAddCVVC",
              let showCVViewController = segue.destination as? CVForm {
            showCVViewController.onSave = { [weak self] cvObject in
                self?.cvs.append(cvObject)
                self?.configureCVsStackView()
                self?.saveUserProfile()
            }
        } else if segue.identifier == "ShowCV",
           let detailVC = segue.destination as? CVShow {
           // Pass the CV object to the detail view controller
           detailVC.cv = selectedCV
        }
    }
}
