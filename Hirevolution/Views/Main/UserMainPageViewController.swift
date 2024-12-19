//
//  UserMainPageViewController.swift
//  Hirevolution
//
//  Created by Guest User on 18/12/2024.
//

import UIKit

class UserMainPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    

    @IBOutlet weak var jobStatusCollectionView: UICollectionView!
    @IBOutlet weak var jobRecCollectionView: UICollectionView!
    var jobRecommendations: [Job] = [
            Job(jobTitle: "Software Engineer", company: "Tech Corp", description: "Join Tech Corp as a Software Engineer and contribute to building cutting-edge software solutions. You will work with a dynamic team to develop scalable systems and improve user experiences. Focus on writing clean, efficient code and collaborating across departments to deliver top-quality products. Grow your career through mentorship and continuous learning in a supportive environment.", role: "Developer", salary: "$80,000", location: "New York", image: UIImage(named: "workCardImage")!),
            Job(jobTitle: "Product Manager", company: "Product Inc.", description: "As a Product Manager at Product Inc., you’ll oversee the development of key products from concept to launch. Collaborate with engineering and design teams to define product features, prioritize tasks, and deliver on business goals. Drive product strategies and use data to continuously improve the user experience and product performance.", role: "Manager", salary: "$100,000", location: "San Francisco", image: UIImage(named: "workCardImage")!),
            Job(jobTitle: "Product Manager", company: "Product Inc.", description: "As a Product Manager at Product Inc., you’ll oversee the development of key products from concept to launch. Collaborate with engineering and design teams to define product features, prioritize tasks, and deliver on business goals. Drive product strategies and use data to continuously improve the user experience and product performance.", role: "Manager", salary: "$100,000", location: "San Francisco", image: UIImage(named: "workCardImage")!),
            Job(jobTitle: "Product Manager", company: "Product Inc.", description: "As a Product Manager at Product Inc., you’ll oversee the development of key products from concept to launch. Collaborate with engineering and design teams to define product features, prioritize tasks, and deliver on business goals. Drive product strategies and use data to continuously improve the user experience and product performance.", role: "Manager", salary: "$100,000", location: "San Francisco", image: UIImage(named: "workCardImage")!),
            // Add more jobs here...
        ]
    override func viewDidLoad() {
        super.viewDidLoad()

        jobRecCollectionView.delegate = self
        jobRecCollectionView.dataSource = self
        jobStatusCollectionView.delegate = self
        jobStatusCollectionView.dataSource = self
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jobRecommendations.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            // Dequeue the cell
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobRecCell", for: indexPath) as! JobRecCollectionViewCell
                    
                    // Get the job data for the current indexPath
                    let job = jobRecommendations[indexPath.row]
                    
                    // Configure the cell with job data
                    cell.lblJobTitle.text = job.jobTitle
                    cell.lblJobCompany.text = job.company
                    cell.lblJobDescription.text = job.description
                    cell.lblJobRole.text = job.role
                    cell.lblJobSalary.text = job.salary
                    cell.lblJobLocation.text = job.location
                    cell.imgJobRec.image = job.image
                    
                    return cell
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
struct Job {
    var jobTitle: String
    var company: String
    var description: String
    var role: String
    var salary: String
    var location: String
    var image: UIImage
}
struct JobStatus {
    var jobTitle: String
    var company: String
    var jobStatus: String?
    var jobApplicationDate: String?
}
