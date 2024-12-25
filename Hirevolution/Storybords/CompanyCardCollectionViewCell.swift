import UIKit

class CompanyCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblCompanyTitle: UILabel!
    @IBOutlet weak var lblCompanyStatus: UILabel!
    @IBOutlet weak var lblCompanyInterviewed: UILabel!
    @IBOutlet weak var lblCompanyCreatedDate: UILabel!
    @IBOutlet weak var lblCompanyApplied: UILabel!
    @IBOutlet weak var lblCompanyApplications: UILabel!
    @IBOutlet weak var lblCompanyJobStatus: UILabel!
    @IBOutlet weak var lblCompanyInterview: UILabel!
    @IBOutlet weak var lblCompanyDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Enable Auto Layout for all labels
        lblCompanyTitle.translatesAutoresizingMaskIntoConstraints = false
        lblCompanyStatus.translatesAutoresizingMaskIntoConstraints = false
        lblCompanyInterviewed.translatesAutoresizingMaskIntoConstraints = false
        lblCompanyCreatedDate.translatesAutoresizingMaskIntoConstraints = false
        lblCompanyApplied.translatesAutoresizingMaskIntoConstraints = false
        lblCompanyApplications.translatesAutoresizingMaskIntoConstraints = false
        lblCompanyJobStatus.translatesAutoresizingMaskIntoConstraints = false
        lblCompanyInterview.translatesAutoresizingMaskIntoConstraints = false
        lblCompanyDate.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up the constraints for the labels
        setupConstraints()

        // Round the corners of the cell
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setupConstraints() {
        // Stack View for the title and status labels
        let titleStackView = UIStackView(arrangedSubviews: [lblCompanyTitle, lblCompanyStatus, lblCompanyJobStatus])
        titleStackView.axis = .horizontal
        titleStackView.spacing = 12  // Increased spacing for visual clarity
        titleStackView.alignment = .top
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleStackView)

        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        // Stack View for the interview labels
        let interviewStackView = UIStackView(arrangedSubviews: [lblCompanyInterviewed, lblCompanyInterview])
        interviewStackView.axis = .horizontal
        interviewStackView.spacing = 12  // Increased spacing
        interviewStackView.alignment = .top
        interviewStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(interviewStackView)
        
        NSLayoutConstraint.activate([
            interviewStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 16),
            interviewStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            interviewStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        // Stack View for the created date and job date
        let dateStackView = UIStackView(arrangedSubviews: [lblCompanyCreatedDate, lblCompanyDate])
        dateStackView.axis = .horizontal
        dateStackView.spacing = 12  // Increased spacing
        dateStackView.alignment = .top
        dateStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateStackView)
        
        NSLayoutConstraint.activate([
            dateStackView.topAnchor.constraint(equalTo: interviewStackView.bottomAnchor, constant: 16),
            dateStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        // Stack View for the applications labels
        let applicationsStackView = UIStackView(arrangedSubviews: [lblCompanyApplied, lblCompanyApplications])
        applicationsStackView.axis = .horizontal
        applicationsStackView.spacing = 12  // Increased spacing
        applicationsStackView.alignment = .top
        applicationsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(applicationsStackView)
        
        NSLayoutConstraint.activate([
            applicationsStackView.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: 16),
            applicationsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            applicationsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            applicationsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
