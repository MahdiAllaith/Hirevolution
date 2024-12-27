//
//  CVForm.swift
//  Hirevolution
//
//  Created by BP-36-201-14 on 17/12/2024.
//

import UIKit

class CVForm: UITableViewController {
    
    @IBOutlet var firstname: UITextField!
    
    @IBOutlet var lastname: UITextField!
    
    @IBOutlet var email: UITextField!
    
    @IBOutlet var phone: UITextField!
    @IBOutlet var website: UITextField!
    
    
    @IBOutlet var currentjob: UITextField!
    
    @IBOutlet var brief: UITextField!
    
    
    @IBOutlet var companyname: UITextField!
    
    @IBOutlet var jobbrief: UITextField!
    
    
    @IBOutlet var startDateTextField: UITextField!
    @IBOutlet var endDateTextField: UITextField!
    
    @IBOutlet var skillname: UITextField!
    @IBOutlet var skilldescription: UITextField!
    
    var onSave: ((CV) -> Void)?
    
    struct CV: Codable {
        var uuid: String
        var firstname: String
        var lastname: String
        var email: String
        var phone: String
        var website: String
        var currentjob: String
        var brief: String
        var experiences: [Experience]
        var skills: [Skill]
        var creationDate: String // Stores today's date as default

        init(
            uuid: String = UUID().uuidString,
            firstname: String,
            lastname: String,
            email: String,
            phone: String,
            website: String,
            currentjob: String,
            brief: String,
            experiences: [Experience],
            skills: [Skill],
            creationDate: String = CV.getCurrentDate() // Default today's date
        ) {
            self.uuid = uuid
            self.firstname = firstname
            self.lastname = lastname
            self.email = email
            self.phone = phone
            self.website = website
            self.currentjob = currentjob
            self.brief = brief
            self.experiences = experiences
            self.skills = skills
            self.creationDate = creationDate
        }

        private static func getCurrentDate() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: Date())
        }
        
        func formattedCreationDate() -> String {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            let outputFormatter = DateFormatter()
            outputFormatter.dateStyle = .long // e.g., December 27, 2024

            if let date = inputFormatter.date(from: creationDate) {
                return outputFormatter.string(from: date)
            } else {
                return "Invalid Date"
            }
        }
    }

    struct Skill: Codable {
        var name: String
        var description: String
    }

    struct Experience: Codable {
        var companyname: String
        var startdate: String
        var enddate: String
        var jobbrief: String
    }

    var experience: [Experience] = []
    var skills: [Skill] = []

    var startDatePicker: UIDatePicker!
    var endDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePickers()
    }
    
    @IBAction func addexperience(_ sender: Any) {
        if let companyName = companyname.text, !companyName.isEmpty,
           let startDate = startDateTextField.text, !startDate.isEmpty,
           let endDate = endDateTextField.text, !endDate.isEmpty,
           let jobBrief = jobbrief.text, !jobBrief.isEmpty {

            let newExperience = Experience(companyname: companyName, startdate: startDate, enddate: endDate, jobbrief: jobBrief)
            
            experience.append(newExperience)
            
            companyname.text = ""
            startDateTextField.text = ""
            endDateTextField.text = ""
            jobbrief.text = ""
            
            tableView.reloadData()

            let experienceList = experience.map { "\($0.companyname) - \($0.startdate) to \($0.enddate): \($0.jobbrief)" }.joined(separator: "\n")
            let alert = UIAlertController(title: "Experience List", message: experienceList, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Please enter all experience details.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    @IBAction func addskill(_ sender: Any) {
        if let skillName = skillname.text, !skillName.isEmpty,
           let skillDescription = skilldescription.text, !skillDescription.isEmpty {
            
            let newSkill = Skill(name: skillName, description: skillDescription)
            
            skills.append(newSkill)
            
            skillname.text = ""
            skilldescription.text = ""
            
            tableView.reloadData()
            let skillsList = skills.map { "\($0.name): \($0.description)" }.joined(separator: "\n")
                    let alert = UIAlertController(title: "Skills List", message: skillsList, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    present(alert, animated: true)
            
        } else {
                let alert = UIAlertController(title: "Error", message: "Please enter both skill name and description.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        present(alert, animated: true)
            }
    }
    
    func setupDatePickers() {
        // Start Date Picker
        startDatePicker = UIDatePicker()
        startDatePicker.datePickerMode = .date  // Set the mode to date picker
        startDatePicker.preferredDatePickerStyle = .wheels  // Set the style to 'wheels'
        startDatePicker.date = Date()  // Set the current date as the default value
        
        // Set the input view of the start date text field to the date picker
        startDateTextField.inputView = startDatePicker
        
        // Create a toolbar for the start date picker
        let startDateToolbar = UIToolbar()
        startDateToolbar.sizeToFit()
        
        // Add a "Done" button to the toolbar for start date
        let startDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(startDoneButtonPressed))
        startDateToolbar.setItems([startDoneButton], animated: true)
        
        // Set the toolbar as the input accessory view for the start date text field
        startDateTextField.inputAccessoryView = startDateToolbar
        
        // End Date Picker
        endDatePicker = UIDatePicker()
        endDatePicker.datePickerMode = .date  // Set the mode to date picker
        endDatePicker.preferredDatePickerStyle = .wheels  // Set the style to 'wheels'
        endDatePicker.date = Date()  // Set the current date as the default value
        
        // Set the input view of the end date text field to the date picker
        endDateTextField.inputView = endDatePicker
        
        // Create a toolbar for the end date picker
        let endDateToolbar = UIToolbar()
        endDateToolbar.sizeToFit()
        
        // Add a "Done" button to the toolbar for end date
        let endDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(endDoneButtonPressed))
        endDateToolbar.setItems([endDoneButton], animated: true)
        
        // Set the toolbar as the input accessory view for the end date text field
        endDateTextField.inputAccessoryView = endDateToolbar
    }
    
    // MARK: - Done Button Actions
    
    // Start Date Done Button
    @objc func startDoneButtonPressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        startDateTextField.text = dateFormatter.string(from: startDatePicker.date)
        
        // Dismiss the date picker
        self.view.endEditing(true)
    }
    
    // End Date Done Button
    @objc func endDoneButtonPressed() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        endDateTextField.text = dateFormatter.string(from: endDatePicker.date)
        
        // Dismiss the date picker
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func onSave(_ sender: Any) {
        
        let dummySkills: [Skill] = [
            Skill(name: "Swift", description: "Expert in iOS app development using Swift."),
            Skill(name: "Python", description: "Proficient in data analysis and scripting."),
            Skill(name: "JavaScript", description: "Experienced in building web applications with React and Node.js.")
        ]

        let dummyExperiences: [Experience] = [
            Experience(
                companyname: "Tech Solutions Inc.",
                startdate: "2021-03",
                enddate: "2023-07",
                jobbrief: "Developed and maintained several iOS applications with complex user interfaces and backend integration."
            ),
            Experience(
                companyname: "InnovateSoft Ltd.",
                startdate: "2018-05",
                enddate: "2021-02",
                jobbrief: "Led a team of developers in building scalable web applications for e-commerce clients."
            ),
            Experience(
                companyname: "DevStudio",
                startdate: "2015-09",
                enddate: "2018-04",
                jobbrief: "Worked on full-stack solutions for startups, including database design and API development."
            )
        ]

        let cv = CV(
            firstname: "John",
            lastname: "Doe",
            email: "johndoe@example.com",
            phone: "+1234567890",
            website: "https://johndoe.dev",
            currentjob: "Senior iOS Developer",
            brief: "A passionate software engineer with 8+ years of experience in mobile and web application development. Skilled in creating efficient and scalable solutions.",
            experiences: dummyExperiences,
            skills: dummySkills
        )
        
        
        
//        let cv = CV(
//            firstname: firstname.text ?? "",
//            lastname: lastname.text ?? "",
//            email: email.text ?? "",
//            phone: phone.text ?? "",
//            website: website.text ?? "",
//            currentjob: currentjob.text ?? "",
//            brief: brief.text ?? "",
//            experiences: experience,
//            skills: skills
//        )
        
        // Pass the CV object to the next view controller
        onSave?(cv)
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let safeBottomInset = view.safeAreaInsets.bottom
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70 + safeBottomInset, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewControll" {  // Ensure the segue identifier is correct
            if let detailVC = segue.destination as? CVShow {
                
                // Collecting the form data into the CV object
                let cv = CV(
                    firstname: firstname.text ?? "",
                    lastname: lastname.text ?? "",
                    email: email.text ?? "",
                    phone: phone.text ?? "",
                    website: website.text ?? "",
                    currentjob: currentjob.text ?? "",
                    brief: brief.text ?? "",
                    experiences: experience,
                    skills: skills
                )
                
                // Pass the CV object to the next view controller
                detailVC.cv = cv
            }
        }
    }
    
    // MARK: - Table view data source
    
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
