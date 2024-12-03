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
        let mahdi = UIStoryboard(name: "Mahdi", bundle: nil)
        let yhya = UIStoryboard(name: "Yhya", bundle: nil)
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
        let Profile = yhya.instantiateViewController(withIdentifier: "Profile")
        
        let MainV2 = hussain.instantiateViewController(withIdentifier: "MainV2")
        let ManageJobs = mahdi.instantiateViewController(withIdentifier: "ManageJobs")
        let Company = yhya.instantiateViewController(withIdentifier: "Company")
        
        if userType == "company" {
            self.viewControllers = [MainV2, Brows, Library, ManageJobs, Company]
        } else {
            self.viewControllers = [MainV1, Brows, Library, ApplicationList, Profile]
        }
    }

}
