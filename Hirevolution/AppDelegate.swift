//
//  AppDelegate.swift
//  Hirevolution
//
//  Created by Mac 14 on 18/11/2024.
//

import UIKit
import Firebase


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // AuthManager instance to handle user authentication
    let authManager = AuthManager.shared
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        // Initialize Firebase
        FirebaseApp.configure()
        
        // Check if the user is already signed in
        if let _ = authManager.userSession {
            UserDefaults.standard.set(true, forKey: "SignInUser")
        }
        
        // Initialize the AuthManager
        authManager.initialize()
        
        // Fetch all jobs data
        authManager.fetchAllJobs { error in
            if let error = error {
                print("Error fetching jobs: \(error.localizedDescription)")
            } else {
                print("AppDelegate: Jobs fetched and stored in UserDefaults successfully.")
            }
        }
        
        // Set initial user type and sign-in state in UserDefaults
        UserDefaults.standard.set("user", forKey: "userType")
        UserDefaults.standard.set(false, forKey: "SignInUser")
        
        // Update the main view controller based on the current user type
        updateMainViewController(for: currentUserType())
        
        // Add an observer for changes in UserDefaults
        NotificationCenter.default.addObserver(self, selector: #selector(userTypeDidChange), name: UserDefaults.didChangeNotification, object: nil)
        
        return true
    }

    // Called when the user type changes in UserDefaults
    @objc private func userTypeDidChange() {
        let userType = currentUserType()
        updateMainViewController(for: userType)
    }

    // Retrieve the current user type from UserDefaults
    private func currentUserType() -> String {
        return UserDefaults.standard.string(forKey: "userType") ?? "user"
    }
    
    // Update the main view controller based on the user type
    func updateMainViewController(for userType: String) {
        // Initialize the new set of view controllers based on the user type
        let newNavController: TabBar
        
        // Set appropriate navigation controller based on user type
        if userType == "company" {
            newNavController = TabBar()  // Create NavController for company
        } else {
            newNavController = TabBar()  // Create NavController for other user types
        }
        
        // Update the view controllers for the new navigation controller
        newNavController.updateViewControllers()
        
        // Check if the rootViewController is a UITabBarController and update it
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let navController = window.rootViewController as? TabBar {
            // Update only the view controllers in the existing NavController
            navController.updateViewControllers()
        }
    }

    // MARK: UISceneSession Lifecycle
    
    // Handle scene session connection
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    // Handle discarded scene sessions
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Handle discarded scene sessions (not implemented here)
    }
}

