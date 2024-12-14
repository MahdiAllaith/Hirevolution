//
//  ViewedCompanyProfile.swift
//  Hirevolution
//
//  Created by Mac 14 on 12/12/2024.
//

import UIKit

class ViewedCompanyProfile: UIViewController {

    var Profile : CompanyProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func BackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    


}
