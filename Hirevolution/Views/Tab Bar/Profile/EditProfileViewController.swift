//
//  EditProfileViewController.swift
//  Hirevolution
//
//  Created by Yahya on 10/12/2024.
//


import UIKit

class EditProfileViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet weak var aboutYouTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Properties
    var onSaveProfile: ((_ name: String, _ role: String, _ about: String) -> Void)? // Callback to pass data back

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSaveButton()
        setupTextViewAppearance()
        setupTextFieldsAndTextView()
    }

    // MARK: - Setup Methods
    private func setupSaveButton() {
        saveButton.isEnabled = false // Initially disabled
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    private func setupTextFieldsAndTextView() {
        // Add targets for text fields to validate inputs dynamically
        [nameTextField, roleTextField].forEach {
            $0?.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }

        // Set text view delegate to validate input
        aboutYouTextView.delegate = self

        // Add placeholder for the text view
        aboutYouTextView.text = "Enter a short description about yourself..."
        aboutYouTextView.textColor = .lightGray
    }

    private func setupTextViewAppearance() {
        aboutYouTextView.layer.borderWidth = 1.0 // Add a border
        aboutYouTextView.layer.borderColor = UIColor.systemGray4.cgColor // Border color
        aboutYouTextView.layer.cornerRadius = 5.0 // Rounded corners
        aboutYouTextView.backgroundColor = .white // Match UITextField background
        aboutYouTextView.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5) // Padding
        aboutYouTextView.font = UIFont.systemFont(ofSize: 16) // Match UITextField font
        aboutYouTextView.textColor = .black // Match UITextField text color
    }
    
    // MARK: - Actions
    @objc private func textFieldDidChange() {
        validateInputs()
    }

    private func validateInputs() {
        // Enable Save button only if all fields are filled
        let areFieldsFilled = !(nameTextField.text?.isEmpty ?? true) &&
                              !(roleTextField.text?.isEmpty ?? true) &&
                              !(aboutYouTextView.text.isEmpty || aboutYouTextView.text == "Enter a short description about yourself...")
        saveButton.isEnabled = areFieldsFilled
    }

    @objc private func saveButtonTapped() {
        guard let name = nameTextField.text,
              let role = roleTextField.text,
              let about = aboutYouTextView.text else { return }

        // Pass the profile details back to the previous view controller
        onSaveProfile?(name, role, about)

        // Dismiss the current view controller
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextViewDelegate
extension EditProfileViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Remove placeholder text when editing begins
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        // Add placeholder text if text view is empty
        if textView.text.isEmpty {
            textView.text = "Enter a short description about yourself..."
            textView.textColor = .lightGray
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        // Validate inputs dynamically
        validateInputs()
    }
}
