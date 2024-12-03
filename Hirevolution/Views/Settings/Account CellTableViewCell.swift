//
//  Account CellTableViewCell.swift
//  Hirevolution
//
//  Created by Mac 14 on 18/11/2024.
//

import UIKit

class AccountCell: UITableViewCell {

    let authManager = AuthManager.shared
    
    let isUserSignedIn = UserDefaults.standard.bool(forKey: "SignInUser")
    
    // Background blob animation view
    private let smallAnimation: SmallAnimation = {
        let view = SmallAnimation()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Profile Background View (only for signed-in users)
    public let profileBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.layer.cornerRadius = 40 // Half of 80 for a circular background
        view.clipsToBounds = true
        return view
    }()

    // Profile Image View
    public let profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.crop.circle.fill.badge.checkmark")?.withRenderingMode(.alwaysTemplate))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor(named: "Blue")
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    // Name Label
    public let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "asdasdasdasd" // Placeholder text
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Email Label
    public let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "asdasda" // Placeholder text
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // End ===================================================
    
    //not signed in cell
    public let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign in", for: .normal)
        button.setTitleColor(UIColor(named: "Blue") , for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24) // large title equivalent
        button.backgroundColor = UIColor(named: "Blue")?.withAlphaComponent(0.13)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        
        // Add overlay for border effect
        button.layer.borderColor = UIColor(named: "Blue")?.cgColor
        button.layer.borderWidth = 5
        
        return button
    }()
    //-----------------------------------------------------
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        self.clipsToBounds = true
        
        setupViewsForSignedInUser()
    }
    
    
    // this will sereach for the main view controller in witch its called from and will dismiss sewttings and present reg view
    @objc private func didTapSignInButton() {
        // Find the parent view controller using the responder chain
        if let viewController = self.findViewController() {
            // Dismiss the current view controller
            viewController.dismiss(animated: true) {
                // Find the active UIWindowScene and rootViewController
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootVC = windowScene.windows.first?.rootViewController {
                    
                    // Access the storyboard and instantiate RegistrationViewController
                    let RegisterView = UIStoryboard(name: "Mahdi", bundle: nil)
                    if let registrationVC = RegisterView.instantiateViewController(withIdentifier: "RegistrationController") as? RegistrationController {
                        // Present RegistrationViewController
                        rootVC.present(registrationVC, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupViewsForSignedInUser() {
        if isUserSignedIn {
            //getting user data
            
            if let currentUser = authManager.currentUser {
                nameLabel.text = currentUser.fullName
                emailLabel.text = currentUser.eMail
            } else {
                nameLabel.text = "No user data found"
            }

            
            contentView.addSubview(smallAnimation)
            contentView.addSubview(profileBackgroundView)
            profileBackgroundView.addSubview(profileImageView)
            contentView.addSubview(nameLabel)
            contentView.addSubview(emailLabel)
            
            setupConstraintsForSmallAnimation()
            setupConstraintsForUserCell()
            
        }else{
            contentView.addSubview(smallAnimation)
            contentView.addSubview(signInButton)
            
            setupConstraintsForSmallAnimation()
            setupConstraintForSignInButton()
            
            signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)

        }
    }
    
    private func setupConstraintForSignInButton(){
        NSLayoutConstraint.activate([
            signInButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            signInButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 65),
            signInButton.widthAnchor.constraint(equalToConstant: 285),
            signInButton.heightAnchor.constraint(equalToConstant: 65) // Fixed height
        ])
    }
    
    private func setupConstraintsForSmallAnimation() {
        smallAnimation.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            smallAnimation.topAnchor.constraint(equalTo: contentView.topAnchor),
            smallAnimation.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            smallAnimation.widthAnchor.constraint(equalToConstant: 393),
            smallAnimation.heightAnchor.constraint(equalToConstant: 200),
//            smallAnimation.centerXAnchor.constraint(equalTo: contentView.centerXAnchor,constant: -100),
//            smallAnimation.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -50)
        ])
    }
    
    private func setupConstraintsForUserCell() {
        // Profile Background View Constraints (80x80 circle)
        NSLayoutConstraint.activate([
            profileBackgroundView.widthAnchor.constraint(equalToConstant: 80),
            profileBackgroundView.heightAnchor.constraint(equalToConstant: 80),
            profileBackgroundView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30)
        ])

        // Profile Image Constraints (40x40 image inside the background)
        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            profileImageView.centerXAnchor.constraint(equalTo: profileBackgroundView.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: profileBackgroundView.centerYAnchor)
        ])

        // Name Label Constraints
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileBackgroundView.bottomAnchor, constant: 15),
            nameLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.8)
        ])

            // Email Label Constraints
        NSLayoutConstraint.activate([
            emailLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            emailLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.8)
            ])
    }


}
extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}

