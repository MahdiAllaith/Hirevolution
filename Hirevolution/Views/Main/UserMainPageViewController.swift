//
//  UserMainPageViewController.swift
//  Hirevolution
//
//  Created by Guest User on 18/12/2024.
//

import UIKit

class UserMainPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    

    @IBOutlet weak var jobRecCollectionView: UICollectionView!
    var jobRecommendations: [Job] = [
            Job(jobTitle: "Software Engineer", company: "Tech Corp", description: "Develop high-quality software.", role: "Developer", salary: "$80,000", location: "New York", image: UIImage(named: "workCardImage")!),
            Job(jobTitle: "Product Manager", company: "Product Inc.", description: "Lead product development.", role: "Manager", salary: "$100,000", location: "San Francisco", image: UIImage(named: "workCardImage")!),
            // Add more jobs here...
        ]
    override func viewDidLoad() {
        super.viewDidLoad()

        jobRecCollectionView.delegate = self
        jobRecCollectionView.dataSource = self
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
