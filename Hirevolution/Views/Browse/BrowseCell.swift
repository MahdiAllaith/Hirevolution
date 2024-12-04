//
//  BrowseCell.swift
//  Hirevolution
//
//  Created by Mac 14 on 22/11/2024.
//

import UIKit

protocol BrowseCellDelegate: AnyObject {
    func didTapViewJobButton(in cell: BrowseCell)
}

class BrowseCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    weak var delegate: BrowseCellDelegate?
    
    
    @IBOutlet weak var ViewHolder: UIView!
    @IBOutlet weak var B_JobTitle: UILabel!
    @IBOutlet weak var B_JobFiledCollection: UICollectionView!
    @IBOutlet weak var B_JobDiscription: UITextView!
    @IBOutlet weak var b_JobCompanyName: UILabel!
    @IBOutlet weak var B_JobViewedCount: UILabel!
    
    
    @IBAction func B_ViewJobButton(_ sender: Any) {
        delegate?.didTapViewJobButton(in: self)
        
    }
    // wating for yhya work
    @IBOutlet weak var CompanyLogo: UIImageView!
    
    private var jobFields: [String] = [] // Store job fields locally for the collection view

    override func awakeFromNib() {
        super.awakeFromNib()
        
        ViewHolder.layer.cornerRadius = 15
        
        // Set up collection view delegate and data source
        B_JobFiledCollection.delegate = self
        B_JobFiledCollection.dataSource = self

    }

    // Configure the cell with job data
    func configureCollectionCells(jobList: JobList) {
        // Set the job title
        B_JobTitle.text = jobList.jobTitle
        B_JobDiscription.text = jobList.jobDescription
        b_JobCompanyName.text = jobList.companyProfile.companyName
        B_JobViewedCount.text = "\(jobList.jobViewsCount)"
        
        // Update the job fields array and reload the collection view
        jobFields = jobList.jobFields
        B_JobFiledCollection.reloadData()
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobFields.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobFiledCollectionCell", for: indexPath)
        
        // Remove old labels to prevent duplicates
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        // Create and configure the label
        let label = UILabel(frame: cell.contentView.bounds)
        label.text = jobFields[indexPath.item]
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16) // Set text to bold
        label.textColor = UIColor(named: "gray")
        label.backgroundColor = .clear // Ensure label background doesn't overlap
        label.numberOfLines = 1 // Adjust as needed
        label.adjustsFontSizeToFitWidth = true // Ensure text adjusts if too long
        label.minimumScaleFactor = 0.5 // Scale down if needed to fit
        
        // Add the label to the cell's content view
        label.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(label)
        
        // Add constraints to ensure the label is always properly displayed
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -5),
            label.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 5),
            label.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -5)
        ])
        
        // Customize the cell background
        cell.contentView.backgroundColor = UIColor.clear
        
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Adjust size based on content (fields are usually short strings)
        return CGSize(width: 160, height: 45)
    }

}

