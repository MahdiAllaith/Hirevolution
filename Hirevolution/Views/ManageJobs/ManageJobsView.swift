//
//  ManageJobsView.swift
//  Hirevolution
//
//  Created by Mac 14 on 21/11/2024.
//

import UIKit

class ManageJobsView: UIViewController {
    let authManager = AuthManager.shared

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }


}
