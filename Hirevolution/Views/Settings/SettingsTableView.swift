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

