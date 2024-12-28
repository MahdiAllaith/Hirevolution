//
//  CompanyProfileViewController.swift
//  Hirevolution
//
//  Created by Yahya on 10/12/2024.
//


import UIKit

class CompanyProfileViewController: UIViewController {
    let authManager = AuthManager.shared

    // MARK: - IBOutlets
    @IBOutlet var companyHeaderImage: UIImageView!
    @IBOutlet var companyName: UILabel!
    @IBOutlet var companyDescriptionStackView: UIStackView!
    @IBOutlet var yearOfEstablishmentStackView: UIStackView!
    @IBOutlet var numberOfEmployeesStackView: UIStackView!
    @IBOutlet var ceoStackView: UIStackView!
    @IBOutlet var networthStackView: UIStackView!

    // Company data model
    var company: Company?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCompanyProfileData()
        setupUI()
    }

    private func setupUI() {
        // Populate UI elements with model data or placeholders
        companyHeaderImage.image = company?.headerImage
        companyName.text = company?.name ?? "Company Name"

        // Configure description stack view
        configureStackView(
            stackView: companyDescriptionStackView,
            text: company?.description,
            placeholderText: "You don’t have any company description yet, click on edit to add a description."
        )

        // Configure year of establishment stack view
        configureStackView(
            stackView: yearOfEstablishmentStackView,
            text: company?.yearOfEstablishment,
            placeholderText: "Year of establishment not added."
        )

        // Configure number of employees stack view
        configureStackView(
            stackView: numberOfEmployeesStackView,
            text: company?.numberOfEmployees,
            placeholderText: "Number of employees not added."
        )

        // Configure CEO stack view
        configureStackView(
            stackView: ceoStackView,
            text: company?.ceo,
            placeholderText: "CEO information not added."
        )

        // Configure net worth stack view
        configureStackView(
            stackView: networthStackView,
            text: company?.netWorth,
            placeholderText: "Net worth not added."
        )
    }

    private func configureStackView(stackView: UIStackView, text: String?, placeholderText: String) {
        // Clear previous stack view contents
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if let text = text, !text.isEmpty {
            let labelView = LabelItemView()
            labelView.updateLabel(withText: text)
            stackView.addArrangedSubview(labelView)
        } else {
            let noItemsLabelView = NoItemsLabel()
            noItemsLabelView.updateLabel(withText: placeholderText)
            stackView.addArrangedSubview(noItemsLabelView)
        }
    }

    func saveCompanyProfile() {
        // Ensure you have company data
        guard let company = self.company else {
            print("Company data is missing, cannot save.")
            return
        }

        // If headerImage is a UIImage, you need to convert it to a URL or string
        // You may want to upload the image to Firebase Storage and get the URL.
        // Let's assume the headerImage is a String URL for now. If it is a UIImage, you would upload it to Firebase Storage and get the URL.

        // Placeholder for image URL (assuming headerImage is a String URL, replace it with actual Firebase URL if needed)
        let headerImageURL = company.headerImage  // Assume this is a string URL (replace this with actual logic if needed)
        
        // Map Company model to CompanyProfile model
        let updatedCompanyProfile = CompanyProfile(
            profilebackgroundPictuer: "",  // Assuming headerImage is a URL String
            companyProfileLogo: "gs://hirevolution.firebasestorage.app/tesla-logo-black-2711845411.jpg",  // Replace this with actual logo URL if applicable
            companyName: company.name ,
            companyDescription: company.description ,
            yearOfEstablishment: company.yearOfEstablishment ?? "",
            numberOfEmployees: company.numberOfEmployees ?? "",
            companyCEOName: company.ceo ?? "",
            companyNetworth: company.netWorth ?? ""
        )

        // Access the current user (which contains user ID)
        if let user = authManager.currentUser {
            let userID = user.id
            
            // Firebase save logic here
            AuthManager.shared.updateCompanyProfile(companyId: userID, updatedCompanyProfile: updatedCompanyProfile) { error in
                if let error = error {
                    print("Error updating company profile: \(error.localizedDescription)")
                } else {
                    print("Company profile updated successfully.")
                }
                
                // fetching data to update
                if let userID = self.authManager.currentUser?.id {
                    self.authManager.fetchUserData(uid: userID)
                }
            }
        } else {
            print("No current user found.")
        }
    }
    
    func loadCompanyProfileData() {
        if let companyProfile = self.authManager.currentUser?.companyProfile {
            company = Company(name: companyProfile.companyName,
                              description: companyProfile.companyDescription,
                              yearOfEstablishment: companyProfile.yearOfEstablishment,
                              numberOfEmployees: companyProfile.numberOfEmployees,
                              ceo: companyProfile.companyCEOName,
                              netWorth: companyProfile.companyNetworth)
            setupUI()
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEditCompanyVC",
           let destinationVC = segue.destination as? EditCompanyProfileViewController {
            
            // Pass the current company details to the edit view controller
            destinationVC.companyDetails = self.company
            
            // Define the callback to update the company details upon saving
            destinationVC.onEditCompany = { [weak self] updatedCompanyDetails in
                self?.company = updatedCompanyDetails
                self?.setupUI()
                self?.saveCompanyProfile()
            }
        }
    }
}
