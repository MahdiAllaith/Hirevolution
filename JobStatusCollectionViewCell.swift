import UIKit

class JobStatusCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblJobCompany: UILabel!
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
        lblJobStatus.translatesAutoresizingMaskIntoConstraints = false
        lblJobApplicationDate.translatesAutoresizingMaskIntoConstraints = false

        // Update font sizes for labels
        lblJobStatus.font = UIFont.systemFont(ofSize: 10)
        lblJobApplicationDate.font = UIFont.systemFont(ofSize: 10)

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
        lblJobTitle.font = UIFont.boldSystemFont(ofSize: 14)
        lblJobTitle.numberOfLines = 0
        NSLayoutConstraint.activate([
            lblJobTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            lblJobTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            lblJobTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])

        // 2. Job Company
        lblJobCompany.font = UIFont.systemFont(ofSize: 12)
        lblJobCompany.textColor = .gray
        NSLayoutConstraint.activate([
            lblJobCompany.topAnchor.constraint(equalTo: lblJobTitle.bottomAnchor, constant: 4),
            lblJobCompany.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            lblJobCompany.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])

        // 3. Job Status with "Status: "
        lblJobStatus.text = "Status: \(lblJobStatus.text ?? "")"
        let statusStackView = UIStackView(arrangedSubviews: [lblJobStatus])
        statusStackView.axis = .horizontal
        statusStackView.spacing = 4
        statusStackView.alignment = .leading
        statusStackView.distribution = .fill
        statusStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statusStackView)

        NSLayoutConstraint.activate([
            statusStackView.topAnchor.constraint(equalTo: lblJobCompany.bottomAnchor, constant: 10),
            statusStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            statusStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])

        // 4. Application Date with "Applied on"
        lblJobApplicationDate.text = "Applied on: \(lblJobApplicationDate.text ?? "")"
        let applicationDateStackView = UIStackView(arrangedSubviews: [lblJobApplicationDate])
        applicationDateStackView.axis = .horizontal
        applicationDateStackView.spacing = 4
        applicationDateStackView.alignment = .leading
        applicationDateStackView.distribution = .fill
        applicationDateStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(applicationDateStackView)

        NSLayoutConstraint.activate([
            applicationDateStackView.topAnchor.constraint(equalTo: statusStackView.bottomAnchor, constant: 8), // Reduced space between "Applied on" and button
            applicationDateStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            applicationDateStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])

        // 6. ContentView overall size (Still kept compact)
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: 190), // Width remains the same
            contentView.heightAnchor.constraint(equalToConstant: 130) // Height remains the same
        ])
    }
}
