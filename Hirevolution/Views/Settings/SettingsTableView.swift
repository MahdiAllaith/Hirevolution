//
//  TableDesign.swift
//  Hirevolution
//
//  Created by Mac 14 on 18/11/2024.
//

import UIKit

class SettingsTableView: UITableViewController {
    // AuthManager instance to handle user authentication
      let authManager = AuthManager.shared

      // IBOutlet for the Signout button cell
      @IBOutlet weak var SignoutButton: UITableViewCell!
      
      // IBOutlet for the Dark Mode toggle switch
      @IBOutlet weak var DarkModeButtonStat: UISwitch!

      // Method to implement dark mode functionality

      
      // Action for Dark Mode toggle switch
      @IBAction func DarkModeButton(_ sender: UISwitch) {
          let isDarkModeEnabled = sender.isOn
          if let window = UIApplication.shared.connectedScenes
              .compactMap({ $0 as? UIWindowScene })
              .first?.windows.first {
              window.overrideUserInterfaceStyle = isDarkModeEnabled ? .dark : .light
          }
          UserDefaults.standard.set(isDarkModeEnabled ? "ON" : "OFF", forKey: "isDarkMode")
          print("Dark mode toggled to \(isDarkModeEnabled ? "ON" : "OFF")")
      }

      override func viewDidLoad() {
          super.viewDidLoad()
          let isDarkModeEnabled = UserDefaults.standard.string(forKey: "isDarkMode")
          
          if isDarkModeEnabled == "ON"{
              // Set the interface style for the key window based on stored setting
              if let darkMode = DarkModeButtonStat{
                  darkMode.isOn = true
                  print("its true")
              }
              
          }else{
              
              if let darkMode = DarkModeButtonStat{
                  darkMode.isOn = false
                  print("its false")
              }
          }
          
          // Additional setup if needed
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

