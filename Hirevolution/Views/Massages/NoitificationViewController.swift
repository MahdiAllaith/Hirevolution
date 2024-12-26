//
//  NoitificationViewController.swift
//  Hirevolution
//
//  Created by BP-36-201-06 on 26/12/2024.
//

import UIKit


class NoitificationViewController: UITableViewController {

    @IBOutlet weak var NotificationView: UITableView!
    
    
    var TimeSech: [ScheduledInterview] = []
        
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return TimeSech.count
    }
    
    override func tableView(_ tableView:
                    UITableView, cellForRowAt IndexPath: IndexPath) ->
    UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: IndexPath)
        
        return cell
    }
    
    
}
