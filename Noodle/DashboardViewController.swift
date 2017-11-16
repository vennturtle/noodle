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
     var titles: [String] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "home", for: indexPath) as! HomeTableViewCell
        
        
        //        for s in titles.count{
        cell.surveyLabel.text = titles[indexPath.row]

        
        
        
        return cell
        
    }
    
    
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }


    
   


   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let uid =  FIRAuth.auth()?.currentUser?.uid {
            let ref = myRef.child("Surveys").queryOrdered(byChild: "uid").queryEqual(toValue : uid )
            ref.observeSingleEvent(of:.value, with: { (snapshot) in
                
                // ref.observeSingleEvent(of: .value, with: { snapshot in
                for snap in snapshot.children{
                    
                    let survey = Survey(snapshot: snap as! FIRDataSnapshot)!
                    
                    
                    
                    print(survey.title )
                    print("\n\\n\n\n\n\n")
                    
                    self.titles.append(survey.title)
                    // let title = myDict?[""] as! String
                    //                    self.titles.append(title)
                    //
                    //                    self.t = title
                    
                    //
                    //  cell.surveyLabel.text = title
                    
                    
                    
                    //   print(title)
                }
                self.tableView.reloadData()
                
            })
        }
        
        
    }
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    
    
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
