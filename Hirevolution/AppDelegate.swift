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

    let authManager = AuthManager.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize Firebase
        FirebaseApp.configure()
        
//         Only interact with Firebase after it is configured
        if let _ = authManager.userSession {
            UserDefaults.standard.set(true, forKey: "SignInUser")
        }
                
        authManager.initialize()
        // Fetch all jobs
        authManager.fetchAllJobs { error in
            if let error = error {
                print("Error fetching jobs: \(error.localizedDescription)")
            } else {
                print("AppDelegate: Jobs fetched and stored in UserDefaults successfully.")
            }
        }

        
        
        UserDefaults.standard.set("admin", forKey: "userType")
        UserDefaults.standard.set(false, forKey: "SignInUser")
        
        updateMainViewController(for: currentUserType())
        
        NotificationCenter.default.addObserver(self, selector: #selector(userTypeDidChange), name: UserDefaults.didChangeNotification, object: nil)
        
        return true
    }

    @objc private func userTypeDidChange() {
        let userType = currentUserType()
        updateMainViewController(for: userType)
    }

    private func currentUserType() -> String {
        return UserDefaults.standard.string(forKey: "userType") ?? "user"
    }
    
    func updateMainViewController(for userType: String) {
        // Initialize the new set of view controllers based on the user type
        
        let newNavController: TabBar
            
            if userType == "company" {
                newNavController = TabBar()  // Create NavController for company
            } else {
                newNavController = TabBar()  // Create NavController for other user types
            }
        
        newNavController.updateViewControllers()
        
        // Check if the rootViewController is a UITabBarController
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let navController = window.rootViewController as? TabBar {
            // Update only the view controllers in the existing NavController
            navController.updateViewControllers()
        }
    }
    
    
    

    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }


}

