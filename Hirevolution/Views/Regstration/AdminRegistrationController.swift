//
//  AdminRegistrationController.swift
//  Hirevolution
//
//  Created by Mac 14 on 11/12/2024.
//

import UIKit

class AdminRegistrationController: UIViewController {

    let authManager = AuthManager.shared
    
    // All Admin Stuff
    @IBOutlet weak var AdminView: UIView!
    @IBOutlet weak var AdminViewBackGroundImage: UIImageView!
    
    @IBOutlet weak var AdminCloseButton: UIButton!
    
    @IBOutlet weak var AdminUserFullName: UITextField!
    @IBOutlet weak var AdminUserEmail: UITextField!
    @IBOutlet weak var AdminUserPassword: UITextField!
    @IBOutlet weak var AdminUserCheckPassword: UITextField!
    @IBOutlet weak var AdminUserTypeSegment: UISegmentedControl!
    
    @IBAction func CloseButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func AdminCreateAccountButton(_ sender: Any) {
        // Validate input fields
        guard let email = AdminUserEmail.text, !email.isEmpty,
              let password = AdminUserPassword.text, !password.isEmpty,
              let confirmPassword = AdminUserCheckPassword.text, !confirmPassword.isEmpty,
              let fullName = AdminUserFullName.text, !fullName.isEmpty else {
            showAlert(title: "Error", message: "Please fill in all the fields.")
            return
        }
        
        // Validate email format
        guard email.contains("@") else {
            showAlert(title: "Error", message: "Please enter a valid email address.")
            return
        }
        
        // Validate password length
        guard password.count >= 6 else {
            showAlert(title: "Error", message: "Password must be at least 6 characters long.")
            return
        }
        
        // Validate password confirmation
        guard password == confirmPassword else {
            showAlert(title: "Error", message: "Passwords do not match.")
            return
        }
        var option: String = ""
        // Determine user type from segmented control
        switch AdminUserTypeSegment.selectedSegmentIndex {
            case 0:
            option = "user"
                break
            
            case 1:
                 option = "company"
                break
            
            case 2:
                 option = "admin"
                break
            
            default:
                break
        }
        
        // Call AuthManager to create a user
        AuthManager.shared.AdminRegisterUser(withEmail: email, password: password, fullName: fullName, option: option) { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlert(title: "Create Account Failed", message: error.localizedDescription)
                } else {
                    self.showAlert(title: "Success", message: "Account created successfully!") {
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?() // Execute completion after the alert is dismissed
        }))
        present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        styleCloseButton()
        styleBackgroundImage()
        
        modifyTF()
        styleLogInStuff()
    }
    
    
    private func styleLogInStuff(){
        AdminView.layer.cornerRadius = 25
        AdminView.clipsToBounds = true
    }
    
    func modifyTF(){
        styleTextField(AdminUserFullName, imageName: "person", offset: -115)
        styleTextField(AdminUserEmail, imageName: "envelope", offset: -45)
        styleTextField(AdminUserPassword, imageName: "lock", offset: 25)
        styleTextField(AdminUserCheckPassword, imageName: "lock", offset: 95)
        
    }
    
    
    private func styleTextField(_ textField: UITextField, imageName: String, offset: CGFloat) {
        // Add image before text
        let imageView = UIImageView(image: UIImage(systemName: imageName)?.withConfiguration(UIImage.SymbolConfiguration(weight: .heavy)))
        imageView.tintColor = UIColor(named: "Blue")
        imageView.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let containerView = UIView()
        containerView.clipsToBounds = true
        
        containerView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 42),
            containerView.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        textField.leftView = containerView
        textField.leftViewMode = .always
        
        textField.layer.cornerRadius = 8
        textField.clipsToBounds = true
        
        // Set placeholder text color to black
        if let placeholderText = textField.placeholder {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]
            )
        }
        
        // Center the text field
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset),
            textField.widthAnchor.constraint(equalToConstant: 306),
            textField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    //background image styleing
    private func styleBackgroundImage() {
        AdminViewBackGroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        // Add constraints to center the image and set size to 800x800 with offset
        NSLayoutConstraint.activate([
            // Width and height constraints for size
            AdminViewBackGroundImage.widthAnchor.constraint(equalToConstant: 800),
            AdminViewBackGroundImage.heightAnchor.constraint(equalToConstant: 800),
            
            // Center the image horizontally and vertically with offset
            AdminViewBackGroundImage.centerXAnchor.constraint(equalTo: AdminViewBackGroundImage.superview!.centerXAnchor, constant: 100), // Move 100 points to the right
            AdminViewBackGroundImage.centerYAnchor.constraint(equalTo: AdminViewBackGroundImage.superview!.centerYAnchor, constant: -50) // Move 50 points up
        ])
    }
    
    func resizeImage(_ image: UIImage, to newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    private func styleCloseButton() {
        if let currentImage = AdminCloseButton.imageView?.image {
            let boldImage = currentImage.withConfiguration(UIImage.SymbolConfiguration(weight: .bold))
            let resizedImage = resizeImage(boldImage, to: CGSize(width: 40, height: 40))
            let templateImage = resizedImage.withRenderingMode(.alwaysTemplate)
            AdminCloseButton.setImage(templateImage, for: .normal)
            AdminCloseButton.tintColor = UIColor(named: "Blue")
        }
    }
}


