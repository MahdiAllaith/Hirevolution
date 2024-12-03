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



