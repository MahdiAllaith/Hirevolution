import UIKit

class JobStatusCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblJobCompany: UILabel!
    @IBOutlet weak var lblstatustext: UILabel!
    @IBOutlet weak var lblstatustext2: UILabel!
    @IBOutlet weak var lblJobStatus: UILabel!
    @IBOutlet weak var lblJobApplicationDate: UILabel!
    @IBOutlet weak var btnViewStatusDetails: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }

    private func setupLayout() {
        // Disable autoresizing masks for manual constraints
        lblJobTitle.translatesAutoresizingMaskIntoConstraints = false
        lblJobCompany.translatesAutoresizingMaskIntoConstraints = false
        lblstatustext.translatesAutoresizingMaskIntoConstraints = false
        lblstatustext2.translatesAutoresizingMaskIntoConstraints = false
        lblJobStatus.translatesAutoresizingMaskIntoConstraints = false
        lblJobApplicationDate.translatesAutoresizingMaskIntoConstraints = false
        btnViewStatusDetails.translatesAutoresizingMaskIntoConstraints = false

        // Increase font size for the status labels
        lblstatustext.font = UIFont.systemFont(ofSize: 12)  // Adjust size as needed
        lblJobStatus.font = UIFont.systemFont(ofSize: 12)    // Adjust size as needed
        lblstatustext2.font = UIFont.systemFont(ofSize: 12)  // Adjust size as needed
        lblJobApplicationDate.font = UIFont.systemFont(ofSize: 12)  // Adjust size as needed

        // Add border and rounded corners to the cell
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 20.0
        self.layer.masksToBounds = true

        // Add a shadow for a polished look
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4

        // 1. Job Title
        lblJobTitle.font = UIFont.boldSystemFont(ofSize: 16)
        lblJobTitle.numberOfLines = 0 // Allow the title to expand vertically if needed
        NSLayoutConstraint.activate([
            lblJobTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            lblJobTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            lblJobTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])

        // 2. Job Company
        lblJobCompany.font = UIFont.systemFont(ofSize: 14)
        lblJobCompany.textColor = .gray
        lblJobCompany.numberOfLines = 1
        NSLayoutConstraint.activate([
            lblJobCompany.topAnchor.constraint(equalTo: lblJobTitle.bottomAnchor, constant: 4),
            lblJobCompany.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            lblJobCompany.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])

        // 3. Status Text and Status
        let statusStackView = UIStackView(arrangedSubviews: [lblstatustext, lblJobStatus])
        statusStackView.axis = .horizontal
        statusStackView.spacing = 8
        statusStackView.alignment = .leading  // Align items to the left
        statusStackView.distribution = .fill  // This ensures the content fills the available width
        statusStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statusStackView)

        NSLayoutConstraint.activate([
            statusStackView.topAnchor.constraint(equalTo: lblJobCompany.bottomAnchor, constant: 20), // Increased the constant to move it down
            statusStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            statusStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])

        // 4. Status Text 2 and Application Date
        let status2StackView = UIStackView(arrangedSubviews: [lblstatustext2, lblJobApplicationDate])
        status2StackView.axis = .horizontal
        status2StackView.spacing = 8
        status2StackView.alignment = .leading  // Align items to the left
        status2StackView.distribution = .fill  // This ensures the content fills the available width
        status2StackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(status2StackView)

        NSLayoutConstraint.activate([
            status2StackView.topAnchor.constraint(equalTo: statusStackView.bottomAnchor, constant: 20), // Increased the constant to move it down
            status2StackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            status2StackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])


        // 5. Button (fixed size, positioned independently of other elements)
        btnViewStatusDetails.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(btnViewStatusDetails)

        NSLayoutConstraint.activate([
            btnViewStatusDetails.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 140), // Raise the button (adjust as needed)
            btnViewStatusDetails.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            btnViewStatusDetails.widthAnchor.constraint(equalToConstant: 165),
            btnViewStatusDetails.heightAnchor.constraint(equalToConstant: 53)
        ])

        // 6. ContentView overall size
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: 269),
            contentView.heightAnchor.constraint(equalToConstant: 214)
        ])
    }


}
