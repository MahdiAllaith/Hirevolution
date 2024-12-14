<<<<<<< Updated upstream
//
//  SkillsPopup.swift
//  Project-G5
//
//  Created by Mac 14 on 14/11/2024.
//

import UIKit

protocol SkillsPopupDelegate: AnyObject {
    func skillSelected(_ skill: String)
    func skillDeselected(_ skill: String)
}

let skills = ["Problem Solving", "Critical Thinking", "Communication", "Collaboration", "Adaptability", "Time Management", "Creativity", "Project Management", "Tech Skills"]

class SkillsPopup: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var CheckSkillTable: UITableView!
    
    weak var delegate: SkillsPopupDelegate?
    var selectedSkills: [String] = [] // Track selected skills from AddJobView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CheckSkillTable.dataSource = self
        CheckSkillTable.delegate = self
        CheckSkillTable.register(UITableViewCell.self, forCellReuseIdentifier: "ButtonCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath)
        
        // Configure button title and selection state
        let skill = skills[indexPath.row]
        cell.textLabel?.text = skill
        cell.accessoryType = selectedSkills.contains(skill) ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let skill = skills[indexPath.row]
        
        if selectedSkills.contains(skill) {
            selectedSkills.removeAll { $0 == skill }
            delegate?.skillDeselected(skill)
        } else {
            selectedSkills.append(skill)
            delegate?.skillSelected(skill)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}



=======
//
//  SkillsPopup.swift
//  Project-G5
//
//  Created by Mac 14 on 14/11/2024.
//

import UIKit

// MARK: - Protocol Definition
protocol SkillsPopupDelegate: AnyObject {
    func skillSelected(_ skill: String)    // Called when a skill is selected
    func skillDeselected(_ skill: String)  // Called when a skill is deselected
}

// MARK: - Constants
let skills = [
    "Problem Solving",
    "Critical Thinking",
    "Communication",
    "Collaboration",
    "Adaptability",
    "Time Management",
    "Creativity",
    "Project Management",
    "Tech Skills"
]

class SkillsPopup: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var CheckSkillTable: UITableView!  // Table view to display skills
    
    // MARK: - Properties
    weak var delegate: SkillsPopupDelegate?           // Delegate to handle skill selection events
    var selectedSkills: [String] = []                 // Array to track selected skills
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up table view
        CheckSkillTable.dataSource = self
        CheckSkillTable.delegate = self
        CheckSkillTable.register(UITableViewCell.self, forCellReuseIdentifier: "ButtonCell")
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skills.count  // Return the total number of skills
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath)
        
        // Configure the cell with skill text and checkmark for selected state
        let skill = skills[indexPath.row]
        cell.textLabel?.text = skill
        cell.accessoryType = selectedSkills.contains(skill) ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let skill = skills[indexPath.row]
        
        // Toggle selection state
        if selectedSkills.contains(skill) {
            selectedSkills.removeAll { $0 == skill }  // Deselect skill
            delegate?.skillDeselected(skill)
        } else {
            selectedSkills.append(skill)             // Select skill
            delegate?.skillSelected(skill)
        }
        
        // Reload the affected row to update UI
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
>>>>>>> Stashed changes
