//
//  ExperienceViewController.swift
//  Hirevolution
//
//  Created by Yahya on 07/12/2024.
//


import UIKit

class ExperienceViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var stillWorkingSwitch: UISwitch!
    @IBOutlet weak var aboutTheWorkTextView: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Properties
    private var startDatePicker: UIDatePicker!
    private var endDatePicker: UIDatePicker!
    var onSaveExperience: ((_ experience: Experience) -> Void)? // Callback to pass data back

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePickers()
        setupTextFields()
        setupSaveButton()
    }
    
    // MARK: - Setup Methods
    private func setupDatePickers() {
        // Start Date Picker
        startDatePicker = UIDatePicker()
        startDatePicker.datePickerMode = .date
        startDatePicker.preferredDatePickerStyle = .wheels
        startDatePicker.addTarget(self, action: #selector(startDateChanged), for: .valueChanged)
        
        // End Date Picker
        endDatePicker = UIDatePicker()
        endDatePicker.datePickerMode = .date
        endDatePicker.preferredDatePickerStyle = .wheels
        endDatePicker.addTarget(self, action: #selector(endDateChanged), for: .valueChanged)
        
        // Disable End Date Picker if "Still Working Here" is enabled
        stillWorkingSwitch.addTarget(self, action: #selector(stillWorkingSwitchToggled), for: .valueChanged)
    }

    private func setupTextFields() {
        // Assign the Date Picker as inputView for text fields
        startDateTextField.inputView = startDatePicker
        endDateTextField.inputView = endDatePicker
        
        // Add a toolbar with a Done button for the text fields
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: true)
        
        startDateTextField.inputAccessoryView = toolbar
        endDateTextField.inputAccessoryView = toolbar
    }

    // MARK: - Setup Methods
    private func setupSaveButton() {
        saveButton.isEnabled = false
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        [jobTitleTextField, companyNameTextField, startDateTextField, endDateTextField, aboutTheWorkTextView].forEach {
            $0?.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        }
    }

    // MARK: - Actions
    @objc private func startDateChanged() {
        // Update startDateTextField when date is picked
        let formattedDate = formatDate(startDatePicker.date)
        startDateTextField.text = formattedDate
        validateInputs()
    }

    @objc private func endDateChanged() {
        // Update endDateTextField when date is picked
        let formattedDate = formatDate(endDatePicker.date)
        endDateTextField.text = formattedDate
        validateInputs()
    }

    @objc private func stillWorkingSwitchToggled() {
        // Disable/Enable the endDateTextField based on the switch state
        endDateTextField.isEnabled = !stillWorkingSwitch.isOn
        if stillWorkingSwitch.isOn {
            endDateTextField.text = "" // Clear the end date if switch is enabled
        }
    }

    @objc private func doneButtonTapped() {
        // Dismiss the keyboard or picker
        view.endEditing(true)
    }

    @objc private func textFieldsDidChange() {
        validateInputs()
    }
    
    private func validateInputs() {
        let areFieldsFilled = ![jobTitleTextField.text, companyNameTextField.text, startDateTextField.text]
            .contains { $0?.isEmpty ?? true }
        saveButton.isEnabled = areFieldsFilled
    }
    
    // MARK: - Save Action
    @objc private func saveButtonTapped() {
        guard let jobTitle = jobTitleTextField.text,
              let companyName = companyNameTextField.text,
              let startDate = startDateTextField.text,
              let aboutTheWork = aboutTheWorkTextView.text else { return }
        
        let endDate = endDateTextField.text
        let stillWorking = stillWorkingSwitch.isOn
        
        // Create the work experience object
        let experience = Experience(
            jobTitle: jobTitle,
            companyName: companyName,
            startDate: startDate,
            endDate: endDate,
            isStillWorkingHere: stillWorking,
            aboutTheWork: aboutTheWork
        )
        
        // Pass the data back to UserProfileViewController
        onSaveExperience?(experience)
        
        // Dismiss the current view controller
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper Methods
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}
