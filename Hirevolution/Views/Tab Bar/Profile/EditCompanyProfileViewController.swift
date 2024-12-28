//
//  EditCompanyProfileViewController.swift
//  Hirevolution
//
//  Created by Yahya on 10/12/2024.
//


import UIKit

class EditCompanyProfileViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var yearOfEstablishmentTextField: UITextField!
    @IBOutlet weak var numberOfEmployeesTextField: UITextField!
    @IBOutlet weak var ceoTextField: UITextField!
    @IBOutlet weak var networthTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Properties
    var companyDetails: Company? // To receive the current company details
    var onEditCompany: ((_ updatedCompanyDetails: Company) -> Void)? // Callback to pass updated data

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSaveButton()
        setupTextViewAppearance()
        setupTextFieldsAndTextView()
        populateFields()
    }

    // MARK: - Setup Methods
    private func setupSaveButton() {
        saveButton.isEnabled = false // Initially disabled
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    private func setupTextFieldsAndTextView() {
        // Add targets for text fields to validate inputs dynamically
        [companyNameTextField,
         yearOfEstablishmentTextField,
         numberOfEmployeesTextField,
         ceoTextField,
         networthTextField,
        ].forEach {
            $0?.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        }

        // Set text view delegate to validate input
        descriptionTextView.delegate = self

        // Add placeholder for the text view
        descriptionTextView.text = "Enter the company description..."
        descriptionTextView.textColor = .lightGray
    }

    private func setupTextViewAppearance() {
        descriptionTextView.layer.borderWidth = 1.0 // Add a border
        descriptionTextView.layer.borderColor = UIColor.systemGray4.cgColor // Border color
        descriptionTextView.layer.cornerRadius = 5.0 // Rounded corners
        descriptionTextView.backgroundColor = .white // Match UITextField background
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5) // Padding
        descriptionTextView.font = UIFont.systemFont(ofSize: 16) // Match UITextField font
        descriptionTextView.textColor = .black // Match UITextField text color
    }
    
    private func populateFields() {
        guard let company = companyDetails else { return }
        companyNameTextField.text = company.name
        descriptionTextView.text = company.description
        if company.description.isEmpty {
            descriptionTextView.text = "Enter the company description..."
            descriptionTextView.textColor = .lightGray
        }
        yearOfEstablishmentTextField.text = company.yearOfEstablishment
        numberOfEmployeesTextField.text = company.numberOfEmployees
        ceoTextField.text = company.ceo
        networthTextField.text = company.netWorth
    }
    
    // MARK: - Actions
    @objc private func textFieldDidChange() {
        validateInputs()
    }

    private func validateInputs() {
        // Enable Save button only if all fields are filled
        let areFieldsFilled = !(companyNameTextField.text?.isEmpty ?? true) &&
            !(descriptionTextView.text.isEmpty || descriptionTextView.text == "Enter the company description...") &&
            !(yearOfEstablishmentTextField.text?.isEmpty ?? true) &&
            !(numberOfEmployeesTextField.text?.isEmpty ?? true) &&
            !(ceoTextField.text?.isEmpty ?? true) &&
            !(networthTextField.text?.isEmpty ?? true)
        saveButton.isEnabled = areFieldsFilled
    }

    @objc private func saveButtonTapped() {
        guard let companyName = companyNameTextField.text,
              let description = descriptionTextView.text,
              let yearOfEstablishment = yearOfEstablishmentTextField.text,
              let numberOfEmployees = numberOfEmployeesTextField.text,
              let ceoName = ceoTextField.text,
              let networth = networthTextField.text else { return }

        // Create a new updated `Company` object
        let updatedCompanyDetails = Company(
            headerImage: companyDetails?.headerImage, // Keep existing header image if unchanged
            name: companyName,
            description: description,
            yearOfEstablishment: yearOfEstablishment,
            numberOfEmployees: numberOfEmployees,
            ceo: ceoName,
            netWorth: networth
        )

        // Pass the updated company details back using the callback
        onEditCompany?(updatedCompanyDetails)
        
        // Dismiss the current view controller
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextViewDelegate
extension EditCompanyProfileViewController: UITextViewDelegate {
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
            textView.text = "Enter the company description..."
            textView.textColor = .lightGray
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        // Validate inputs dynamically
        validateInputs()
    }
}
