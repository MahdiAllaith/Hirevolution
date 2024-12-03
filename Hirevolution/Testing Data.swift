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

struct JobList: Codable{
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
    let jobHiredUser: UserProfile // Hired user details
    var jobViewsCount: Int
    let jobDatePublished: Date
    var ApplyedUsersApplications: [UserApplicationsList] = []
}

struct CompanyProfile: Codable {
    var companyName: String
    var companyDescription: String
}

struct UserProfile: Codable {
    var userName: String
    var userNotes: String
}

struct UserApplicationsList: Codable {
    var appliedJobIDLink: [String]
}

// MARK: - User Model
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

    // MARK: - Initialization
    private init() {}

    // MARK: - Firebase Initialization
    func initialize() {
        loadSavedSession()
    }

    // MARK: - Session Management
    func loadSavedSession() {
        // This should only be called after Firebase has been configured
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

    // MARK: - User Actions
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
                let companyProfile = CompanyProfile(companyName: "Default Company", companyDescription: "Description here")
                userData["companyProfile"] = try? Firestore.Encoder().encode(companyProfile)
            } else {
                let userProfile = UserProfile(userName: fullName, userNotes: "Notes here")
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
                
                // Update UserDefaults for user type
                if user.option == "company" {
                    UserDefaults.standard.set("company", forKey: "userType")
                    self.fetchCompanyJobs{ error in
                        if let error = error {
                            print("Error fetching jobs: \(error.localizedDescription)")
                        } else {
                            print("Company jobs fetched and saved successfully.")
                        }
                    }
                } else {
                    UserDefaults.standard.set("user", forKey: "userType")
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
        
        // Create a job object
        let job = JobList(
            CompanyID: currentUser.id,
            companyProfile: currentUser.companyProfile ?? CompanyProfile(companyName: "Unknown", companyDescription: "No description"),
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
            jobHiredUser: UserProfile(userName: "No user", userNotes: "No notes"),
            jobViewsCount: 0,
            jobDatePublished: Date(),
            ApplyedUsersApplications: []
        )
        
        // Convert job to a dictionary
        do {
            let jobData = try Firestore.Encoder().encode(job)
            
            // Save job to Firestore
            Firestore.firestore().collection("jobs").document().setData(jobData) { error in
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
                    let data = document.data()
                    let job = try Firestore.Decoder().decode(JobList.self, from: data)
                    jobs.append(job)
                } catch {
                    print("Error decoding job data: \(error.localizedDescription)")
                }
            }
            
            // Check if we successfully decoded any jobs
            if jobs.isEmpty {
                completion(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No jobs could be decoded"]))
                return
            }
            
            // Save the decoded jobs into UserDefaults
            let encoder = JSONEncoder()
            do {
                let encodedJobs = try encoder.encode(jobs)
                
                // Try to convert the Data to a String (just for debugging)
                if let jsonString = String(data: encodedJobs, encoding: .utf8) {
                    print("Encoded Jobs as String: \(jsonString)")
                } else {
                    print("Unable to convert encoded jobs to a string.")
                }
                
                // Save to UserDefaults
                UserDefaults.standard.set(encodedJobs, forKey: "ApplicationJobsList")
                print("Jobs successfully saved to UserDefaults.")
                completion(nil)
            } catch {
                completion(error)
            }

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
            
            // Encode the jobs to store in UserDefaults
            do {
                let encoder = JSONEncoder()
                let encodedJobs = try encoder.encode(fetchedJobs)
                
                // Save the encoded jobs to UserDefaults
                UserDefaults.standard.set(encodedJobs, forKey: "companyListedJobs")
                print("Company jobs successfully saved to UserDefaults.")
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}
