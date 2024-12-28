//
//  Testing Data.swift
//  Hirevolution
//
//  Created by Mac 14 on 20/11/2024.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct JobList: Codable {
    let jobID: String // Updated from previous field name
    let CompanyID: String
    var companyProfile: CompanyProfile // Associated company profile
    var jobTitle: String
    var jobDescription: String
    var jobNotes: String
    var jobPotentialSalary: String
    var jobType: String
    var jobSkills: [String]
    var jobFields: [String]
    var jobApplyedApplicationsCount: Int
    var jobApplicationsCanceledCount: Int
    var jobRejectedApplicaintsCount: Int
    var jobInterViewedApplicaintsCount: Int
    var jobScheduledForInterviewCount: Int
    var jobHiredUser: UserProfile? // Optional hired user details
    var jobViewsCount: Int
    let jobDatePublished: Date
    var ApplyedUsersApplications: [UserApplicationsStuff] = []
    var jobStatus: String
}

// Existing code continues below

struct CompanyProfile: Codable {
    var profilebackgroundPictuer: String
    var companyProfileLogo: String
    var companyName: String
    var companyDescription: String
    var yearOfEstablishment: String
    var numberOfEmployees: String
    var companyCEOName: String
    var companyNetworth: String
}

struct WorkExperience: Codable {
    var jobTitle: String
    var jobFiled: String
    var companyName: String
    var startDate: String
    var endDate: String
    var stillWorking: Bool
    var mainJob: Bool
    var mainJobCompanyLogo: String
}

struct UserProfile: Codable {
    var backgroundPictuer: String
    var userProfileImage: String
    var userName: String
    var userRole: String
    var userAbout: String
    var userWorkExperience: [WorkExperience]
    var userSkills: [String]
    var cvs: [CVForm.CV]?
}

struct UserApplicationsStuff: Codable {
    var applicantProfile: UserProfile
    var applicantUserID: String
    var applicantStatus: String
    var isCandidate: Bool
}

struct UserApplicationsList: Codable {
    var appliedJobIDLink: [String]
}

struct User: Identifiable, Codable {
    let id: String
    let fullName: String
    let eMail: String
    let password: String
    let option: String

    var companyProfile: CompanyProfile?
    var userProfile: UserProfile?
    var userApplicationsList: UserApplicationsList?
}

//mohamed woek
struct ScheduledInterview: Codable {
    var interviewDate: Date
    var userID: String
    var jobID: String
    
    // Initializer
    init(interviewDate: Date, userID: String, jobID: String) {
        self.interviewDate = interviewDate
        self.userID = userID
        self.jobID = jobID
    }
}


struct ScheduledInterviewWithJob {
    var interviewDate: Date
    var userID: String
    var jobID: String
    var job: JobList?  // This will store the associated job details
    
    // Initializer
    init(interviewDate: Date, userID: String, jobID: String, job: JobList? = nil) {
        self.interviewDate = interviewDate
        self.userID = userID
        self.jobID = jobID
        self.job = job
    }
}


struct ChatMessage {
    let userID: String
    let message: String
}


struct JobDataApplicantList {
    let jobID: String
    var companyName: String
    var jobTitle: String
    var applicantStatus: String
    var jobDescription: String
}

class AuthManager {
    static let shared = AuthManager()
    
    var userSession: FirebaseAuth.User? {
        return Auth.auth().currentUser
    }
    
    var currentUser: User?
    
    private init() {}
    
    //nitializes the AuthManager and loads any saved user session.
    func initialize() {
        loadSavedSession()
    }
    
    //Loads the saved user session from UserDefaults if available.
    func loadSavedSession() {
        if let savedUID = UserDefaults.standard.string(forKey: "userSessionUID") {
            fetchUserData(uid: savedUID)
        }
    }
    
    // Saves the user session UID to UserDefaults for later use.
    func saveUserSession(user: FirebaseAuth.User) {
        UserDefaults.standard.set(user.uid, forKey: "userSessionUID")
    }
    
    //Removes the user session from UserDefaults.
    func removeUserSession() {
        UserDefaults.standard.removeObject(forKey: "userSessionUID")
    }
    
    //Creates a new user with email, password, and other details, saves the user session, and stores user data in Firestore.
    func createUser(withEmail email: String, password: String, fullName: String, option: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let authResult = authResult else { return }
            let user = User(id: authResult.user.uid, fullName: fullName, eMail: email, password: password, option: option)
            self.saveUserSession(user: authResult.user)
            
            var userData: [String: Any] = [
                "id": user.id,
                "fullName": user.fullName,
                "eMail": user.eMail,
                "password": user.password,
                "option": user.option
            ]
            
            if option == "company" {
                let companyProfile = CompanyProfile(profilebackgroundPictuer: "", companyProfileLogo: "", companyName: "", companyDescription: "", yearOfEstablishment: "", numberOfEmployees: "", companyCEOName: "", companyNetworth: "")
                userData["companyProfile"] = try? Firestore.Encoder().encode(companyProfile)
            } else if option == "user" {
                let userProfile = UserProfile(backgroundPictuer: "", userProfileImage: "", userName: "", userRole: "", userAbout: "", userWorkExperience: [], userSkills: [])
                let userApplicationsList = UserApplicationsList(appliedJobIDLink: [])
                userData["userProfile"] = try? Firestore.Encoder().encode(userProfile)
                userData["userApplicationsList"] = try? Firestore.Encoder().encode(userApplicationsList)
            }
            
            Firestore.firestore().collection("users").document(user.id).setData(userData) { error in
                completion(error)
            }
            
            self.fetchUserData(uid: authResult.user.uid)
            
            
        }
    }
    
    // Registers a new user for Admin (without creating a session) and stores user data in Firestore.
    func AdminRegisterUser(withEmail email: String, password: String, fullName: String, option: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion(error)
                return
            }

            guard let authResult = authResult else {
                completion(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create user"]))
                return
            }

            let userId = authResult.user.uid
            var userData: [String: Any] = [
                "id": userId,
                "fullName": fullName,
                "eMail": email,
                "password": password,
                "option": option
            ]

            if option == "company" {
                let companyProfile = CompanyProfile(profilebackgroundPictuer: "", companyProfileLogo: "", companyName: "", companyDescription: "", yearOfEstablishment: "", numberOfEmployees: "", companyCEOName: "", companyNetworth: "")
                userData["companyProfile"] = try? Firestore.Encoder().encode(companyProfile)
            } else if option == "user" {
                let userProfile = UserProfile(backgroundPictuer: "", userProfileImage: "", userName: "", userRole: "", userAbout: "", userWorkExperience: [], userSkills: [])
                let userApplicationsList = UserApplicationsList(appliedJobIDLink: [])
                userData["userProfile"] = try? Firestore.Encoder().encode(userProfile)
                userData["userApplicationsList"] = try? Firestore.Encoder().encode(userApplicationsList)
            }

            Firestore.firestore().collection("users").document(userId).setData(userData) { error in
                if let error = error {
                    completion(error)
                    return
                }
            }
            completion(nil)
        }
    }
    
    //Signs in an existing user with email and password, saves the session, and fetches user data.
    func signInUser(withEmail email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let authResult = authResult else { return }
            self.saveUserSession(user: authResult.user)
            self.fetchUserData(uid: authResult.user.uid)
            completion(nil)
        }
    }
    
    //Signs out the current user, removes the session, and resets user-related data.
    func signOutUser() {
        try? Auth.auth().signOut()
        removeUserSession()
        currentUser = nil
        
        UserDefaults.standard.set(false, forKey: "SignInUser")
        UserDefaults.standard.set("user", forKey: "userType")
    }
    
    //Fetches user data from Firestore based on the user’s UID and decodes it into a User object.
    func fetchUserData(uid: String) {
        Firestore.firestore().collection("users").document(uid).getDocument { (document, error) in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists,
                  let data = document.data() else {
                print("No user data found")
                return
            }
            
            do {
                var user = try Firestore.Decoder().decode(User.self, from: data)
                
                if let companyProfileData = data["companyProfile"] as? [String: Any] {
                    user.companyProfile = try Firestore.Decoder().decode(CompanyProfile.self, from: companyProfileData)
                }
                
                if let userProfileData = data["userProfile"] as? [String: Any] {
                    user.userProfile = try Firestore.Decoder().decode(UserProfile.self, from: userProfileData)
                }
                
                if let userApplicationsData = data["userApplicationsList"] as? [String: Any] {
                    user.userApplicationsList = try Firestore.Decoder().decode(UserApplicationsList.self, from: userApplicationsData)
                }
                
                self.currentUser = user
                UserDefaults.standard.set(true, forKey: "SignInUser")
                
                if user.option == "company" {
                    UserDefaults.standard.set("company", forKey: "userType")
                    self.fetchCompanyJobs{ error in
                        if let error = error {
                            print("Error fetching jobs: \(error.localizedDescription)")
                        } else {
                            print("Company jobs fetched and saved successfully.")
                        }
                    }
                } else if user.option == "user"{
                    UserDefaults.standard.set("user", forKey: "userType")
                }else{                    
                    UserDefaults.standard.set("admin", forKey: "userType")
                }
            } catch {
                print("Error decoding user data: \(error)")
            }
        }
    }
    
    //Creates a new job in Firestore with given parameters.
    func createJob(
        jobTitle: String,
        jobDescription: String,
        jobNotes: String,
        jobPotentialSalary: String,
        jobType: String,
        jobSkills: [String],
        jobFields: [String],
        completion: @escaping (Error?) -> Void
    ) {
        guard let currentUser = AuthManager.shared.currentUser else {
            completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No current user logged in"]))
            return
        }
        
        // Create a new reference for the job document (Firestore will generate an ID automatically)
        let jobRef = Firestore.firestore().collection("jobs").document() // Firestore will auto-generate the document ID
        
        // Create a new job object
        let job = JobList(
            jobID: jobRef.documentID, // Set the jobID to the Firestore generated document ID
            CompanyID: currentUser.id,
            companyProfile: currentUser.companyProfile ?? CompanyProfile(profilebackgroundPictuer: "", companyProfileLogo: "", companyName: "", companyDescription: "", yearOfEstablishment: "", numberOfEmployees: "", companyCEOName: "", companyNetworth: ""),
            jobTitle: jobTitle,
            jobDescription: jobDescription,
            jobNotes: jobNotes,
            jobPotentialSalary: jobPotentialSalary,
            jobType: jobType,
            jobSkills: jobSkills,
            jobFields: jobFields,
            jobApplyedApplicationsCount: 0,
            jobApplicationsCanceledCount: 0,
            jobRejectedApplicaintsCount: 0,
            jobInterViewedApplicaintsCount: 0,
            jobScheduledForInterviewCount: 0,
            jobHiredUser: nil,
            jobViewsCount: 0,
            jobDatePublished: Date(),
            ApplyedUsersApplications: [],
            jobStatus: "On-going"
        )
        
        // Now save the job data to Firestore
        do {
            let jobData = try Firestore.Encoder().encode(job)
            jobRef.setData(jobData) { error in
                completion(error)
            }
        } catch {
            completion(error)
        }
    }
    
    // Fetches all jobs from Firestore and stores them in UserDefaults.
    func fetchAllJobs(completion: @escaping (Error?) -> Void) {
        // Fetch jobs from Firestore
        Firestore.firestore().collection("jobs").getDocuments { (snapshot, error) in
            if let error = error {
                completion(error)
                return
            }
            
            // Check if the snapshot contains documents
            guard let snapshot = snapshot else {
                completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No jobs found"]))
                return
            }
            
            var jobs: [JobList] = []
            
            // Decode the documents into JobList objects
            for document in snapshot.documents {
                do {
                    let job = try document.data(as: JobList.self)
                    print("see Hereeee: \(job)")
                    jobs.append(job)
                } catch {
                    print("Error decoding job data: \(error)")
                }
            }
            
            // Save fetched jobs to UserDefaults
            let encoder = JSONEncoder()
            do {
                let encodedJobs = try encoder.encode(jobs)
                UserDefaults.standard.set(encodedJobs, forKey: "AllJobsLists")
                print("Jobs successfully saved to UserDefaults.")
                completion(nil)
            } catch {
                print("Error encoding jobs to UserDefaults: \(error)")
                completion(error)
            }
            
            print("Fetched jobs: \(jobs)")
            completion(nil)
        }
    }
    
    // Loads all jobs from UserDefaults into an array of JobList objects.
    func loadAllJobsFromUserDefaults() -> [JobList]? {
        // Retrieve the Data from UserDefaults
        if let savedJobsData = UserDefaults.standard.data(forKey: "AllJobsLists") {
            print("Retrieved jobs data: \(savedJobsData)") // For debugging
            
            // Decode the Data into an array of JobList objects
            let decoder = JSONDecoder()
            do {
                let decodedJobs = try decoder.decode([JobList].self, from: savedJobsData)
                print("Successfully decoded jobs from UserDefaults.")
                return decodedJobs
            } catch {
                print("Error decoding jobs from UserDefaults: \(error)")
                return nil
            }
        } else {
            print("No jobs data found in UserDefaults.")
            return nil
        }
    }

    //Fetches jobs for a specific company from Firestore based on the current user's CompanyID.
    func fetchCompanyJobs(completion: @escaping (Error?) -> Void) {
        guard let currentUser = AuthManager.shared.currentUser else {
            completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No current user logged in"]))
            return
        }
        
        let companyID = currentUser.id
        
        // Firestore reference to the 'jobs' collection
        let jobsRef = Firestore.firestore().collection("jobs")
        
        // Query for jobs where the CompanyID matches the current user's uid
        jobsRef.whereField("CompanyID", isEqualTo: companyID).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(error)
                return
            }
            
            // Check if there are any documents retrieved
            guard let querySnapshot = querySnapshot, !querySnapshot.isEmpty else {
                completion(nil)
                print("No jobs found for this company.")
                return
            }
            
            // Array to hold the fetched jobs
            var fetchedJobs: [JobList] = []
            
            // Loop through the documents and decode each job
            for document in querySnapshot.documents {
                do {
                    // Decode the job data into the JobList model
                    let job = try document.data(as: JobList.self)
                    fetchedJobs.append(job)
                } catch {
                    print("Error decoding job data: \(error)")
                }
            }
            
            // Save fetched jobs to UserDefaults
            let encoder = JSONEncoder()
            do {
                let encodedJobs = try encoder.encode(fetchedJobs)
                UserDefaults.standard.set(encodedJobs, forKey: "ApplicationJobsList")
                print("Jobs successfully saved to UserDefaults.")
                completion(nil)
            } catch {
                print("Error encoding jobs to UserDefaults: \(error)")
                completion(error)
            }
        }
    }

    //Loads the jobs for a specific company from UserDefaults.
    func loadCompanyJobsFromUserDefaults() -> [JobList]? {
        // Retrieve the Data from UserDefaults
        if let savedJobsData = UserDefaults.standard.data(forKey: "ApplicationJobsList") {
            print("Retrieved jobs data: \(savedJobsData)") // For debugging
            
            // Decode the Data into an array of JobList objects
            let decoder = JSONDecoder()
            do {
                let decodedJobs = try decoder.decode([JobList].self, from: savedJobsData)
                print("Successfully decoded jobs from UserDefaults.")
                return decodedJobs
            } catch {
                print("Error decoding jobs from UserDefaults: \(error)")
                return nil
            }
        } else {
            print("No jobs data found in UserDefaults.")
            return nil
        }
    }

    //Updates a job's data in Firestore based on the provided updatedJob object.
    func updateJobInDatabase(jobList: JobList, completion: @escaping (Error?) -> Void) {
        // Get a reference to Firestore
        let db = Firestore.firestore()
        
        // Reference to the document for the job based on jobID
        let jobRef = db.collection("jobs").document(jobList.jobID)

        // Create a dictionary with the fields to update
        var updateData: [String: Any] = [
            "jobTitle": jobList.jobTitle,
            "jobDescription": jobList.jobDescription,
            "jobNotes": jobList.jobNotes,
            "jobPotentialSalary": jobList.jobPotentialSalary,
            "jobType": jobList.jobType,
            "jobSkills": jobList.jobSkills,
            "jobFields": jobList.jobFields
        ]
        
        // Perform the update
        jobRef.updateData(updateData) { error in
            if let error = error {
                // If there was an error updating the data, call the completion with the error
                completion(error)
            } else {
                // If the update is successful, call the completion with no error
                completion(nil)
            }
        }
    }

    //increments the view count for a specific job in Firestore.
    func incrementJobViewsCount(jobID: String, completion: @escaping (Error?) -> Void) {
        // Firestore reference to the 'jobs' collection and the document with the given jobID
        let jobRef = Firestore.firestore().collection("jobs").document(jobID)
        
        // First, check if the document exists
        jobRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error)")
                completion(error)
                return
            }
            
            // If the document exists, increment the view count
            if document?.exists == true {
                // Increment the jobViewsCount field by 1
                jobRef.updateData([
                    "jobViewsCount": FieldValue.increment(Int64(1))  // Increment by 1
                ]) { error in
                    if let error = error {
                        print("Error incrementing job views: \(error)")
                        completion(error)
                    } else {
                        print("Job views count successfully incremented.")
                        completion(nil)
                    }
                }
            } else {
                // If the document does not exist, create it with an initial view count of 1
                jobRef.setData([
                    "jobViewsCount": 1
                ]) { error in
                    if let error = error {
                        print("Error creating document: \(error)")
                        completion(error)
                    } else {
                        print("Job document created with initial view count.")
                        completion(nil)
                    }
                }
            }
        }
    }
    
    //Updates a user's profile in Firestore with the given updatedUserProfile.
    func updateUserProfile(userId: String, updatedUserProfile: UserProfile, completion: @escaping (Error?) -> Void) {
        // Firestore reference to the 'users' collection
        let userRef = Firestore.firestore().collection("users").document(userId)
        
        // Prepare the data to update
        var userData: [String: Any] = [:]
        
        // Update the userProfile field
        do {
            // Encode the updated user profile
            let encodedUserProfile = try Firestore.Encoder().encode(updatedUserProfile)
            userData["userProfile"] = encodedUserProfile
        } catch {
            completion(error)
            return
        }
        
        // Perform the update operation in Firestore
        userRef.updateData(userData) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    // Updates a company's profile in Firestore with the given updatedCompanyProfile.
    func updateCompanyProfile(companyId: String, updatedCompanyProfile: CompanyProfile, completion: @escaping (Error?) -> Void) {
        // Firestore reference to the 'companies' collection
        let companyRef = Firestore.firestore().collection("users").document(companyId)
        
        // Prepare the data to update
        var companyData: [String: Any] = [:]
        
        // Update the companyProfile field
        do {
            // Encode the updated company profile
            let encodedCompanyProfile = try Firestore.Encoder().encode(updatedCompanyProfile)
            companyData["companyProfile"] = encodedCompanyProfile
        } catch {
            completion(error)
            return
        }
        
        // Perform the update operation in Firestore
        companyRef.updateData(companyData) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    //Allows a user to apply for a job, updating both the job and user data in Firestore.
    func applyForJob(userID: String, userProfile: UserProfile, jobID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let jobRef = db.collection("jobs").document(jobID)
        let userRef = db.collection("users").document(userID)  // Reference to the user document

        // Create a userApplicationStuff struct
        let userApplication = UserApplicationsStuff(applicantProfile: userProfile, applicantUserID: userID, applicantStatus: "On-going", isCandidate: false)

        // Fetch the job document
        jobRef.getDocument { documentSnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let document = documentSnapshot, document.exists,
                  let jobData = document.data() else {
                completion(.failure(NSError(domain: "JobError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Job not found"])))
                return
            }

            // Update appliedUserApplications and increment count
            var appliedUserApplications = jobData["ApplyedUsersApplications"] as? [[String: Any]] ?? []

            do {
                // Encode the user application
                let userApplicationDict = try Firestore.Encoder().encode(userApplication) as [String: Any]
                appliedUserApplications.append(userApplicationDict)
            } catch {
                completion(.failure(error))
                return
            }

            let currentCount = jobData["jobApplyedApplicationsCount"] as? Int ?? 0
            let updatedCount = currentCount + 1

            // Update job document
            jobRef.updateData([
                "ApplyedUsersApplications": appliedUserApplications,
                "jobApplyedApplicationsCount": updatedCount
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                // Now update the user document with the job ID
                userRef.getDocument { documentSnapshot, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }

                    guard let document = documentSnapshot, document.exists,
                          let userData = document.data() else {
                        completion(.failure(NSError(domain: "UserError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                        return
                    }

                    // Access the userApplicationsList and update appliedJobIDLink
                    var userApplicationsList = userData["userApplicationsList"] as? [String: Any] ?? [:]

                    // Get the appliedJobIDLink from the userApplicationsList
                    var appliedJobIDLink = userApplicationsList["appliedJobIDLink"] as? [String] ?? []

                    // Append the jobID to appliedJobIDLink
                    appliedJobIDLink.append(jobID)

                    // Update userApplicationsList
                    userApplicationsList["appliedJobIDLink"] = appliedJobIDLink

                    // Update the user document with the new userApplicationsList
                    userRef.updateData(["userApplicationsList": userApplicationsList]) { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(()))
                        }
                    }
                }
            }
        }
    }
    
    //This function updates the "isCandidate" status for an applicant in the job's application list.
    func updateCandidateStatus(jobID: String, isCandidate: Bool, applicantID: String, completion: @escaping (Error?) -> Void) {
        // Firestore reference to the 'jobs' collection
        let jobRef = Firestore.firestore().collection("jobs").document(jobID)
        
        // Fetch the job document
        jobRef.getDocument { document, error in
            if let error = error {
                print("Error fetching job document: \(error)")
                completion(error)
                return
            }
            
            // Check if the document exists
            guard let document = document, document.exists else {
                print("Job document does not exist")
                completion(NSError(domain: "JobNotFound", code: 404, userInfo: nil))
                return
            }
            
            // Retrieve the current applications array
            if var jobData = document.data(), var applications = jobData["ApplyedUsersApplications"] as? [[String: Any]] {
                // Find the application by applicantID
                for (index, application) in applications.enumerated() {
                    if let applicantUserID = application["applicantUserID"] as? String, applicantUserID == applicantID {
                        // Update the 'isCandidate' field
                        applications[index]["isCandidate"] = isCandidate
                        
                        // Prepare the updated job data
                        jobData["ApplyedUsersApplications"] = applications
                        
                        // Update the job document in Firestore
                        jobRef.updateData(jobData) { error in
                            if let error = error {
                                print("Error updating job in Firestore: \(error)")
                                completion(error)
                            } else {
                                print("Successfully updated isCandidate status for applicant.")
                                completion(nil)
                            }
                        }
                        return
                    }
                }
                
                // If applicantID is not found
                print("Applicant with ID \(applicantID) not found in the applications list.")
                completion(NSError(domain: "ApplicantNotFound", code: 404, userInfo: nil))
            } else {
                print("Failed to fetch or parse ApplyedUsersApplications")
                completion(NSError(domain: "DataError", code: 500, userInfo: nil))
            }
        }
    }
    
    //This function updates the applicant's status to "Rejected" and increments the count of rejected applicants in the job document.
    func rejectApplicantStatus(jobID: String, applicantID: String, completion: @escaping (Error?) -> Void) {
        // Firestore reference to the 'jobs' collection
        let jobRef = Firestore.firestore().collection("jobs").document(jobID)
        
        // Fetch the job document
        jobRef.getDocument { document, error in
            if let error = error {
                print("Error fetching job document: \(error)")
                completion(error)
                return
            }
            
            // Check if the document exists
            guard let document = document, document.exists else {
                print("Job document does not exist")
                completion(NSError(domain: "JobNotFound", code: 404, userInfo: nil))
                return
            }
            
            // Retrieve the current applications array and rejected count
            if var jobData = document.data(), var applications = jobData["ApplyedUsersApplications"] as? [[String: Any]] {
                var rejectedCount = jobData["jobRejectedApplicaintsCount"] as? Int ?? 0
                
                // Find the application by applicantID
                for (index, application) in applications.enumerated() {
                    if let applicantUserID = application["applicantUserID"] as? String, applicantUserID == applicantID {
                        // Update the status to "Rejected"
                        applications[index]["applicantStatus"] = "Rejected"
                        
                        // Increment the rejected count
                        rejectedCount += 1
                        
                        // Prepare the updated job data
                        jobData["ApplyedUsersApplications"] = applications
                        jobData["jobRejectedApplicaintsCount"] = rejectedCount
                        
                        // Update the job document in Firestore
                        jobRef.updateData(jobData) { error in
                            if let error = error {
                                print("Error updating job in Firestore: \(error)")
                                completion(error)
                            } else {
                                print("Successfully updated status to Rejected and incremented the rejected count.")
                                completion(nil)
                            }
                        }
                        return
                    }
                }
                
                // If applicantID is not found
                print("Applicant with ID \(applicantID) not found in the applications list.")
                completion(NSError(domain: "ApplicantNotFound", code: 404, userInfo: nil))
            } else {
                print("Failed to fetch or parse ApplyedUsersApplications")
                completion(NSError(domain: "DataError", code: 500, userInfo: nil))
            }
        }
    }
    
    // General image loading function for any image reference
        func loadImage(from imageName: String, into imageView: UIImageView) {
            let storage = Storage.storage()
            let storageRef = storage.reference(forURL: "gs://hirevolution.firebasestorage.app")
            let imageRef = storageRef.child(imageName.replacingOccurrences(of: "gs://hirevolution.firebasestorage.app/", with: ""))

            imageRef.getData(maxSize: 3 * 1024 * 1024) { data, error in
                if let error = error {
                    print("Error downloading image data: \(error)")
                    imageView.image = UIImage(systemName: "person.fill") // Set to default system image if error
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                } else {
                    print("Invalid image data")
                    imageView.image = UIImage(systemName: "person.fill") // Set to default system image if invalid data
                }
            }
        }
        
        
        func fetchLibrary(completion: @escaping ([[String: Any]]) -> Void) {
            let db = Firestore.firestore()
            let libraryRef = db.collection("library")

            // Use addSnapshotListener for real-time updates
            libraryRef.addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion([])  // Return an empty array if there's an error
                    return
                }

                // Map the documents to an array of dictionaries
                let libraryData = querySnapshot?.documents.map { $0.data() } ?? []
                completion(libraryData)  // Return the library data
            }
            
            
        }
    
    //This function updates the applicant's status to "Hired" and adds the applicant's profile to the job's hired user information.
    func hireApplicant(jobID: String, applicantID: String, completion: @escaping (Error?) -> Void) {
        // Firestore reference to the 'jobs' collection
        let jobRef = Firestore.firestore().collection("jobs").document(jobID)
        
        // Fetch the job document
        jobRef.getDocument { document, error in
            if let error = error {
                print("Error fetching job document: \(error)")
                completion(error)
                return
            }
            
            // Check if the document exists
            guard let document = document, document.exists else {
                print("Job document does not exist")
                completion(NSError(domain: "JobNotFound", code: 404, userInfo: nil))
                return
            }
            
            // Retrieve the current applications array
            if var jobData = document.data(), var applications = jobData["ApplyedUsersApplications"] as? [[String: Any]] {
                
                // Find the application by applicantID
                for (index, application) in applications.enumerated() {
                    if let applicantUserID = application["applicantUserID"] as? String, applicantUserID == applicantID {
                        // Update the applicant's status to "Hired"
                        applications[index]["applicantStatus"] = "Hired"
                        
                        // Extract the applicant's profile
                        if let applicantProfile = application["applicantProfile"] as? [String: Any] {
                            // Add the applicant's profile to the job's hired user
                            jobData["jobHiredUser"] = applicantProfile
                        }
                        
                        // Prepare the updated job data
                        jobData["ApplyedUsersApplications"] = applications
                        
                        // Update the job document in Firestore
                        jobRef.updateData(jobData) { error in
                            if let error = error {
                                print("Error updating job in Firestore: \(error)")
                                completion(error)
                            } else {
                                print("Successfully hired the applicant and updated job.")
                                completion(nil)
                            }
                        }
                        return
                    }
                }
                
                // If applicantID is not found
                print("Applicant with ID \(applicantID) not found in the applications list.")
                completion(NSError(domain: "ApplicantNotFound", code: 404, userInfo: nil))
            } else {
                print("Failed to fetch or parse ApplyedUsersApplications")
                completion(NSError(domain: "DataError", code: 500, userInfo: nil))
            }
        }
    }
    
    ////////////////////////////////////////////////////////EEEEEEEE
    // Function to fetch user data and job applications
    func getUserDataAndJobApplications(completion: @escaping ([JobDataApplicantList]?) -> Void) {
        // Get the current user's UID
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User is not authenticated")
            completion(nil)
            return
        }
        
        // Reference to the Firestore database
        let db = Firestore.firestore()
        
        // Reference to the users collection
        let usersRef = db.collection("users")
        
        // Query for the current user's document
        usersRef.document(userId).getDocument { (document, error) in
            if let error = error {
                print("Error getting document: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Check if the document exists
            guard let document = document, document.exists else {
                print("No document found for user ID: \(userId)")
                completion(nil)
                return
            }
            
            // Accessing the userApplicationsList and appliedJobIDLink array
            var appliedJobIDs: [String] = [] // This will hold all job IDs
            if let userApplicationsList = document.get("userApplicationsList") as? [String: Any] {
                for (key, value) in userApplicationsList {
                    // Check if the map contains appliedJobIDLink field (array)
                    if let appliedJobIDLinks = value as? [String] {
                        print("User Applications for key \(key): \(appliedJobIDLinks)")
                        // Add all job IDs from appliedJobIDLinks to the appliedJobIDs array
                        appliedJobIDs.append(contentsOf: appliedJobIDLinks)
                    } else {
                        print("No appliedJobIDLink array found for key \(key)")
                    }
                }
            } else {
                print("userApplicationsList map not found")
            }
            
            // Now call the function to search jobs with the array of job IDs
            if !appliedJobIDs.isEmpty {
                self.searchJobsForUser(jobIDs: appliedJobIDs, userId: userId, completion: completion)
            } else {
                print("No applied job IDs found")
                completion(nil)
            }
        }
    }
    
    
    func searchJobsForUser(jobIDs: [String], userId: String, completion: @escaping ([JobDataApplicantList]?) -> Void) {
        let db = Firestore.firestore()
        let jobsRef = db.collection("jobs")
        
        var jobDataList: [JobDataApplicantList] = []
        let dispatchGroup = DispatchGroup()
        
        // Loop through each job ID
        for jobID in jobIDs {
            dispatchGroup.enter()
            
            jobsRef.document(jobID).getDocument { (document, error) in
                if let error = error {
                    print("Error getting job document: \(error.localizedDescription)")
                    dispatchGroup.leave()
                    return
                }
                
                // Check if the document exists
                guard let document = document, document.exists else {
                    print("No job found with jobID: \(jobID)")
                    dispatchGroup.leave()
                    return
                }
                
                // Access the ApplyedUsersApplications array
                if let appliedUsersApplications = document.get("ApplyedUsersApplications") as? [[String: Any]] {
                    for application in appliedUsersApplications {
                        if let applicantUserID = application["applicantUserID"] as? String, applicantUserID == userId {
                            // Extract the applicantStatus for this application
                            if let applicantStatus = application["applicantStatus"] as? String {
                                // Extract companyName and jobTitle
                                if let companyProfile = document.get("companyProfile") as? [String: Any],
                                   let companyName = companyProfile["companyName"] as? String,
                                   let jobTitle = document.get("jobTitle") as? String,
                                   let jobID = document.get("jobID") as? String,
                                   let jobDescription = document.get("jobDescription") as? String {
                                    // Create JobDataApplicantList object and append it
                                    let jobData = JobDataApplicantList(jobID: jobID, companyName: companyName,
                                                                       jobTitle: jobTitle,
                                                                       applicantStatus: applicantStatus,
                                                                       jobDescription: jobDescription)
                                    jobDataList.append(jobData)
                                }
                            }
                        }
                    }
                }
                dispatchGroup.leave()
            }
        }
        
        // Once all job documents are processed, return the data
        dispatchGroup.notify(queue: .main) {
            completion(jobDataList)
        }
    }
    // Function to cancel the job application status
    func cancelJobApplicationStatus(jobData: JobDataApplicantList, completion: @escaping (JobDataApplicantList?, Bool) -> Void) {
        let db = Firestore.firestore()
        let jobsRef = db.collection("jobs")
        let jobDocumentRef = jobsRef.document(jobData.jobID)  // Use jobID to find the job document
        
        // Get the current user's ID from Firebase Authentication
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No user is logged in.")
            completion(nil, false)
            return
        }
        
        // Print the job ID and applicant status to ensure they are correct
        print("Attempting to update job: \(jobData.jobTitle), Job ID: \(jobData.jobID), Current Status: \(jobData.applicantStatus), Current User ID: \(currentUserID)")
        
        jobDocumentRef.getDocument { document, error in
            if let error = error {
                print("Error getting document: \(error.localizedDescription)")
                completion(nil, false)
                return
            }
            
            guard let document = document, document.exists else {
                print("Job document not found.")
                completion(nil, false)
                return
            }
            
            // Retrieve and update the 'ApplyedUsersApplications' field
            if var appliedUsersApplications = document.get("ApplyedUsersApplications") as? [[String: Any]] {
                // Find the application that matches the current user ID
                if let index = appliedUsersApplications.firstIndex(where: {
                    ($0["applicantUserID"] as? String) == currentUserID }) {
                    // Update the applicant's status to "Cancelled"
                    appliedUsersApplications[index]["applicantStatus"] = "Cancelled"
                    
                    // Update Firestore
                    jobDocumentRef.updateData(["ApplyedUsersApplications": appliedUsersApplications]) { error in
                        if let error = error {
                            print("Error updating document: \(error.localizedDescription)")
                            completion(nil, false)
                        } else {
                            // Return the updated job data
                            var updatedJobData = jobData
                            updatedJobData.applicantStatus = "Cancelled"
                            completion(updatedJobData, true)
                        }
                    }
                } else {
                    print("Application not found for current user.")
                    completion(nil, false)
                }
            } else {
                print("No 'ApplyedUsersApplications' field found in the document.")
                completion(nil, false)
            }
        }
    }
    
    func fetchUsers(completion: @escaping ([[String: Any]]) -> Void) {
        let db = Firestore.firestore()
        let usersRef = db.collection("users")

        // Use addSnapshotListener for real-time updates
        usersRef.whereField("option", isEqualTo: "user").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion([])  // Return an empty array if there's an error
                return
            }

            // Map the documents to an array of dictionaries
            let users = querySnapshot?.documents.map { $0.data() } ?? []
            completion(users)  // Return the users data
        }
    }
    
    func fetchCompanies(completion: @escaping ([[String: Any]]) -> Void) {
        let db = Firestore.firestore()
        let companiesRef = db.collection("users") // Assuming your collection is "companies"

        // Adding snapshot listener for real-time updates
        companiesRef.whereField("option", isEqualTo: "company")
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion([]) // Return empty array in case of error
                    return
                }

                // If data is retrieved successfully, map the documents to your desired format
                let companies = querySnapshot!.documents.map { $0.data() }
                
                // Pass the fetched companies to the completion handler
                completion(companies)
            }
    }


        func fetchJobs(completion: @escaping ([[String: Any]]) -> Void) {
            let db = Firestore.firestore()
            let jobsRef = db.collection("jobs")

            jobsRef.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion([])
                    return
                }

                let jobs = querySnapshot!.documents.map { $0.data() }
                completion(jobs)
            }
        }
    
    

    func deleteUser(withID userID: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(userID).delete { error in
            if let error = error {
                print("Error deleting user: \(error)")
                completion(false)
            } else {
                print("User deleted successfully")
                completion(true)
            }
        }
    }
    
    func deleteCompany(withID companyID: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(companyID).delete { error in // Use "users" collection
            if let error = error {
                print("Error deleting company: \(error)")
                completion(false)
            } else {
                print("Company deleted successfully")
                completion(true)
            }
        }
    }
    
    func deleteJob(withID jobID: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("jobs").document(jobID).delete { error in // Assuming "jobs" is your collection
            if let error = error {
                print("Error deleting job: \(error)")
                completion(false)
            } else {
                print("Job deleted successfully")
                completion(true)
            }
        }
    }

    
    func updateUserData(userData: [String: Any], fullName: String, email: String, userName: String, userAbout: String, profileImageSelected: Bool, backgroundImageSelected: Bool, profileImage: UIImage?, backgroundImage: UIImage?, completion: @escaping (Bool, String) -> Void) {
        
        guard let userId = userData["id"] as? String else {
            completion(false, "User ID not found.")
            return
        }
        
        let db = Firestore.firestore()  // Firestore instance inside the method
        let userRef = db.collection("users").document(userId)
        
        // Create a dictionary of updated data
        var updatedData: [String: Any] = [
            "fullName": fullName,
            "eMail": email,
            "userProfile.userName": userName,
            "userProfile.userAbout": userAbout
        ]
        
        // Use dispatch group to wait for both image uploads to complete before updating Firestore
        let dispatchGroup = DispatchGroup()
        
        var profileImageName: String?
        var backgroundImageName: String?
        var profileImageUrl: String?
        var backgroundImageUrl: String?
        
        // If profile image is selected, upload the new image and update Firestore
        if profileImageSelected, let profileImage = profileImage {
            dispatchGroup.enter()  // Enter dispatch group
            profileImageName = userId + "-profile"  // Use id as the image name
            profileImageUrl = "gs://hirevolution.firebasestorage.app" + profileImageName!
            // Check if the old image exists and delete it before uploading the new one
            deleteImageIfExists(imageName: profileImageName!) {
                self.uploadImageToStorage(image: profileImage, imageName: profileImageName!) { imageUrl in
                    if imageUrl != nil {
                        // Return the image name instead of URL
                        updatedData["userProfile.userProfileImage"] = profileImageUrl
                    }
                    dispatchGroup.leave()  // Leave dispatch group
                }
            }
        }
        
        // If background image is selected, upload the new image and update Firestore
        if backgroundImageSelected, let backgroundImage = backgroundImage {
            dispatchGroup.enter()  // Enter dispatch group
            backgroundImageName = userId + "-background"  // Use id as the image name
            backgroundImageUrl = "gs://hirevolution.firebasestorage.app" + backgroundImageName!
            // Check if the old image exists and delete it before uploading the new one
            deleteImageIfExists(imageName: backgroundImageName!) {
                self.uploadImageToStorage(image: backgroundImage, imageName: backgroundImageName!) { imageUrl in
                    if imageUrl != nil {
                        // Return the image name instead of URL
                        updatedData["userProfile.backgroundPictuer"] = backgroundImageUrl
                    }
                    dispatchGroup.leave()  // Leave dispatch group
                }
            }
        }
        
        // After both image uploads are completed (or skipped), update Firestore
        dispatchGroup.notify(queue: .main) {
            // Perform Firestore update
            userRef.updateData(updatedData) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                    completion(false, "Failed to update user data.")
                } else {
                    completion(true, "User data updated successfully.")
                }
            }
        }
    }

    
    
    func updateCompanyData(companyData: [String: Any], companyId: String, companyName: String, companyDescription: String, yearOfEstablishment: String, numberOfEmployees: String, companyCEOName: String, companyNetworth: String, logoImageSelected: Bool, backgroundImageSelected: Bool, logoImage: UIImage?, backgroundImage: UIImage?, completion: @escaping (Bool, String) -> Void) {
            
        // Validate company ID and original data
        guard let companyId = companyData["id"] as? String else {
            completion(false, "Company ID not found.")
            return
        }
        
        let db = Firestore.firestore()  // Firestore instance
        let companyRef = db.collection("users").document(companyId)
        
        // Create a dictionary of updated company data
        var updatedCompanyData: [String: Any] = [
            "companyProfile.companyName": companyName,
            "companyProfile.companyDescription": companyDescription,
            "companyProfile.yearOfEstablishment": yearOfEstablishment,
            "companyProfile.numberOfEmployees": numberOfEmployees,
            "companyProfile.companyCEOName": companyCEOName,
            "companyProfile.companyNetworth": companyNetworth
        ]
        
        // Dispatch group to handle image uploads asynchronously
        let dispatchGroup = DispatchGroup()
        
        var companyLogoName: String?
        var companyBackgroundImageName: String?
        var companyLogoUrl: String?
        var companyBackgroundUrl: String?
        
        // If company logo is selected, upload the new logo image
        if logoImageSelected, let logoImage = logoImage {
            dispatchGroup.enter()  // Enter the dispatch group
            companyLogoName = companyId + "-logo"  // Generate logo image name
            companyLogoUrl = "gs://hirevolution.firebasestorage.app" + companyLogoName!
            // Delete existing logo if it exists and upload the new logo image
            deleteImageIfExists(imageName: companyLogoName!) {
                self.uploadImageToStorage(image: logoImage, imageName: companyLogoName!) { imageUrl in
                    if let _ = imageUrl {
                        updatedCompanyData["companyProfile.companyProfileLogo"] = companyLogoUrl
                    }
                    dispatchGroup.leave()  // Leave the dispatch group after upload
                }
            }
        }
        
        // If background image is selected, upload the new background image
        if backgroundImageSelected, let backgroundImage = backgroundImage {
            dispatchGroup.enter()  // Enter the dispatch group
            companyBackgroundImageName = companyId + "-background"  // Generate background image name
            companyBackgroundUrl = "gs://hirevolution.firebasestorage.app" + companyBackgroundImageName!
            // Delete existing background image if it exists and upload the new background image
            deleteImageIfExists(imageName: companyBackgroundImageName!) {
                self.uploadImageToStorage(image: backgroundImage, imageName: companyBackgroundImageName!) { imageUrl in
                    if let _ = imageUrl {
                        updatedCompanyData["companyProfile.profilebackgroundPictuer"] = companyBackgroundUrl
                    }
                    dispatchGroup.leave()  // Leave the dispatch group after upload
                }
            }
        }
        
        // After all image uploads are completed (or skipped), update Firestore
        dispatchGroup.notify(queue: .main) {
            companyRef.updateData(updatedCompanyData) { error in
                if let error = error {
                    print("Error updating company data: \(error.localizedDescription)")
                    completion(false, "Failed to update company data.")
                } else {
                    completion(true, "Company data updated successfully.")
                }
            }
        }
    }
    // Helper method to delete an image if it already exists in Firebase Storage
    func deleteImageIfExists(imageName: String, completion: @escaping () -> Void) {
        let storageRef = Storage.storage().reference().child(imageName)
        
        // Check if the image already exists in Firebase Storage
        storageRef.getMetadata { metadata, error in
            if let error = error {
                // If image does not exist, continue with the upload
                print("Image does not exist, proceeding with upload. Error: \(error.localizedDescription)")
                completion()
                return
            }
            
            // If metadata exists, it means the image exists, so we delete it
            storageRef.delete { error in
                if let error = error {
                    print("Failed to delete old image: \(error.localizedDescription)")
                } else {
                    print("Old image deleted successfully.")
                }
                completion()  // Continue with the upload
            }
        }
    }

    // Helper method to upload an image to Firebase Storage
    func uploadImageToStorage(image: UIImage, imageName: String, completion: @escaping (String?) -> Void) {
        let storageRef = Storage.storage().reference().child(imageName)
        
        // Convert image to data
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            storageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                // Get the download URL
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                        completion(nil)
                        return
                    }
                    
                    if let downloadURL = url {
                        completion(downloadURL.absoluteString)  // Return the image URL
                    }
                }
            }
        } else {
            print("Error converting image to data.")
            completion(nil)
        }
    }
  
    // This function gets the next available resourceID from the resources array in Firestore
    func getNextResourceID(documentID: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()

        db.collection("library").document(documentID).getDocument { document, error in
            if let error = error {
                print("Error getting document: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let document = document, document.exists else {
                print("Document does not exist.")
                completion(nil)
                return
            }
            
            // Extract the resources array from the document
            if let resources = document.data()?["resources"] as? [[String: Any]] {
                // Find the highest resourceID from the resources array, convert it to an integer
                let maxResourceID = resources.compactMap { resource in
                    if let resourceID = resource["resourceID"] as? String,
                       let intResourceID = Int(resourceID) {
                        return intResourceID
                    }
                    return nil
                }.max() ?? 0  // Default to 0 if no resourceID found
                
                // The next resourceID will be the max + 1
                let nextResourceID = maxResourceID + 1
                completion("\(nextResourceID)") // Return next resourceID as a string
            } else {
                print("No resources array found.")
                completion("1") // Start with "1" if no resources exist
            }
        }
    }


    
    // Function to add a new resource to the Firestore document
    func addNewResourceToLibrary(LibraryID: String, resourceTitle: String, resourceImage: UIImage, sectionHeaders: [String], sectionContents: [String], imageName: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()

        // Step 1: Get the next resource ID
        getNextResourceID(documentID: LibraryID) { nextResourceID in
            guard let nextResourceID = nextResourceID else {
                print("Failed to get next resource ID.")
                completion(false)
                return
            }

            // Step 3: Upload the image to Firebase Storage
            self.uploadImageToStorage(image: resourceImage, imageName: imageName) { imageURL in
                guard imageURL != nil else {
                    print("Failed to upload image.")
                    completion(false)
                    return
                }

                // Construct the image URL in the required format
                let formattedImageURL = "gs://hirevolution.firebasestorage.app/\(imageName)"

                // Step 4: Prepare the article array (section headers and contents)
                var articles: [[String: Any]] = []
                for (index, header) in sectionHeaders.enumerated() {
                    // Check if sectionContents has a valid value for this index
                    let content = (index < sectionContents.count) ? sectionContents[index] : ""
                    
                    // Use the index to create a string for articleID (e.g., "1", "2", "3", etc.)
                    let articleIDString = String(index + 1)  // Convert to string
                    
                    let article: [String: Any] = [
                        "articleID": articleIDString,  // Article ID as a string
                        "header": header,              // Section header
                        "content": content             // Section content
                    ]
                    articles.append(article)  // Append the article map to the array
                }

                // Step 5: Create the resource data
                let resourceData: [String: Any] = [
                    "resourceID": nextResourceID,
                    "resourceTitle": resourceTitle,
                    "resourceDate": self.getCurrentDate(), // You should implement this function to return the current date
                    "resourceImage": formattedImageURL, // Use the formatted image URL
                    "article": articles
                ]

                // Step 6: Update Firestore document
                db.collection("library").document(LibraryID).updateData([
                    "resources": FieldValue.arrayUnion([resourceData])
                ]) { error in
                    if let error = error {
                        print("Error updating document: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Resource added successfully.")
                        completion(true)
                    }
                }
            }
        }
    }

    // Function to delete a resource from the library document
    func deleteResource(libraryID: String, resourceID: String, completion: @escaping (Bool, String?) -> Void) {
        let db = Firestore.firestore()
        let libraryRef = db.collection("library").document(libraryID)
        
        // Fetch the library document to update the resources array
        libraryRef.getDocument { (document, error) in
            if let error = error {
                print("Error getting document: \(error)")
                completion(false, "Error getting document: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                // Fetch the resources array from the document
                var resourcesArray = document.data()?["resources"] as? [[String: Any]] ?? []
                
                // Find the index of the resource with the passed resourceID
                if let index = resourcesArray.firstIndex(where: { $0["resourceID"] as? String == resourceID }) {
                    // Remove the resource from the array
                    resourcesArray.remove(at: index)
                    
                    // Update the resources array in Firestore
                    libraryRef.updateData([
                        "resources": resourcesArray
                    ]) { error in
                        if let error = error {
                            print("Error updating document: \(error)")
                            completion(false, "Error updating document: \(error.localizedDescription)")
                        } else {
                            // Successfully deleted the resource
                            completion(true, nil)
                        }
                    }
                } else {
                    print("Resource with resourceID \(resourceID) not found in resources array.")
                    completion(false, "Resource not found.")
                }
            } else {
                print("Document does not exist.")
                completion(false, "Document does not exist.")
            }
        }
    }
    
    
  


    func updateResourceInFirestore(libraryID: String, resourceID: String, resourceTitleText: String, sectionData: [[String: Any]], resourceImage: UIImage?, isImageSelected: Bool, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let libraryRef = db.collection("library").document(libraryID)
        
        // Prepare the updated article data
        var updatedArticles: [[String: Any]] = sectionData
        
        // Prepare the update data for Firestore
        let updateData: [String: Any] = [
            "resourceTitle": resourceTitleText,
            "article": updatedArticles
        ]
        
        // Fetch the document from Firestore
        libraryRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var resources = document.get("resources") as? [[String: Any]] ?? []
                
                if let resourceIndex = resources.firstIndex(where: { ($0["resourceID"] as? String) == resourceID }) {
                    // Resource found, update it
                    resources[resourceIndex]["resourceTitle"] = resourceTitleText
                    resources[resourceIndex]["article"] = updatedArticles
                    
                    // Check if an image is selected and upload it
                    if let selectedImage = resourceImage, isImageSelected {
                        let imageName = "\(resourceTitleText).jpg"  // Image name based on the resource title
                        
                        // Delete the old image (if any) and upload the new one
                        self.deleteImageIfExists(imageName: imageName) {
                            // Upload the new image
                            self.uploadImageToStorage(image: selectedImage, imageName: imageName) { imageUrl in
                                if let imageUrl = imageUrl {
                                    // Construct the storage URL for the new image
                                    let storageUrl = "gs://hirevolution.firebasestorage.app/\(imageName)"
                                    resources[resourceIndex]["resourceImage"] = storageUrl
                                    
                                    // Save the updated resources back to Firestore
                                    self.saveUpdatedResources(libraryRef: libraryRef, resources: resources, completion: completion)
                                } else {
                                    print("Failed to upload new image.")
                                    completion(false)
                                }
                            }
                        }
                    } else {
                        // If no image is selected, just save the resource update without the image
                        self.saveUpdatedResources(libraryRef: libraryRef, resources: resources, completion: completion)
                    }
                } else {
                    print("Resource with ID \(resourceID) not found.")
                    completion(false)
                }
            } else {
                print("Document does not exist or error fetching document: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
            }
        }
    }

    // Function to save updated resources to Firestore
    func saveUpdatedResources(libraryRef: DocumentReference, resources: [[String: Any]], completion: @escaping (Bool) -> Void) {
        libraryRef.updateData(["resources": resources]) { error in
            if let error = error {
                print("Error updating resource: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Resource updated successfully.")
                completion(true)
            }
        }
    }

    
    
    // Function to get the current date as a string (you can modify the format as needed)
     func getCurrentDate() -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "MM/dd/yyyy"  // Adjust the format to your needs
         return dateFormatter.string(from: Date())
     }
    
}

class TimeHandler {
    
    // Singleton pattern
    static let shared = TimeHandler()
    
    private init() {}
    
    // Firestore reference
    private let db = Firestore.firestore()
    
    // Method to save interview to Firestore
    func saveInterviewToFirebase(_ interview: ScheduledInterview, completion: @escaping (Bool) -> Void) {
        // Convert the interview date to a Firestore-compatible format (timestamps are typically stored as seconds)
        let interviewData: [String: Any] = [
            "interviewDate": Timestamp(date: interview.interviewDate), // Convert Date to Firestore Timestamp
            "userID": interview.userID, // Link interview with the user's UID
            "jobID": interview.jobID   // Associate interview with the job ID
        ]
        
        // Add the interview to the Firestore collection "users" under the user's UID
        db.collection("users").document(interview.userID).collection("interviews").addDocument(data: interviewData) { error in
            if let error = error {
                print("Error saving interview to Firestore: \(error.localizedDescription)")
                completion(false) // Return false in case of an error
            } else {
                print("Interview successfully saved to Firestore!")
                completion(true) // Return true on success
            }
        }
    }
}


