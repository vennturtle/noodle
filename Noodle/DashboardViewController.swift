//
//  DashboardViewController.swift
//  Noodle
//
//  Created by Luis E. Arevalo on 11/8/17.
//  Copyright © 2017 pen15club. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class DashboardViewController: UIViewController {


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @IBAction func logOutAction(_ sender: UIButton) {
        
        
        if FIRAuth.auth()?.currentUser != nil{
            do {
                try FIRAuth.auth()?.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignIn")
                    present(vc, animated: true, completion: nil )
                    
            }
                catch let error as NSError{
                print(error.localizedDescription)
                
                }
                
                
        }
    }
    
}
