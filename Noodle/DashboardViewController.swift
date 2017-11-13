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
import FirebaseDatabase



class DashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
     var myRef = FIRDatabase.database().reference()
    
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "home", for: indexPath) as! HomeTableViewCell
        
        cell.surveyLabel.text = "this is a test"
        
        return cell
        
    }
    
    
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }


    
   


   
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
    
    @IBAction func unwindFromSurveyList(segue: UIStoryboardSegue){}
}
