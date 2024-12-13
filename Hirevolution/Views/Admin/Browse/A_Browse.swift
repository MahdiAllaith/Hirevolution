import UIKit
import FirebaseFirestore

class A_Browse: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnUser: UIButton!
    @IBOutlet weak var btnCompany: UIButton!
    @IBOutlet weak var btnJob: UIButton!
    
    var arryapplicants: [String] = []
    var companies: [String] = []
    var jobTitles: [String] = []
    var filteredData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        fetchJobTitles()
        fetchApplicants()
        fetchCompanies()
    }
    
    // Table View DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredData[indexPath.row]
        return cell
    }
    
    // Button Actions for Filtering Data
    @IBAction func btnUserTapped(_ sender: Any) {
        btnUser.isSelected = true
        btnCompany.isSelected = false
        btnJob.isSelected = false
        filteredData = arryapplicants
        filterData(searchText: searchBar.text ?? "")
    }

    @IBAction func btnCompanyTapped(_ sender: Any) {
        btnUser.isSelected = false
        btnCompany.isSelected = true
        btnJob.isSelected = false
        filteredData = companies
        filterData(searchText: searchBar.text ?? "")
    }
    
    @IBAction func btnJobTapped(_ sender: Any) {
        btnUser.isSelected = false
        btnCompany.isSelected = false
        btnJob.isSelected = true
        filteredData = jobTitles
        filterData(searchText: searchBar.text ?? "")
    }
    
    // MARK: - Search Bar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterData(searchText: searchText)
    }
    
    // Filter the data based on search text
    func filterData(searchText: String) {
        if searchText.isEmpty {
            filteredData = [] // Don't show any data when the search bar is empty
        } else {
            filteredData = getCurrentDataSource().filter { item in
                // Only match if the letters are in order within the string
                return matchesPattern(item: item, pattern: searchText)
            }
        }
        tableView.reloadData() // Reload the table view to reflect the changes
    }

    // Function to check if the item matches the search pattern (letter by letter)
    func matchesPattern(item: String, pattern: String) -> Bool {
        var itemIndex = item.lowercased().startIndex
        var patternIndex = pattern.lowercased().startIndex
        
        while itemIndex < item.endIndex && patternIndex < pattern.endIndex {
            if item[itemIndex] == pattern[patternIndex] {
                patternIndex = pattern.index(after: patternIndex) // Move to the next character in the search text
            }
            itemIndex = item.index(after: itemIndex)
        }
        
        // If all characters in the pattern have been matched, return true
        return patternIndex == pattern.endIndex
    }

    // Fetch Applicants from Firestore
    func fetchApplicants() {
        let db = Firestore.firestore()
        db.collection("users")
            .whereField("option", isEqualTo: "user")
            .getDocuments { [weak self] (querySnapshot, error) in
                guard let self = self else { return }

                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    self.arryapplicants = querySnapshot!.documents.compactMap { document in
                        document.data()["fullName"] as? String
                    }
                    if self.btnUser.isSelected {
                        self.filteredData = self.arryapplicants
                    }
                    self.tableView.reloadData()
                }
            }
    }
    
    // Fetch Companies from Firestore
    func fetchCompanies() {
        let db = Firestore.firestore()
        db.collection("users")
            .whereField("option", isEqualTo: "company")
            .getDocuments { [weak self] (querySnapshot, error) in
                guard let self = self else { return }

                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    self.companies = querySnapshot!.documents.compactMap { document in
                        (document.data()["companyProfile"] as? [String: Any])?["companyName"] as? String
                    }
                    if self.btnCompany.isSelected {
                        self.filteredData = self.companies
                    }
                    self.tableView.reloadData()
                }
            }
    }
    
    // Fetch Job Titles from Firestore
    func fetchJobTitles() {
        let db = Firestore.firestore()
        db.collection("jobs") // Access the "jobs" collection
            .getDocuments { [weak self] (querySnapshot, error) in
                guard let self = self else { return }

                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    self.jobTitles = querySnapshot!.documents.compactMap { document in
                        document.data()["jobTitle"] as? String
                    }
                    if self.btnJob.isSelected {
                        self.filteredData = self.jobTitles
                    }
                    self.tableView.reloadData()
                }
            }
    }
    
    // Get the current data source based on selected filter
    func getCurrentDataSource() -> [String] {
        if btnUser.isSelected {
            return arryapplicants
        } else if btnCompany.isSelected {
            return companies
        } else if btnJob.isSelected {
            return jobTitles
        } else {
            return [] // Or return a default array if needed
        }
    }
}
