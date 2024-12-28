//
//  SkillViewController.swift
//  Hirevolution
//
//  Created by Yahya on 10/12/2024.
//


import UIKit

class SkillViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var skillTitleTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Properties
    var onSaveSkill: ((_ skillTitle: String) -> Void)? // Callback to pass data back

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSaveButton()
    }

    // MARK: - Setup Methods
    private func setupSaveButton() {
        saveButton.isEnabled = false // Initially disabled
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        // Add target to validate text field changes
        skillTitleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    // MARK: - Actions
    @objc private func textFieldDidChange() {
        validateInputs()
    }

    private func validateInputs() {
        // Enable Save button only if the text field is not empty
        let isFieldFilled = !(skillTitleTextField.text?.isEmpty ?? true)
        saveButton.isEnabled = isFieldFilled
    }

    @objc private func saveButtonTapped() {
        guard let skillTitle = skillTitleTextField.text, !skillTitle.isEmpty else { return }

        // Pass the skill title back to the previous view controller
        onSaveSkill?(skillTitle)

        // Dismiss the current view controller
        navigationController?.popViewController(animated: true)
    }
}
