//
//  ApplicantsView.swift
//  Hirevolution
//
//  Created by Mac 14 on 13/12/2024.
//

import UIKit

class ApplicantsView: UIViewController, UITableViewDelegate, UITableViewDataSource, goToMessageView {
    
    // MARK: - Protocol Method Implementation
    // Navigate to the message view
    func gotoMassageView() {
        
        // here mohamed add your massage view identifer and by view name and it will automaticaly will present view, all so you can pass data to view for massages
        
//        let MassageView = UIStoryboard(name: "Mohamed", bundle: nil).instantiateViewController(withIdentifier: "some")
//        self.present(MassageView, animated: true)
    }


    // MARK: - Variables
    var passedSelectedJob: JobList? // Holds the selected job details
    var passedUserApplicantionDetails: [UserApplicationsStuff]? // Holds the user applications

    // MARK: - Outlets
    @IBOutlet weak var ViewwdUserApplications: UITableView!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the table view's delegate and data source
        ViewwdUserApplications.delegate = self
        ViewwdUserApplications.dataSource = self
        
        // Reload table view to ensure data is displayed
        self.ViewwdUserApplications.reloadData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    // MARK: - Actions
    @IBAction func BackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passedUserApplicantionDetails?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewedApplicationTableCell", for: indexPath) as! ViewedApplicationTableCell
        
        // Assign the delegate to the cell (for handling event present massage view)
        cell.delegate = self
        
        if let userApplication = passedUserApplicantionDetails?[indexPath.row] {
        cell.config(UserApplican: userApplication)
            
        }
        
        return cell
    }

    // MARK: - UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let MaanageApplicantView = UIStoryboard(name: "Mahdi", bundle: nil).instantiateViewController(withIdentifier: "ManageApplicant") as! ManageApplicant
        
        let userApplication_toPass = passedUserApplicantionDetails?[indexPath.row]
        MaanageApplicantView.theSelectedJob = passedSelectedJob
        MaanageApplicantView.theUserApplicantionDetails = userApplication_toPass
        
        navigationController?.pushViewController(MaanageApplicantView, animated: true)
    }
}
