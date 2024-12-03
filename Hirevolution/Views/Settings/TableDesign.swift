//
//  TableDesign.swift
//  Hirevolution
//
//  Created by Mac 14 on 18/11/2024.
//

import UIKit

class TableDesign: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20 // Set the spacing between sections
    }
}
