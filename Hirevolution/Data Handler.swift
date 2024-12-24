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
    var userAbout: String
    var userWorkExperience: [WorkExperience]
    var userSkills: [String]
//    var cv
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

struct ChatMessage: Codable {
    let userID: String  // This will store the ID of the sender
    let message: String // The message content
    let timestamp: Date // Timestamp is optional if you don’t need it

    // Initialize the message
    init(userID: String, message: String, timestamp: Date) {
        self.userID = userID
        self.message = message
        self.timestamp = timestamp
    }
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
                let userProfile = UserProfile(backgroundPictuer: "", userProfileImage: "", userName: "", userAbout: "", userWorkExperience: [], userSkills: [])
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
                let userProfile = UserProfile(backgroundPictuer: "", userProfileImage: "", userName: "", userAbout: "", userWorkExperience: [], userSkills: [])
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
}


