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
    let companyProfile: CompanyProfile // Associated company profile
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
    let jobHiredUser: UserProfile? // Optional hired user details
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

class AuthManager {
    static let shared = AuthManager()
    
    var userSession: FirebaseAuth.User? {
        return Auth.auth().currentUser
    }
    
    var currentUser: User?
    
    private init() {}
    
    func initialize() {
        loadSavedSession()
    }
    
    func loadSavedSession() {
        if let savedUID = UserDefaults.standard.string(forKey: "userSessionUID") {
            fetchUserData(uid: savedUID)
        }
    }
    
    func saveUserSession(user: FirebaseAuth.User) {
        UserDefaults.standard.set(user.uid, forKey: "userSessionUID")
    }
    
    func removeUserSession() {
        UserDefaults.standard.removeObject(forKey: "userSessionUID")
    }
    
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
    // this will not create seisson and save data
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
    
    func signOutUser() {
        try? Auth.auth().signOut()
        removeUserSession()
        currentUser = nil
        
        UserDefaults.standard.set(false, forKey: "SignInUser")
        UserDefaults.standard.set("user", forKey: "userType")
    }
    
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

    // MARK: - Reinstated Function: Load Jobs from UserDefaults
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

    func updateJobInDatabase(updatedJob: JobList, completion: @escaping (Error?) -> Void) {
        
        let jobID = updatedJob.jobID
        
        // Firestore reference to the 'jobs' collection
        let jobRef = Firestore.firestore().collection("jobs").document(jobID)
        
        // Prepare the updated job data
        let updatedData: [String: Any] = [
            "jobTitle": updatedJob.jobTitle,
            "jobDescription": updatedJob.jobDescription,
            "jobNotes": updatedJob.jobNotes,
            "jobPotentialSalary": updatedJob.jobPotentialSalary,
            "jobType": updatedJob.jobType,
            "jobSkills": updatedJob.jobSkills,
            "jobFields": updatedJob.jobFields,
            "jobApplyedApplicationsCount": updatedJob.jobApplyedApplicationsCount,
            "jobApplicationsCanceledCount": updatedJob.jobApplicationsCanceledCount,
            "jobRejectedApplicaintsCount": updatedJob.jobRejectedApplicaintsCount,
            "jobInterViewedApplicaintsCount": updatedJob.jobInterViewedApplicaintsCount,
            "jobScheduledForInterviewCount": updatedJob.jobScheduledForInterviewCount,
            "jobHiredUser": updatedJob.jobHiredUser ?? NSNull(),
            "jobViewsCount": updatedJob.jobViewsCount,
            "jobDatePublished": updatedJob.jobDatePublished,
            "ApplyedUsersApplications": updatedJob.ApplyedUsersApplications,
            "jobStatus": updatedJob.jobStatus
        ]
        
        // Update the job document in Firestore
        jobRef.updateData(updatedData) { error in
            if let error = error {
                print("Error updating job in Firestore: \(error)")
                completion(error)
            } else {
                print("Job successfully updated in Firestore.")
                completion(nil)
            }
        }
    }

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
                          var userData = document.data() else {
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
    func fetchUsers(withOption option: String, completion: @escaping ([User]?, Error?) -> Void) {
        let usersRef = Firestore.firestore().collection("users")

        // Create a query that filters documents where the "option" field is equal to the provided option
        usersRef.whereField("option", isEqualTo: option).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let querySnapshot = querySnapshot else {
                completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No users found"]))
                return
            }

            var users: [User] = []

            for document in querySnapshot.documents {
                do {
                    let user = try document.data(as: User.self)
                    users.append(user)
                } catch {
                    print("Error decoding user data: \(error)")
                }
            }

            completion(users, nil)
        }
    }
    func fetchJobs(withCompanyID companyID: String, completion: @escaping ([JobList]?, Error?) -> Void) {
        let jobsRef = Firestore.firestore().collection("jobs")

        // Create a query that filters documents where the "CompanyID" field is equal to the provided companyID
        jobsRef.whereField("CompanyID", isEqualTo: companyID).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let querySnapshot = querySnapshot else {
                completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No jobs found for this company"]))
                return
            }

            var jobs: [JobList] = []

            for document in querySnapshot.documents {
                do {
                    let job = try document.data(as: JobList.self)
                    jobs.append(job)
                } catch {
                    print("Error decoding job data: \(error)")
                }
            }

            completion(jobs, nil)
        }
    }

    func fetchCompanies(completion: @escaping ([User]?, Error?) -> Void) {
        let usersRef = Firestore.firestore().collection("users")

        // Create a query that filters documents where the "option" field is equal to "company"
        usersRef.whereField("option", isEqualTo: "company").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let querySnapshot = querySnapshot else {
                completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No companies found"]))
                return
            }

            var companies: [User] = []

            for document in querySnapshot.documents {
                do {
                    let company = try document.data(as: User.self)
                    companies.append(company)
                } catch {
                    print("Error decoding company data: \(error)")
                }
            }

            completion(companies, nil)
        }
    }
}


