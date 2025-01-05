//
//  RegistrationController.swift
//  Hirevolution
//
//  Created by Mac 14 on 18/11/2024.
//

import UIKit

class RegistrationController: UIViewController {
    
    let authManager = AuthManager.shared
    
    // the background image behinde both views
    @IBOutlet weak var BackgroundImage: UIImageView!
    
    //Sub main views
    @IBOutlet weak var SignInView: UIView!
    @IBOutlet weak var LogInView: UIView!
    //close button
    @IBOutlet weak var ColseButton: UIButton!
    //close button action
    @IBAction func CloseRegIsClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    //log in view stuff
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var PasswordTf: UITextField!

    //log in action stuff
    @IBAction func LogInButtonIsClicked(_ sender: Any) {
        // Validate input fields
        guard let email = EmailTF.text, !email.isEmpty,
              let password = PasswordTf.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please enter both email and password.")
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
        
        // Attempt login
        AuthManager.shared.signInUser(withEmail: email, password: password) { error in
            DispatchQueue.main.async {
                if let error = error {
                    // Handle login error
                    self.showAlert(title: "Login Failed", message: "An error occurred during login:\n\(error.localizedDescription)")
                } else {
                    // Success
                    self.showAlert(title: "Success", message: "You have successfully logged in!") {
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

    
    @IBAction func ChangeToRegClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.LogInView.transform = CGAffineTransform(translationX: 0, y: self.LogInView.bounds.height)
            self.LogInView.alpha = 0
        }) { _ in
            
            self.LogInView.isHidden = true
            self.SignInView.isHidden = false
            self.SignInView.transform = CGAffineTransform(translationX: 0, y: self.SignInView.bounds.height)
            UIView.animate(withDuration: 0.5){
                self.SignInView.transform = .identity
                self.SignInView.alpha = 1
            }
        }
    }
    
    // sign up view stuff
    @IBOutlet weak var RegEmailTF: UITextField!
    @IBOutlet weak var RegPasswordTF: UITextField!
    @IBOutlet weak var RegCheckPassTF: UITextField!
    @IBOutlet weak var RegUserName: UITextField!
    @IBOutlet weak var RegTypeUser: UISegmentedControl!
    
    @IBAction func SignupButtonClicked(_ sender: Any) {
        // Validate input fields
        guard let email = RegEmailTF.text, !email.isEmpty,
              let password = RegPasswordTF.text, !password.isEmpty,
              let confirmPassword = RegCheckPassTF.text, !confirmPassword.isEmpty,
              let fullName = RegUserName.text, !fullName.isEmpty else {
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
        
        // Determine user type from segmented control
        let option: String = (RegTypeUser.selectedSegmentIndex == 0) ? "user" : "company"
        
        // Call AuthManager to create a user
        AuthManager.shared.createUser(withEmail: email, password: password, fullName: fullName, option: option) { error in
            DispatchQueue.main.async {
                if let error = error {
                    self.showAlert(title: "Signup Failed", message: error.localizedDescription)
                } else {
                    self.showAlert(title: "Success", message: "Account created successfully!") {
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func ChangeToLogButton(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.SignInView.transform = CGAffineTransform(translationX: 0, y: self.SignInView.bounds.height)
            self.SignInView.alpha = 0
        }) { _ in
            
            self.SignInView.isHidden = true
            self.LogInView.isHidden = false
            self.LogInView.transform = CGAffineTransform(translationX: 0, y: self.LogInView.bounds.height)
            UIView.animate(withDuration: 0.5){
                self.LogInView.transform = .identity
                self.LogInView.alpha = 1
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleCloseButton()
        styleBackgroundImage()
        
        modifyTF()
        styleLogInStuff()
        
        SignInView.transform = CGAffineTransform(translationX: 0, y: self.SignInView.bounds.height)
        
    }
    
    private func styleLogInStuff(){
        LogInView.layer.cornerRadius = 25
        LogInView.clipsToBounds = true
        
        SignInView.layer.cornerRadius = 25
        SignInView.clipsToBounds = true
    }
    
    func modifyTF(){
        //login view fields style and postion
        styleTextField(EmailTF, imageName: "envelope", offset: -65)
        styleTextField(PasswordTf, imageName: "lock", offset: 5)
        
        
        //signup view fields
        styleTextField(RegUserName, imageName: "person", offset: -115)
        styleTextField(RegEmailTF, imageName: "envelope", offset: -45)
        styleTextField(RegPasswordTF, imageName: "lock", offset: 25)
        styleTextField(RegCheckPassTF, imageName: "lock", offset: 95)
        
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
        // Disable autoresizing mask to use Auto Layout
        BackgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        // Add constraints to center the image and set size to 800x800 with offset
        NSLayoutConstraint.activate([
            // Width and height constraints for size
            BackgroundImage.widthAnchor.constraint(equalToConstant: 800),
            BackgroundImage.heightAnchor.constraint(equalToConstant: 800),
            
            // Center the image horizontally and vertically with offset
            BackgroundImage.centerXAnchor.constraint(equalTo: BackgroundImage.superview!.centerXAnchor, constant: 100), // Move 100 points to the right
            BackgroundImage.centerYAnchor.constraint(equalTo: BackgroundImage.superview!.centerYAnchor, constant: -50) // Move 50 points up
        ])
    }
    
    func resizeImage(_ image: UIImage, to newSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    
    //colse button styleing
    private func styleCloseButton() {
        if let currentImage = ColseButton.imageView?.image {
            let boldImage = currentImage.withConfiguration(UIImage.SymbolConfiguration(weight: .bold))
            let resizedImage = resizeImage(boldImage, to: CGSize(width: 40, height: 40))
            let templateImage = resizedImage.withRenderingMode(.alwaysTemplate)
            ColseButton.setImage(templateImage, for: .normal)
            ColseButton.tintColor = UIColor(named: "Blue")
        }
    }
}

