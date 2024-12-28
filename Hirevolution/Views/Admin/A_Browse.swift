//
//  A_Browse.swift
//  Hirevolution
//
//  Created by BP-36-201-22 on 04/12/2024.
//
import Firebase
import UIKit
/// cell identifer is adminBrowseCell
/// circle
/// circle.inset.filled
class A_Browse: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblUser: UILabel!
    
    @IBOutlet weak var btnUser: UIButton!
    
    @IBOutlet weak var lblCompany: UILabel!
    
    @IBOutlet weak var btnCompany: UIButton!
    
    @IBOutlet weak var lblJob: UILabel!
    
    @IBOutlet weak var btnJob: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let authManager = AuthManager.shared
    var users: [[String: Any]] = []
    var companies: [[String: Any]] = []
    var jobs: [[String: Any]] = []
    var userSearch: [String] = []
    var companySearch: [String] = []
    var jobSearch: [String] = []
    var selectedButton: [String] = []
    var filteredData: [String] = []
    var isSearched = false

    enum SelectedSection {
        case user, company, job, none
    }
    var selectedSection: SelectedSection = .none

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        // Load data
        loadUsers()
        loadCompanies()
        loadJobs()
        
        // Ensure buttons are not selected initially
        btnUser.isSelected = false
        btnCompany.isSelected = false
        btnJob.isSelected = false
        
        // Set the selected section to none initially
        selectedSection = .none
        updateTableViewData()
        
        print("ViewDiDLoad")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTableViewData()
        print("ViewDiDAppear")

    }
    
    @IBAction func btnUser(_ sender: Any) {
        // Set the selected section to user and update buttons' state
        selectedSection = .user
        btnUser.isSelected = true
        btnCompany.isSelected = false
        btnJob.isSelected = false
        updateTableViewData()
    }
    
    @IBAction func btnCompany(_ sender: Any) {
        // Set the selected section to company and update buttons' state
        selectedSection = .company
        btnUser.isSelected = false
        btnCompany.isSelected = true
        btnJob.isSelected = false
        updateTableViewData()
    }

    @IBAction func btnJob(_ sender: Any) {
        // Set the selected section to job and update buttons' state
        selectedSection = .job
        btnUser.isSelected = false
        btnCompany.isSelected = false
        btnJob.isSelected = true
        updateTableViewData()
    }

    func updateTableViewData() {
        // Handle the case where no section is selected
        switch selectedSection {
        case .user:
            selectedButton = userSearch
        case .company:
            selectedButton = companySearch
        case .job:
            selectedButton = jobSearch
        case .none:
            selectedButton = [] // Empty array when no section is selected
        }
        print("Selected data: \(selectedButton)")
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearched ? filteredData.count : selectedButton.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminBrowseCell", for: indexPath)
        cell.textLabel?.text = isSearched ? filteredData[indexPath.row] : selectedButton[indexPath.row]
        return cell
    }

    func loadUsers() {
        authManager.fetchUsers { [weak self] users in
            self?.users = users
            self?.userSearch = users.compactMap { $0["fullName"] as? String }
            if self?.selectedSection == .user {
                self?.updateTableViewData()
            }
        }
    }

    func loadCompanies() {
        authManager.fetchCompanies { [weak self] companies in
            print("Fetched Companies: \(companies)")  // Debugging print
            self?.companies = companies
            self?.companySearch = companies.compactMap {
                ($0["companyProfile"] as? [String: Any])?["companyName"] as? String
            }
            if self?.selectedSection == .company {
                self?.updateTableViewData()
            }
        }
    }




    func loadJobs() {
        authManager.fetchJobs { [weak self] jobs in
            self?.jobs = jobs
            self?.jobSearch = jobs.compactMap { $0["jobTitle"] as? String }
            if self?.selectedSection == .job {
                self?.updateTableViewData()
            }
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearched = !searchText.isEmpty
        if isSearched {
            filteredData = selectedButton.filter { $0.lowercased().prefix(searchText.count) == searchText.lowercased() }
        }
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Montader", bundle: nil)
        let index = isSearched ? indexPath.row : indexPath.row

        switch selectedSection {
        case .user:
            if let userProfileVC = storyboard.instantiateViewController(withIdentifier: "adminUserProfile") as? adminUserProfile {
                userProfileVC.userData = users[index]
                print("User Data: \(users[index])")

                
                
                self.navigationController?.pushViewController(userProfileVC, animated: true)
            }
        case .company:
            if let companyProfileVC = storyboard.instantiateViewController(withIdentifier: "adminCompanyProfile") as? adminCompanyProfile {
                companyProfileVC.companyData = companies[index]
                print("Company Data: \(companies[index])")
                companyProfileVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(companyProfileVC, animated: true)
            }
        case .job:
            if let jobViewVC = storyboard.instantiateViewController(withIdentifier: "adminJobView") as? adminJobView {
                jobViewVC.jobData = jobs[index]
                print("Job Data: \(jobs[index])")
                jobViewVC.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(jobViewVC, animated: true)
            }
        case .none:
            // Optionally handle the case when no section is selected
            print("No section selected")
        }
    }
}
