//
//  TabBar.swift
//  Hirevolution
//
//  Created by Mac 14 on 18/11/2024.
//

import UIKit

class TabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewControllers()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation
    // to change the nav bar to brows call for button
    func didTapBrowseButton() {
        self.selectedIndex = 1
    }
    
    func updateViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Get the type of user
        let userType = UserDefaults.standard.string(forKey: "userType")
        
        // Getting the views
        let MainV1 = storyboard.instantiateViewController(withIdentifier: "MainV1")
        let Brows = storyboard.instantiateViewController(withIdentifier: "Browse")
        let Library = storyboard.instantiateViewController(withIdentifier: "Library")
        let ApplicationList = storyboard.instantiateViewController(withIdentifier: "JobsList")
        let Profile = storyboard.instantiateViewController(withIdentifier: "Profile")
        
        let MainV2 = storyboard.instantiateViewController(withIdentifier: "MainV2")
        let ManageJobs = storyboard.instantiateViewController(withIdentifier: "ManageJobs")
        let Company = storyboard.instantiateViewController(withIdentifier: "Company")
        
        if userType == "company" {
            self.viewControllers = [MainV2, Brows, Library, ManageJobs, Company]
        } else {
            self.viewControllers = [MainV1, Brows, Library, ApplicationList, Profile]
        }
    }

}
