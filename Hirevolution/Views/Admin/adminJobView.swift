//
//  adminJobView.swift
//  Hirevolution
//
//  Created by user244481 on 12/16/24.
//

import UIKit

class adminJobView: UIViewController {
    let authManager = AuthManager.shared
    var jobData: [String: Any]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Job Data Received: \(jobData ?? [:])")

    }
    
    @IBAction func BackButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        
        if let jobTitle = jobData?["jobTitle"] as? String {
            let alert = UIAlertController(title: "Confirm Delete",
                                          message: "Are you sure you want to delete the job '\(jobTitle)'?",
                                          preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                guard let self = self else { return }

                if let jobID = self.jobData?["jobID"] as? String { // Assuming "id" holds the job ID
                    authManager.deleteJob(withID: jobID) { success in
                        if success {
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            print("Error deleting job")
                        }
                    }
                } else {
                    print("Error: Job ID not found")
                }
            })

            present(alert, animated: true)
        } else {
            print("Error: Job title not found")
        }
    }
        
    }
    


