//
//  TabBar.swift
//  Hirevolution
//
//  Created by Mac 14 on 18/11/2024.
//

import UIKit

class TabBar: UITabBarController, UITabBarControllerDelegate {
    let authManager = AuthManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let isDarkModeEnabled = UserDefaults.standard.string(forKey: "isDarkMode")
        
        if isDarkModeEnabled == "ON"{
            // Set the interface style for the key window based on stored setting
            if let window = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.windows.first })
                .first {
                window.overrideUserInterfaceStyle = (isDarkModeEnabled != nil) ? .dark : .light
            }
            
        }else{
            if let window = UIApplication.shared.connectedScenes
                            .compactMap({ $0 as? UIWindowScene })
                            .first?.windows.first {
                window.overrideUserInterfaceStyle = .light // Force light mode
            }
            
        }
        
        
        updateViewControllers()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    // to change the nav bar to brows call for button
    func didTapBrowseButton() {
        self.selectedIndex = 1
    }
    
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Notification", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        
        if authManager.userSession == nil{
            if tabBarController.selectedIndex == 4  {
                tabBarController.selectedIndex = 0
                showAlert(message: "Your are not signed in, pleas signin or signup to view your profile")
            }else if tabBarController.selectedIndex == 3 {
                tabBarController.selectedIndex = 0
                showAlert(message: "Your are not signed in, pleas signin or signup to view job applications")
            }
                
            
        }
        
    }
    
    func updateViewControllers() {
        let mahdi = UIStoryboard(name: "Mahdi", bundle: nil)
        let yahya = UIStoryboard(name: "Yahya", bundle: nil)
        let hussain = UIStoryboard(name: "Hussain", bundle: nil)
        let mohamed = UIStoryboard(name: "Mohamed", bundle: nil)
        let motader = UIStoryboard(name: "Montader", bundle: nil)
        
        // Get the type of user
        let userType = UserDefaults.standard.string(forKey: "userType")
        
        // Getting the views
        let MainV1 = hussain.instantiateViewController(withIdentifier: "MainV1")
        let Brows = mohamed.instantiateViewController(withIdentifier: "Browse")
        let Library = hussain.instantiateViewController(withIdentifier: "Library")
        let ApplicationList = motader.instantiateViewController(withIdentifier: "JobsList")
        let Profile = yahya.instantiateViewController(withIdentifier: "Profile")
        
        let MainV2 = hussain.instantiateViewController(withIdentifier: "MainV2")
        let ManageJobs = mahdi.instantiateViewController(withIdentifier: "ManageJobs")
        let Company = yahya.instantiateViewController(withIdentifier: "Company")
        
        //admin
        let MainV3 = motader.instantiateViewController(withIdentifier: "A_Main")
        let BrowseV3 = motader.instantiateViewController(withIdentifier: "A_Browse")
        let CompanyV3 = motader.instantiateViewController(withIdentifier: "A_Library")
        
        
        if userType == "company" {
            self.viewControllers = [MainV2, Brows, Library, ManageJobs, Company]
        }else if userType == "admin"{
            self.viewControllers = [MainV3, BrowseV3, CompanyV3]
        }
        else {
            self.viewControllers = [MainV1, Brows, Library, ApplicationList, Profile]
        }
    }

}
