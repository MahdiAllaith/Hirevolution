import UIKit

class JobRecCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblJobCompany: UILabel!
    @IBOutlet weak var imgJobRec: UIImageView!
    @IBOutlet weak var btnViewJobDetails: UIButton!
    @IBOutlet weak var lblJobLocation: UILabel!
    @IBOutlet weak var lblJobSalary: UILabel!
    @IBOutlet weak var lblJobRole: UILabel!
    @IBOutlet weak var lblJobDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    private func setupLayout() {
        // Disable autoresizing masks for manual constraints
        imgJobRec.translatesAutoresizingMaskIntoConstraints = false
        lblJobTitle.translatesAutoresizingMaskIntoConstraints = false
        lblJobCompany.translatesAutoresizingMaskIntoConstraints = false
        lblJobDescription.translatesAutoresizingMaskIntoConstraints = false
        lblJobLocation.translatesAutoresizingMaskIntoConstraints = false
        lblJobSalary.translatesAutoresizingMaskIntoConstraints = false
        lblJobRole.translatesAutoresizingMaskIntoConstraints = false
        btnViewJobDetails.translatesAutoresizingMaskIntoConstraints = false
        
        /// Add border and rounded corners to the cell
        self.layer.borderColor = UIColor.white.cgColor  // Border color
        self.layer.borderWidth = 1.0  // Border width
        self.layer.cornerRadius = 20.0  // Rounded corners
        self.layer.masksToBounds = true  // Clip content to the rounded corners
        
        // Optionally add a shadow to the cell for a more polished look
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        
        // 1. Image View (fixed size of 100x90) and round corners
        imgJobRec.contentMode = .scaleAspectFill
        imgJobRec.clipsToBounds = true // Ensure the image content is clipped to the rounded corners
        imgJobRec.layer.cornerRadius = 10  // Apply rounded corners to the image
        NSLayoutConstraint.activate([
            imgJobRec.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imgJobRec.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imgJobRec.widthAnchor.constraint(equalToConstant: 100),
            imgJobRec.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        // 2. Job Title (fixed position, dynamic width based on text)
        lblJobTitle.font = UIFont.boldSystemFont(ofSize: 16)
        lblJobTitle.numberOfLines = 0 // Allow the title to expand vertically if needed
        NSLayoutConstraint.activate([
            lblJobTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            lblJobTitle.leadingAnchor.constraint(equalTo: imgJobRec.trailingAnchor, constant: 8),
            lblJobTitle.widthAnchor.constraint(equalToConstant: 244)  // Fixed width
        ])
        
        // 3. Job Company (fixed position, dynamic width based on text)
        lblJobCompany.font = UIFont.systemFont(ofSize: 14)
        lblJobCompany.textColor = .gray
        lblJobCompany.numberOfLines = 1 // Single line but adjusts width based on content
        NSLayoutConstraint.activate([
            lblJobCompany.topAnchor.constraint(equalTo: lblJobTitle.bottomAnchor, constant: 4),
            lblJobCompany.leadingAnchor.constraint(equalTo: imgJobRec.trailingAnchor, constant: 8),
            lblJobCompany.widthAnchor.constraint(equalToConstant: 227)  // Fixed width
        ])
        
        lblJobDescription.font = UIFont.systemFont(ofSize: 12)
               lblJobDescription.textColor = .darkGray
               lblJobDescription.numberOfLines = 0 // Allow description to expand vertically
               NSLayoutConstraint.activate([
                   lblJobDescription.topAnchor.constraint(equalTo: imgJobRec.bottomAnchor, constant: 10),  // Start below the image
                   lblJobDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 37),
                   lblJobDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -37),
                   lblJobDescription.heightAnchor.constraint(greaterThanOrEqualToConstant: 93) // Minimum height
               ])
        
        // 5. Role, Salary, and Location (dynamic width based on text, fixed height)
        let roleSalaryLocationStack = UIStackView(arrangedSubviews: [lblJobRole, lblJobSalary, lblJobLocation])
        roleSalaryLocationStack.axis = .horizontal
        roleSalaryLocationStack.spacing = 8
        roleSalaryLocationStack.alignment = .center
        roleSalaryLocationStack.distribution = .fillProportionally // Let labels grow proportionally
        roleSalaryLocationStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(roleSalaryLocationStack)

        NSLayoutConstraint.activate([
            roleSalaryLocationStack.topAnchor.constraint(equalTo: lblJobDescription.bottomAnchor, constant: 10),
            roleSalaryLocationStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 37),
            roleSalaryLocationStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -37)
        ])
        
        // 6. Button (fixed size, centered horizontally below the labels)
        btnViewJobDetails.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(btnViewJobDetails)
        
        NSLayoutConstraint.activate([
            btnViewJobDetails.topAnchor.constraint(equalTo: roleSalaryLocationStack.bottomAnchor, constant: 12),
            btnViewJobDetails.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            btnViewJobDetails.widthAnchor.constraint(equalToConstant: 165), // Fixed width
            btnViewJobDetails.heightAnchor.constraint(equalToConstant: 53)  // Fixed height
        ])
        
        // 7. ContentView constraints for overall layout
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: 393),
            contentView.heightAnchor.constraint(equalToConstant: 319)
        ])
        
        // ** Round the Role Label **
                lblJobRole.layer.cornerRadius = 11
                lblJobRole.layer.masksToBounds = true
                lblJobRole.textAlignment = .center
    
                
                // ** Round the Salary Label **
                lblJobSalary.layer.cornerRadius = 11
                lblJobSalary.layer.masksToBounds = true
                lblJobSalary.textAlignment = .center
                
                
                // ** Round the Location Label **
                lblJobLocation.layer.cornerRadius = 11
                lblJobLocation.layer.masksToBounds = true
                lblJobLocation.textAlignment = .center
    }
}
