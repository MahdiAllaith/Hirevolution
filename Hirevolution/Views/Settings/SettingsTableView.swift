<<<<<<< Updated upstream
//
//  TableDesign.swift
//  Hirevolution
//
//  Created by Mac 14 on 18/11/2024.
//

import UIKit

class SettingsTableView: UITableViewController {
    let authManager = AuthManager.shared

    @IBOutlet weak var SignoutButton: UITableViewCell!
    
    @IBOutlet weak var DarkModeButtonStat: UISwitch!

    @IBAction func DarkModeButton(_ sender: UISwitch) {
        // Check the switch state and toggle dark mode
        let isDarkModeEnabled = sender.isOn
        
        // Set the interface style for the key window
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows.first })
            .first {
            window.overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
        }
        
        // Save the new state in UserDefaults
        UserDefaults.standard.set(isDarkModeEnabled, forKey: "isDarkMode")
        print("Dark mode toggled to \(isDarkModeEnabled ? "ON" : "OFF")")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the dark mode state from UserDefaults
        let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkMode")
        
        // Set the interface style for the key window
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows.first })
            .first {
            window.overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
        }
        
        // Set the UISwitch to reflect the current dark mode state
        DarkModeButtonStat.isOn = isDarkModeEnabled
    }

    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20 // Set the spacing between sections
    }
    
    // Handle cell selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Check if the tapped cell is the SignoutButton cell
        if let cell = tableView.cellForRow(at: indexPath), cell == SignoutButton {
            // Check if the user is logged in
            if authManager.currentUser == nil {
                showNotLoggedInAlert()
            } else {
                showSignOutAlert()
            }
        }
        // Deselect the row after selection for better UX
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // Show not Logged in alert
    private func showNotLoggedInAlert() {
        let alertController = UIAlertController(
            title: "Not Logged In",
            message: "You are not logged in. Please log in to perform this action.",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // Show sign-out alert
    private func showSignOutAlert() {
        let alertController = UIAlertController(
            title: "Sign Out",
            message: "Are you sure you want to sign out?",
            preferredStyle: .alert
        )
        
        // Confirm action
        let confirmAction = UIAlertAction(title: "Sign Out", style: .destructive) { _ in
            self.authManager.signOutUser()
            self.dismiss(animated: true)
            print("User signed out")
        }
        
        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

=======
//
//  TableDesign.swift
//  Hirevolution
//
//  Created by Mac 14 on 18/11/2024.
//

import UIKit

class SettingsTableView: UITableViewController, DarkModeButton {
    
    func setDarkModeButton() {
        let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkMode")
        
        // Set the interface style for the key window based on stored setting
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows.first })
            .first {
            window.overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
        }
        
        // Set the UISwitch to reflect the current dark mode state from UserDefaults
        DarkModeButtonStat.isOn = isDarkModeEnabled
    }

    
    // AuthManager instance to handle user authentication
    let authManager = AuthManager.shared

    // IBOutlet for the Signout button cell
    @IBOutlet weak var SignoutButton: UITableViewCell!
    
    // IBOutlet for the Dark Mode toggle switch
    @IBOutlet weak var DarkModeButtonStat: UISwitch!

    // Action method for Dark Mode toggle switch
    @IBAction func DarkModeButton(_ sender: UISwitch) {
        // Check the switch state and toggle dark mode
        let isDarkModeEnabled = sender.isOn
        
        // Set the interface style for the key window based on the toggle state
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows.first })
            .first {
            window.overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
        }
        
        // Save the new state in UserDefaults to persist the dark mode setting
        UserDefaults.standard.set(isDarkModeEnabled, forKey: "isDarkMode")
        print("Dark mode toggled to \(isDarkModeEnabled ? "ON" : "OFF")")
    }

    // Called when the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // Set the spacing between sections in the table view
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20 // Set the header spacing between sections
    }
    
    // Handle cell selection action
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Check if the tapped cell is the SignoutButton cell
        if let cell = tableView.cellForRow(at: indexPath), cell == SignoutButton {
            // Check if the user is logged in
            if authManager.currentUser == nil {
                // If not logged in, show the appropriate alert
                showNotLoggedInAlert()
            } else {
                // If logged in, show the sign-out confirmation alert
                showSignOutAlert()
            }
        }
        // Deselect the row after selection for better user experience (UX)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // Show an alert when the user is not logged in
    private func showNotLoggedInAlert() {
        let alertController = UIAlertController(
            title: "Not Logged In",
            message: "You are not logged in. Please log in to perform this action.",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        // Present the alert to the user
        present(alertController, animated: true, completion: nil)
    }
    
    // Show an alert to confirm if the user wants to sign out
    private func showSignOutAlert() {
        let alertController = UIAlertController(
            title: "Sign Out",
            message: "Are you sure you want to sign out?",
            preferredStyle: .alert
        )
        
        // Confirm sign-out action
        let confirmAction = UIAlertAction(title: "Sign Out", style: .destructive) { _ in
            self.authManager.signOutUser() // Call sign-out method
            self.dismiss(animated: true) // Dismiss the view controller
            print("User signed out")
        }
        
        // Cancel sign-out action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add actions to the alert controller
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        // Present the alert to the user
        present(alertController, animated: true, completion: nil)
    }
}

>>>>>>> Stashed changes
