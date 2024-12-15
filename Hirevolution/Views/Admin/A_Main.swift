//
//  A_Main.swift
//  Hirevolution
//
//  Created by BP-36-201-22 on 04/12/2024.
//

import UIKit

class A_Main: UIViewController {

    
    @IBOutlet weak var btnSearchForUser: UIButton!
    
    @IBOutlet weak var btnUpdateLibrary: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func CreateAccountButton(_ sender: Any) {
        let CreateAccountView = UIStoryboard(name: "Mahdi", bundle: nil).instantiateViewController(withIdentifier: "AdminRegistrationController")
        
        self.present(CreateAccountView, animated: true)
    }
    

}
